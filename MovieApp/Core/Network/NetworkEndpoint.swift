//
//  EndPoint.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

enum NetworkEndpoint {
    
    var APIKey: String {
        "0a45c058ffff0ff4fa6c3a9c73bd38d9"
    }

    case popular
    case search(query: String)
    case details(id: Int)

    var baseURL: String {
        "https://api.themoviedb.org"
    }

    var path: String {
        switch self {
        case .popular:
            return "/3/movie/popular"

        case .search:
            return "/3/search/movie"

        case .details(let id):
            return "/3/movie/\(id)"
        }
    }

    var method: String {
        "GET"
    }

    var queryItems: [URLQueryItem] {
        switch self {

        case .popular:
            return [
                URLQueryItem(
                    name: "api_key",
                    value: APIKey
                )
            ]

        case .search(let query):
            return [
                URLQueryItem(
                    name: "query",
                    value: query
                ),
                URLQueryItem(
                    name: "api_key",
                    value: APIKey
                )
                
            ]

        case .details:
            return [
                URLQueryItem(
                    name: "append_to_response",
                    value: "credits,videos"
                ),
                URLQueryItem(
                    name: "api_key",
                    value: APIKey
                )
            ]
        }
    }
}
