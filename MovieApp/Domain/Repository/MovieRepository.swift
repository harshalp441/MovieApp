//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

protocol MovieRepository {

    func popularMovies() async throws -> [Movie]

    func searchMovies(
        query: String
    ) async throws -> [Movie]

    func movieDetails(
        id: Int
    ) async throws -> MovieDetails
}
