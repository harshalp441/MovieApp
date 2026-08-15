//
//  MovieRowSkeleton.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct MovieRowSkeleton: View {

    var body: some View {
        HStack(spacing: 14) {
            // Poster placeholder with fixed size
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemGray5))
                .frame(width: 75, height: 110)

            // Content placeholder with fixed sizes
            VStack(alignment: .leading, spacing: 8) {
                // Title lines
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 16)
                    .frame(maxWidth: .infinity)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 130, height: 16)

                // Rating & Year Badges
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: 45, height: 14)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: 50, height: 14)
                }
                .padding(.top, 2)

                // Overview lines
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray6))
                    .frame(height: 12)
                    .frame(maxWidth: .infinity)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray6))
                    .frame(width: 160, height: 12)

                Spacer(minLength: 0)
            }

            Spacer()

            // Favorite Icon placeholder
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 22, height: 22)
        }
        .padding(.vertical, 4)
        .shimmering()
    }
}

#Preview {
    List(0..<4, id: \.self) { _ in
        MovieRowSkeleton()
    }
    .listStyle(.plain)
}
