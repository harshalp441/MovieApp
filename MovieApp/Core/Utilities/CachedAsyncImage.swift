//
//  CachedAsyncImage.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {

    private let url: URL?
    private let cache: ImageCacheProtocol
    @ViewBuilder private let content: (AsyncImagePhase) -> Content

    @State private var phase: AsyncImagePhase

    init(
        url: URL?,
        cache: ImageCacheProtocol = ImageCache.shared,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.cache = cache
        self.content = content

        // Synchronous cache check on init prevents 1-frame blank/shimmer flash
        if let url = url, let cachedImage = cache[url] {
            _phase = State(initialValue: .success(Image(uiImage: cachedImage)))
        } else {
            _phase = State(initialValue: .empty)
        }
    }

    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }

    private func loadImage() async {
        guard let url = url else {
            phase = .empty
            return
        }

        if let cachedImage = cache[url] {
            phase = .success(Image(uiImage: cachedImage))
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode,
                  let uiImage = UIImage(data: data) else {
                guard !Task.isCancelled else { return }
                phase = .failure(URLError(.badServerResponse))
                return
            }

            cache[url] = uiImage

            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                phase = .success(Image(uiImage: uiImage))
            }
        } catch is CancellationError {
            // Task cancelled silently
        } catch {
            guard !Task.isCancelled else { return }
            phase = .failure(error)
        }
    }
}
