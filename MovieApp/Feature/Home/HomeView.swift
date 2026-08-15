//
//  HomeView.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel? = nil) {
        let defaultStore = DefaultFavoritesStore()
        _viewModel = State(
            initialValue: viewModel ?? HomeViewModel(
                repository: DefaultMovieRepository(),
                favoritesStore: defaultStore
            )
        )
    }

    private var isSearchable: Bool {
        viewModel.movies != nil && viewModel.errorMessage == nil
    }

    var body: some View {
        NavigationStack {
            content
                .animation(.easeInOut(duration: 0.25), value: viewModel.movies)
                .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
                .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
                .navigationTitle("Movies")
                .navigationBarTitleDisplayMode(.large)
                .searchableIf(
                    isSearchable,
                    text: $viewModel.searchText,
                    prompt: "Search movies"
                )
                .task {
                    if (viewModel.movies?.isEmpty ?? true) {
                        await viewModel.loadPopularMovies()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && (viewModel.movies?.isEmpty ?? true) {
            List(0..<4, id: \.self) { _ in
                MovieRowSkeleton()
            }
            .listStyle(.plain)
            .transition(.opacity)
        } else if let error = viewModel.errorMessage, (viewModel.movies?.isEmpty ?? true) {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 44))
                    .foregroundColor(.orange)

                Text("Failed to Load Movies")
                    .font(.headline)

                Text(error)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Try Again") {
                    Task {
                        if !viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            await viewModel.search()
                        } else {
                            await viewModel.loadPopularMovies()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.opacity)
        } else if let movies = viewModel.movies, movies.isEmpty {
            if !viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
                    .transition(.opacity)
            } else {
                ContentUnavailableView(
                    "No Movies",
                    systemImage: "film",
                    description: Text("No movies available right now.")
                )
                .transition(.opacity)
            }
        } else {
            List(viewModel.movies ?? []) { movie in
                NavigationLink {
                    DetailView(
                        viewModel: DetailViewModel(
                            movie: movie,
                            repository: viewModel.repository,
                            favoritesStore: viewModel.favoritesStore
                        )
                    )
                } label: {
                    MovieRow(
                        movie: movie,
                        isFavorite: viewModel.isFavorite(movie),
                        onFavoriteTap: {
                            viewModel.toggleFavorite(movie)
                        }
                    )
                }
            }
            .listStyle(.plain)
            .transition(.opacity)
        }
    }
}

// MARK: - Conditional Searchable Helper

private extension View {
    @ViewBuilder
    func searchableIf(
        _ condition: Bool,
        text: Binding<String>,
        prompt: String
    ) -> some View {
        if condition {
            self.searchable(text: text, prompt: prompt)
        } else {
            self
        }
    }
}

#Preview {
    HomeView()
}
