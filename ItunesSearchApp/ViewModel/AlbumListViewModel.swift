//
//  AlbumViewModel.swift
//  ItunesSearchApp
//
//  Created by Dhiman Das on 12.12.25.
//

import SwiftUI
import Observation
import Combine

@Observable
@MainActor
final class AlbumListViewModel {
    
    var searchText: String = "" {
        didSet {
            searchTextSubject.send(searchText)
        }
    }
    var albums: [Album] = []
    var state: FetchState = .idle
    
    private let manager: MediaManager
    private let limit = 20
    private var offset = 0
    
    private var searchTextSubject = CurrentValueSubject<String,Never>("")
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(manager: MediaManager) {
        self.manager = manager
        setupSearchPipeline()
    }
    
    private func setupSearchPipeline() {
        searchTextSubject
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                self.searchTask?.cancel()
                
                if text.isEmpty {
                    self.reset()
                    return
                }
                
                self.searchTask = Task {
                    await self.loadInitial(term: text)
                }
            }
            .store(in: &cancellables)
    }
    
    func reset() {
        offset = 0
        albums.removeAll()
        state = .idle
    }
    
    func loadInitial(term: String) async {
        offset = 0
        albums.removeAll()
        state = .idle
        await loadMore(term: term)
    }

    func loadMore(term: String) async {
        guard state != .isLoading,
              state != .loadedAll else {
            return
        }
        
        state = .isLoading
        
        do {
            let result = try await manager
                .fetchMedia(
                    term: term,
                    type: .album,
                    limit: limit,
                    offset: offset
                )
            
            if result.results.isEmpty {
                state = albums.isEmpty ? .noResults : .loadedAll
                return
            }
            
            albums.append(contentsOf: result.results)
            offset += limit
            state = result.resultCount < limit ? .loadedAll : .idle
            
        } catch {
            state = .error(error.localizedDescription)
        }
    
        
    }
    
}
