//
//  SongListViewModelTests.swift
//  ItunesSearchAppTests
//

import Testing
import Foundation
@testable import ItunesSearchApp

@MainActor
@Suite("SongListViewModel")
struct SongListViewModelTests {

    // MARK: Helpers

    private func makeSong(id: Int) -> Song {
        Song(
            wrapperType: "track",
            artistID: 1,
            collectionID: 1,
            id: id,
            artistName: "Artist \(id)",
            collectionName: "Album \(id)",
            trackName: "Track \(id)",
            artistViewURL: "",
            collectionViewURL: "https://example.com",
            trackViewURL: "https://example.com/track",
            previewURL: "https://example.com/preview",
            artworkUrl30: "https://example.com/30.jpg",
            artworkUrl60: "https://example.com/60.jpg",
            artworkUrl100: "https://example.com/100.jpg",
            collectionPrice: 9.99,
            trackPrice: 1.29,
            releaseDate: "2020-01-01T00:00:00Z",
            trackCount: 12,
            trackNumber: id,
            trackTimeMillis: 200_000,
            country: "USA",
            currency: "USD",
            primaryGenreName: "Pop",
            collectionArtistName: nil
        )
    }

    private func makeResultData(count: Int, startId: Int = 1) throws -> Data {
        let songs = (startId..<startId + count).map { makeSong(id: $0) }
        return try JSONEncoder().encode(SongResult(resultCount: count, results: songs))
    }

    private func makeViewModel(responses: [String: Data]) -> SongListViewModel {
        SongListViewModel(manager: MediaManager(apiService: MockAPIService(responses: responses)))
    }

    private func makeViewModel(sequential: [Data]) -> SongListViewModel {
        SongListViewModel(manager: MediaManager(apiService: SequentialMockAPIService(responses: sequential)))
    }

    // MARK: - Initial state

    @Test func initialState_isIdleWithNoSongs() {
        let vm = makeViewModel(responses: [:])
        #expect(vm.state == .idle)
        #expect(vm.songs.isEmpty)
        #expect(vm.searchText == "")
    }

    // MARK: - reset()

    @Test func reset_clearsSongsAndSetsIdle() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        #expect(!vm.songs.isEmpty)

        vm.reset()

        #expect(vm.songs.isEmpty)
        #expect(vm.state == .idle)
    }

    @Test func reset_allowsSubsequentLoad() async throws {
        let data = try makeResultData(count: 5)
        let vm = makeViewModel(responses: ["search": data])
        await vm.loadInitial(term: "jack")
        vm.reset()

        await vm.loadInitial(term: "jack")

        #expect(vm.songs.count == 5)
    }

    // MARK: - loadInitial

    @Test func loadInitial_fullPage_setsIdle() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 20)])
        await vm.loadInitial(term: "jack")
        #expect(vm.songs.count == 20)
        #expect(vm.state == .idle)
    }

    @Test func loadInitial_partialPage_setsLoadedAll() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 7)])
        await vm.loadInitial(term: "jack")
        #expect(vm.songs.count == 7)
        #expect(vm.state == .loadedAll)
    }

    @Test func loadInitial_emptyResults_setsNoResults() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 0)])
        await vm.loadInitial(term: "unknown")
        #expect(vm.songs.isEmpty)
        #expect(vm.state == .noResults)
    }

    @Test func loadInitial_onNetworkError_setsErrorState() async throws {
        let vm = makeViewModel(responses: [:])
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

    @Test func loadInitial_clearsExistingSongs() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        await vm.loadInitial(term: "jack")
        #expect(vm.songs.count == 5) // not 10
    }

    // MARK: - loadMore

    @Test func loadMore_appendsNextPage() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 20, startId: 21)
        let vm = makeViewModel(sequential: [p1, p2])
        await vm.loadInitial(term: "jack")
        await vm.loadMore(term: "jack")
        #expect(vm.songs.count == 40)
    }

    @Test func loadMore_partialSecondPage_setsLoadedAll() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 8, startId: 21)
        let vm = makeViewModel(sequential: [p1, p2])
        await vm.loadInitial(term: "jack")
        #expect(vm.state == .idle)

        await vm.loadMore(term: "jack")

        #expect(vm.songs.count == 28)
        #expect(vm.state == .loadedAll)
    }

    @Test func loadMore_emptySecondPage_setsLoadedAll() async throws {
        let p1 = try makeResultData(count: 20)
        let p2 = try makeResultData(count: 0)
        let vm = makeViewModel(sequential: [p1, p2])
        await vm.loadInitial(term: "jack")
        await vm.loadMore(term: "jack")
        #expect(vm.songs.count == 20)
        #expect(vm.state == .loadedAll)
    }

    @Test func loadMore_skipsWhenLoadedAll() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        #expect(vm.state == .loadedAll)

        await vm.loadMore(term: "jack")

        #expect(vm.songs.count == 5)
    }

    @Test func loadMore_skipsWhenIsLoading() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 20)])
        vm.state = .isLoading
        await vm.loadMore(term: "jack")
        #expect(vm.songs.isEmpty)
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
        #expect(vm.songs.count == 50)
        #expect(vm.state == .loadedAll)
    }

    // MARK: - searchText pipeline

    @Test func searchText_emptyString_resetsState() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        await vm.loadInitial(term: "jack")
        #expect(!vm.songs.isEmpty)

        vm.searchText = ""
        try await Task.sleep(nanoseconds: 500_000_000) // > 400 ms debounce

        #expect(vm.songs.isEmpty)
        #expect(vm.state == .idle)
    }

    @Test func searchText_nonEmpty_triggersLoad() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        vm.searchText = "jack"
        try await Task.sleep(nanoseconds: 500_000_000)
        #expect(!vm.songs.isEmpty)
    }

    @Test func searchText_duplicateValue_doesNotReload() async throws {
        let vm = makeViewModel(responses: ["search": try makeResultData(count: 5)])
        vm.searchText = "jack"
        try await Task.sleep(nanoseconds: 500_000_000)
        #expect(vm.songs.count == 5)

        vm.searchText = "jack"
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(vm.songs.count == 5) // not 10
    }
}
