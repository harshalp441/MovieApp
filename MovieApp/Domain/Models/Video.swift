//
//  Video.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

struct Video: Identifiable, Codable, Hashable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool?

    var isTrailer: Bool {
        type.caseInsensitiveCompare("Trailer") == .orderedSame ||
        type.caseInsensitiveCompare("Teaser") == .orderedSame
    }

    var isYouTubeTrailer: Bool {
        site.caseInsensitiveCompare("YouTube") == .orderedSame && isTrailer
    }

    var youtubeURL: URL? {
        guard site.caseInsensitiveCompare("YouTube") == .orderedSame, !key.isEmpty else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var youtubeEmbedURL: URL? {
        guard site.caseInsensitiveCompare("YouTube") == .orderedSame, !key.isEmpty else {
            return nil
        }
        return URL(string: "https://www.youtube-nocookie.com/embed/\(key)?playsinline=1&rel=0&modestbranding=1&autoplay=0")
    }
}
