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

    var body: some View {
        NavigationStack {
            content
                .animation(.easeInOut(duration: 0.25), value: viewModel.movies)
                .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
                .navigationTitle("Movies")
                .navigationBarTitleDisplayMode(.large)
                .searchable(
                    text: $viewModel.searchText,
                    prompt: "Search movies"
                )
                .task {
                    if (viewModel.movies?.isEmpty ?? true) {
                        await viewModel.loadPopularMovies()
                    }
                }
                .alert(
                    "Something went wrong",
                    isPresented: Binding(
                        get: {
                            viewModel.errorMessage != nil
                        },
                        set: { value in
                            if !value {
                                viewModel.errorMessage = nil
                            }
                        }
                    )
                ) {
                    Button("OK") {
                        viewModel.errorMessage = nil
                    }
                } message: {
                    Text(
                        viewModel.errorMessage ?? ""
                    )
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

#Preview {
    HomeView()
}
