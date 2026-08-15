//
//  MovieRow.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct MovieRow: View {

    let movie: Movie
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {

        HStack(spacing: 12) {

            AsyncImage(
                url: TMDBImageHelper.poster(
                    path: movie.posterPath,
                    width: 185
                )
            ) { phase in

                switch phase {

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                default:
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .overlay {
                            Image(
                                systemName: "film"
                            )
                            .foregroundStyle(.secondary)
                        }
                }

            }
            .frame(
                width: 80,
                height: 120
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 8
                )
            )

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Label(
                    String(
                        format: "%.1f",
                        movie.voteAverage
                    ),
                    systemImage: "star.fill"
                )
                .font(.subheadline)

                Spacer()
            }

            Spacer()

            Button(
                action: onFavoriteTap
            ) {
                Image(
                    systemName:
                        isFavorite
                        ? "heart.fill"
                        : "heart"
                )
                .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}
