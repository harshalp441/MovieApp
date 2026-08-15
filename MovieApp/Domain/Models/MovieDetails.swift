//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

struct MovieDetails: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let runtime: Int?
    let releaseDate: String?
    let genres: [Genre]
    let credits: Credits?
    let videos: Videos?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case runtime
        case releaseDate = "release_date"
        case genres
        case credits
        case videos
    }

    var cast: [CastMember] {
        credits?.cast ?? []
    }

    var trailer: Video? {
        // Look for official YouTube trailer first, then any YouTube trailer, then any YouTube video
        if let officialTrailer = videos?.results.first(where: { $0.isYouTubeTrailer && ($0.official ?? false) }) {
            return officialTrailer
        }
        if let anyTrailer = videos?.results.first(where: \.isYouTubeTrailer) {
            return anyTrailer
        }
        return videos?.results.first(where: { $0.site.caseInsensitiveCompare("YouTube") == .orderedSame })
    }

    var formattedRuntime: String? {
        Formatters.formatRuntime(runtime)
    }

    var formattedRating: String {
        Formatters.formatRating(voteAverage)
    }

    var formattedReleaseYear: String? {
        Formatters.formatReleaseYear(releaseDate)
    }
}

struct Credits: Codable, Hashable {
    let cast: [CastMember]
}

struct Videos: Codable, Hashable {
    let results: [Video]
}
