//
//  Formatters.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation

enum Formatters {

    static func formatRuntime(_ minutes: Int?) -> String? {
        guard let minutes = minutes, minutes > 0 else {
            return nil
        }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 && remainingMinutes > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(remainingMinutes)m"
        }
    }

    static func formatReleaseYear(_ dateString: String?) -> String? {
        guard let dateString = dateString, !dateString.isEmpty else {
            return nil
        }
        // TMDb release_date is in "YYYY-MM-DD" format
        let prefix = dateString.prefix(4)
        if prefix.count == 4 && prefix.allSatisfy({ $0.isNumber }) {
            return String(prefix)
        }
        return nil
    }

    static func formatRating(_ rating: Double) -> String {
        String(format: "%.1f", rating)
    }
}
