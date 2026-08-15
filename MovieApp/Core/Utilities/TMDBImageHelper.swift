//
//  TMDBImageHelper.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

enum TMDBImageHelper {

    static func poster(
        path: String?,
        width: Int = 342
    ) -> URL? {
        guard let path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path)")
    }

    static func backdrop(
        path: String?,
        width: Int = 1280
    ) -> URL? {
        guard let path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path)")
    }

    static func profile(
        path: String?,
        width: Int = 185
    ) -> URL? {
        guard let path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w\(width)\(path)")
    }
}
