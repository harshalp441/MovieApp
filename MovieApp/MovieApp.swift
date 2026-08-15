//
//  MovieApp.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

@main
struct MovieApp: App {

    @State private var favoritesStore = DefaultFavoritesStore()
    private let repository = DefaultMovieRepository()

    var body: some Scene {
        WindowGroup {
            HomeView(
                viewModel: HomeViewModel(
                    repository: repository,
                    favoritesStore: favoritesStore
                )
            )
        }
    }
}
