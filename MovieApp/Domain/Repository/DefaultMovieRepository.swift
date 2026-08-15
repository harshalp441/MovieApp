//
//  DefaultMovieRepository.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

struct MovieListResponse: Codable {
    let results: [Movie]
}

final class DefaultMovieRepository: MovieRepository {

    func popularMovies() async throws -> [Movie] {

        let response: MovieListResponse =
            try await NetworkClient.request(.popular)

        return response.results
    }

    func searchMovies(
        query: String
    ) async throws -> [Movie] {

        let response: MovieListResponse =
            try await NetworkClient.request(
                .search(query: query)
            )

        return response.results
    }

    func movieDetails(
        id: Int
    ) async throws -> MovieDetails {

        try await NetworkClient.request(
            .details(id: id)
        )
    }
}
