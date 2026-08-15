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
        HStack(spacing: 14) {
            posterContent
                .frame(width: 75, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(movie.formattedRating)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                }
                
                // Release Year
                if let year = movie.formattedReleaseYear {
                    HStack(spacing: 3) {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text(year)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer(minLength: 0)
            }
            
            Spacer()
            
            Button(action: onFavoriteTap) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(isFavorite ? .red : .secondary.opacity(0.6))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)
            .sensoryFeedback(.impact, trigger: isFavorite)
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var posterContent: some View {
        if let url = TMDBImageHelper.poster(path: movie.posterPath, width: 185) {
            CachedAsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholderPoster
                case .empty:
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.systemGray5))
                        .shimmering()
                @unknown default:
                    placeholderPoster
                }
            }
        } else {
            placeholderPoster
        }
    }
    
    private var placeholderPoster: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color(.secondarySystemBackground))
            .overlay {
                Image(systemName: "film")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
    }
}
