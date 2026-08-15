//
//  DetailView.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct DetailView: View {

    @State var viewModel: DetailViewModel
    @State private var showNavTitle = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let details = viewModel.movieDetails {
                    // Hero Trailer / Backdrop
                    TrailerPlayerView(
                        video: details.trailer,
                        backdropPath: details.backdropPath ?? details.posterPath
                    )
                    .padding(.horizontal)

                    // Header Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text(details.title)
                            .font(.title.weight(.bold))
                            .foregroundColor(.primary)

                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.subheadline)
                                Text(details.formattedRating)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.yellow.opacity(0.15))
                            )

                            if let runtime = details.formattedRuntime {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                    Text(runtime)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }

                            if let year = details.formattedReleaseYear {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                    Text(year)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        // Genres
                        if !details.genres.isEmpty {
                            FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
                                ForEach(details.genres) { genre in
                                    GenrePill(name: genre.name)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Storyline
                    if let overview = details.overview, !overview.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Storyline")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(overview)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)
                    }

                    // Cast
                    if !details.cast.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Top Cast")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(alignment: .top, spacing: 12) {
                                    ForEach(details.cast) { member in
                                        CastMemberCard(member: member)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                } else if viewModel.isLoading {
                    DetailSkeletonView(initialMovie: viewModel.initialMovie)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 44))
                            .foregroundColor(.orange)

                        Text("Failed to Load Details")
                            .font(.headline)

                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Try Again") {
                            Task {
                                await viewModel.loadMovieDetails()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                }
            }
            .padding(.vertical)
        }
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { _, offset in
            // Reveal navigation title when in-body title scrolls past top navigation bar
            let shouldShow = offset > 160
            if shouldShow != showNavTitle {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showNavTitle = shouldShow
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .opacity(showNavTitle ? 1.0 : 0.0)
                    .offset(y: showNavTitle ? 0 : 6)
                    .animation(.easeInOut(duration: 0.2), value: showNavTitle)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .primary)
                        .font(.subheadline)
                }
                .sensoryFeedback(.impact, trigger: viewModel.isFavorite)
            }
        }
        .task {
            if viewModel.movieDetails == nil {
                await viewModel.loadMovieDetails()
            }
        }
    }
}
