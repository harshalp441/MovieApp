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

    var isYouTubeTrailer: Bool {
        site == "YouTube" &&
        type == "Trailer"
    }
}
