//
//  AlbumListViewModelTests.swift
//  ItunesSearchAppTests
//

import Testing
import Foundation
@testable import ItunesSearchApp

// MARK: - AlbumListViewModel Test Suite

@MainActor
@Suite("AlbumListViewModel")
struct AlbumListViewModelTests {

    // MARK: Helpers

    private func makeAlbum(id: Int) -> Album {
        Album(
            wrapperType: "collection",
            collectionType: "Album",
            id: id,
            artistID: 1,
            amgArtistID: nil,
            artistName: "Artist \(id)",
            collectionName: "Album \(id)",
            collectionCensoredName: "Album \(id)",
            artistViewURL: nil,
            collectionViewURL: "https://example.com",
            artworkUrl60: "https://example.com/60.jpg",
            artworkUrl100: "https://example.com/100.jpg",
            collectionPrice: 9.99,
            collectionExplicitness: "notExplicit",
            trackCount: 10,
            copyright: nil,
            country: "USA",
            currency: "USD",
            releaseDate: "2020-01-01T00:00:00Z",
            primaryGenreName: "Pop"
        )
    }

    private func makeResultData(count: Int, startId: Int = 1) throws -> Data {
        let albums = (startId..<startId + count).map { makeAlbum(id: $0) }
        return try JSONEncoder().encode(AlbumResult(resultCount: count, results: albums))
    }

    private func makeViewModel(responses: [String: Data]) -> AlbumListViewModel {
        AlbumListViewModel(manager: MediaManager(apiService: MockAPIService(responses: responses)))
    }

    private func makeViewModel(sequential: [Data]) -> AlbumListViewModel {
        AlbumListViewModel(manager: MediaManager(apiService: SequentialMockAPIService(responses: sequential)))
    }

    // MARK: - Initial state

    @Test func initialState_isIdleWithNoAlbums() {
        let vm = makeViewModel(responses: [:])
        #expect(vm.state == .idle)
        #expect(vm.albums.isEmpty)
        #expect(vm.searchText == "")
    }

    // MARK: - reset()

    @Test func reset_clearsAlbumsAndSetsIdle() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        #expect(!vm.albums.isEmpty)

        vm.reset()

        #expect(vm.albums.isEmpty)
        #expect(vm.state == .idle)
    }

    @Test func reset_allowsSubsequentLoad() async throws {
        let data = try makeResultData(count: 5)
        let vm = makeViewModel(responses: ["search": data])
        await vm.loadInitial(term: "jack")
        vm.reset()

        await vm.loadInitial(term: "jack")

        #expect(vm.albums.count == 5)
    }

    // MARK: - loadInitial

    @Test func loadInitial_fullPage_setsIdle() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 20)])
        await vm.loadInitial(term: "jack")
        #expect(vm.albums.count == 20)
        #expect(vm.state == .idle)
    }

    @Test func loadInitial_partialPage_setsLoadedAll() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 7)])
        await vm.loadInitial(term: "jack")
        #expect(vm.albums.count == 7)
        #expect(vm.state == .loadedAll)
    }

    @Test func loadInitial_emptyResults_setsNoResults() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 0)])
        await vm.loadInitial(term: "unknown")
        #expect(vm.albums.isEmpty)
        #expect(vm.state == .noResults)
    }

    @Test func loadInitial_onNetworkError_setsErrorState() async throws {
        let vm = makeViewModel(responses: [:]) // no key → APIError.invalidURL
        await vm.loadInitial(term: "jack")
        guard case .error = vm.state else {
            Issue.record("Expected .error state, got \(vm.state)")
            return
        }
    }

    @Test func loadInitial_errorState_hasNonEmptyMessage() async throws {
        let vm = makeViewModel(responses: [:])
        await vm.loadInitial(term: "jack")
        guard case .error(let msg) = vm.state else {
            Issue.record("Expected .error state")
            return
        }
        #expect(!msg.isEmpty)
    }

    @Test func loadInitial_clearsExistingAlbums() async throws {
        // Calling loadInitial twice must not double the results
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        await vm.loadInitial(term: "jack")
        #expect(vm.albums.count == 5)
    }

    // MARK: - loadMore

    @Test func loadMore_appendsNextPage() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 20, startId: 21)
        let vm = makeViewModel(sequential: [p1, p2])
        await vm.loadInitial(term: "jack")
        await vm.loadMore(term: "jack")
        #expect(vm.albums.count == 40)
    }

    @Test func loadMore_partialSecondPage_setsLoadedAll() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 8, startId: 21)
        let vm = makeViewModel(sequential: [p1, p2])
        await vm.loadInitial(term: "jack")
        #expect(vm.state == .idle)

        await vm.loadMore(term: "jack")

        #expect(vm.albums.count == 28)
        #expect(vm.state == .loadedAll)
    }

    @Test func loadMore_emptySecondPage_setsLoadedAll() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 0)
        let vm = makeViewModel(sequential: [p1, p2])
        await vm.loadInitial(term: "jack")
        await vm.loadMore(term: "jack")
        #expect(vm.albums.count == 20)
        #expect(vm.state == .loadedAll)
    }

    @Test func loadMore_skipsWhenLoadedAll() async throws {
        // partial first page → .loadedAll; subsequent loadMore must be a no-op
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        #expect(vm.state == .loadedAll)

        await vm.loadMore(term: "jack")

        #expect(vm.albums.count == 5)
    }

    @Test func loadMore_skipsWhenIsLoading() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 20)])
        vm.state = .isLoading
        await vm.loadMore(term: "jack")
        #expect(vm.albums.isEmpty)
        #expect(vm.state == .isLoading)
    }

    // MARK: - Multi-page accumulation

    @Test func multiPageLoad_accumulatesCorrectCount() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 20, startId: 21)
        let p3 = try makeResultData(count: 10, startId: 41)
        let vm = makeViewModel(sequential: [p1, p2, p3])
        await vm.loadInitial(term: "jack")
        await vm.loadMore(term: "jack")
        await vm.loadMore(term: "jack")
        #expect(vm.albums.count == 50)
        #expect(vm.state == .loadedAll)
    }

    // MARK: - searchText pipeline

    @Test func searchText_emptyString_resetsState() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        #expect(!vm.albums.isEmpty)

        vm.searchText = ""
        try await Task.sleep(nanoseconds: 500_000_000) // > 400 ms debounce

        #expect(vm.albums.isEmpty)
        #expect(vm.state == .idle)
    }

    @Test func searchText_nonEmpty_triggersLoad() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        vm.searchText = "jack"
        try await Task.sleep(nanoseconds: 500_000_000) // > 400 ms debounce
        #expect(!vm.albums.isEmpty)
    }

    @Test func searchText_duplicateValue_doesNotReload() async throws {
        // removeDuplicates() in the pipeline prevents a redundant fetch
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        vm.searchText = "jack"
        try await Task.sleep(nanoseconds: 500_000_000)
        #expect(vm.albums.count == 5)

        vm.searchText = "jack" // same value — should not trigger another load
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(vm.albums.count == 5) // still 5, not 10
    }
}
