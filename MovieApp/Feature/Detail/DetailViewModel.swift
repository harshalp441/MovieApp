//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class DetailViewModel {

    let movieId: Int
    let initialMovie: Movie?
    let repository: MovieRepository
    let favoritesStore: FavoritesStoreProtocol

    private(set) var movieDetails: MovieDetails?
    private(set) var isLoading: Bool = false
    var errorMessage: String?

    var title: String {
        movieDetails?.title ?? initialMovie?.title ?? "Movie"
    }

    var backdropPath: String? {
        movieDetails?.backdropPath
    }

    var isFavorite: Bool {
        favoritesStore.isFavorite(movieId)
    }

    init(
        movie: Movie,
        repository: MovieRepository = DefaultMovieRepository(),
        favoritesStore: FavoritesStoreProtocol
    ) {
        self.movieId = movie.id
        self.initialMovie = movie
        self.repository = repository
        self.favoritesStore = favoritesStore
    }

    init(
        movieId: Int,
        initialMovie: Movie? = nil,
        repository: MovieRepository = DefaultMovieRepository(),
        favoritesStore: FavoritesStoreProtocol
    ) {
        self.movieId = movieId
        self.initialMovie = initialMovie
        self.repository = repository
        self.favoritesStore = favoritesStore
    }

    func loadMovieDetails() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let details = try await repository.movieDetails(id: movieId)
            guard !Task.isCancelled else { return }
            self.movieDetails = details
        } catch is CancellationError {
            // Dismissed or cancelled silently
        } catch {
            guard !Task.isCancelled else { return }
            self.errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite() {
        favoritesStore.toggleFavorite(movieId)
    }
}
