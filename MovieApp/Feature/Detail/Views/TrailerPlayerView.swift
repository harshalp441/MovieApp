//
//  TrailerPlayerView.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI
import WebKit

struct TrailerPlayerView: View {

    let video: Video?
    let backdropPath: String?

    @State private var isVideoLoaded = false

    var body: some View {
        ZStack {
            if let video = video, !video.key.isEmpty {
                ZStack {
                    YouTubeWebView(videoKey: video.key) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isVideoLoaded = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .background(Color.black)

                    if !isVideoLoaded {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.systemGray5))
                            .aspectRatio(16 / 9, contentMode: .fit)
                            .shimmering()
                            .transition(.opacity)
                    }
                }
                .onChange(of: video.key) {
                    isVideoLoaded = false
                }
            } else {
                fallbackBackdropView
            }
        }
        .aspectRatio(16 / 9, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    // MARK: - Fallback Backdrop View

    private var fallbackBackdropView: some View {
        ZStack {
            if let url = TMDBImageHelper.backdrop(path: backdropPath, width: 780) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderBackground
                    case .empty:
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .shimmering()
                    default:
                        placeholderBackground
                    }
                }
            } else {
                placeholderBackground
            }

            // Dark gradient overlay for contrast
            LinearGradient(
                colors: [.black.opacity(0.1), .black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )

            Text("No Trailer Available")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.65))
                )
        }
    }

    private var placeholderBackground: some View {
        Rectangle()
            .fill(Color(.secondarySystemBackground))
            .overlay {
                VStack(spacing: 6) {
                    Image(systemName: "film")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondary)
                    Text("No Preview Available")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
    }
}
