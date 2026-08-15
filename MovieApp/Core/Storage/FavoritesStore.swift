//
//  FavoritesStore.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import Foundation
import Observation

protocol FavoritesStoreProtocol: AnyObject {
    var favoriteIDs: Set<Int> { get }
    func isFavorite(_ id: Int) -> Bool
    func toggleFavorite(_ id: Int)
    func addFavorite(_ id: Int)
    func removeFavorite(_ id: Int)
}

@MainActor
@Observable
final class DefaultFavoritesStore: FavoritesStoreProtocol {

    private let userDefaultsKey = "com.harshal.movieapp.favorite_movie_ids"
    private let userDefaults: UserDefaults

    private(set) var favoriteIDs: Set<Int> = []

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFavorites()
    }

    func isFavorite(_ id: Int) -> Bool {
        favoriteIDs.contains(id)
    }

    func toggleFavorite(_ id: Int) {
        if favoriteIDs.contains(id) {
            removeFavorite(id)
        } else {
            addFavorite(id)
        }
    }

    func addFavorite(_ id: Int) {
        favoriteIDs.insert(id)
        persistFavorites()
    }

    func removeFavorite(_ id: Int) {
        favoriteIDs.remove(id)
        persistFavorites()
    }

    // MARK: - Persistence

    private func loadFavorites() {
        if let data = userDefaults.data(forKey: userDefaultsKey),
           let ids = try? JSONDecoder().decode(Set<Int>.self, from: data) {
            self.favoriteIDs = ids
        } else {
            self.favoriteIDs = []
        }
    }

    private func persistFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteIDs) {
            userDefaults.set(encoded, forKey: userDefaultsKey)
        }
    }
}
