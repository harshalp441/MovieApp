//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    let repository: MovieRepository
    let favoritesStore: FavoritesStoreProtocol

    private var searchTask: Task<Void, Never>?

    private(set) var movies: [Movie]?

    var searchText = "" {
        didSet {
            scheduleSearch()
        }
    }

    private(set) var isLoading = false

    var errorMessage: String?

    init(
        repository: MovieRepository = DefaultMovieRepository(),
        favoritesStore: FavoritesStoreProtocol
    ) {
        self.repository = repository
        self.favoritesStore = favoritesStore
    }

    func loadPopularMovies() async {
        await load { [weak self] in
            guard let self = self else { return nil }
            return try await self.repository.popularMovies()
        }
    }

    func refresh() async {
        if searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {
            await loadPopularMovies()
        } else {
            await search()
        }
    }

    func search() async {
        let query = searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !query.isEmpty else {
            await loadPopularMovies()
            return
        }

        await load { [weak self] in
            guard let self = self else { return nil }
            return try await self.repository.searchMovies(
                query: query
            )
        }
    }

    func isFavorite(
        _ movie: Movie
    ) -> Bool {
        favoritesStore.isFavorite(movie.id)
    }

    func toggleFavorite(
        _ movie: Movie
    ) {
        favoritesStore.toggleFavorite(movie.id)
    }

    private func load(
        operation: () async throws -> [Movie]?
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            if !Task.isCancelled {
                isLoading = false
            }
        }

        do {
            let result = try await operation()
            guard !Task.isCancelled else { return }
            movies = result
        } catch is CancellationError {
            // Request was cancelled (e.g. user typed next character), ignore silently
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }

    private func scheduleSearch() {
        searchTask?.cancel()

        searchTask = Task { [weak self] in
            try? await Task.sleep(
                for: .milliseconds(350)
            )

            guard !Task.isCancelled else {
                return
            }

            await self?.search()
        }
    }
}
