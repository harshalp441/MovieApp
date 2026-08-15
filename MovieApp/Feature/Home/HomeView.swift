//
//  HomeView.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel = HomeViewModel(repository: DefaultMovieRepository())


    var body: some View {

        NavigationStack {

            content
                .navigationTitle("Movies")
                .searchable(
                    text: $viewModel.searchText,
                    prompt: "Search movies"
                )
                .task {
                    if (viewModel.movies?.isEmpty ?? true) {
                        await viewModel.loadPopularMovies()
                    }
                }
                .refreshable {
                    await viewModel.refresh()
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

        if viewModel.isLoading &&
            (viewModel.movies?.isEmpty ?? true) {

            ProgressView()

        } else if (viewModel.movies?.isEmpty ?? true) {

            ContentUnavailableView(
                "No Movies",
                systemImage: "film",
                description:
                    Text("No movies found.")
            )

        } else {

            List(viewModel.movies ?? []) { movie in

                NavigationLink {
                    EmptyView()
//                    MovieDetailView(
//                        viewModel:
//                            makeDetailViewModel(movie)
//                    )
                } label: {

                    MovieRow(
                        movie: movie,
                        isFavorite:
                           false,
                        onFavoriteTap: {
//                            viewModel.toggleFavorite(
//                                movie
//                            )
                        }
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    HomeView()
}
