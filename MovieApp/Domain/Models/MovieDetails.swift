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
        case genres
        case credits
        case videos
    }

    var cast: [CastMember] {
        credits?.cast ?? []
    }

    var trailer: Video? {
        videos?.results.first(where: \.isYouTubeTrailer)
    }
}

struct Credits: Codable, Hashable {
    let cast: [CastMember]
}

struct Videos: Codable, Hashable {
    let results: [Video]
}
