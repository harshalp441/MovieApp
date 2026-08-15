//
//  Movie.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let overview: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }

    var formattedReleaseYear: String? {
        Formatters.formatReleaseYear(releaseDate)
    }

    var formattedRating: String {
        Formatters.formatRating(voteAverage)
    }
}
