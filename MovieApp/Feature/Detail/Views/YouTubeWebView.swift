//
//  YouTubeWebView.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI
import WebKit

// MARK: - WKWebView YouTube Embed

struct YouTubeWebView: UIViewRepresentable {

    let videoKey: String
    let onLoaded: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoaded: onLoaded)
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "videoLoaded")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .black

        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                html, body { width: 100%; height: 100%; background-color: #000000; overflow: hidden; }
                iframe { width: 100%; height: 100%; border: 0; }
            </style>
        </head>
        <body>
            <iframe
                id="player"
                src="https://www.youtube-nocookie.com/embed/\(videoKey)?playsinline=1&autoplay=0&rel=0&modestbranding=1"
                frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen
                onload="try { window.webkit.messageHandlers.videoLoaded.postMessage('ready'); } catch(e) {}">
            </iframe>
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: URL(string: "https://www.youtube-nocookie.com"))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let onLoaded: () -> Void
        private var hasLoaded = false

        init(onLoaded: @escaping () -> Void) {
            self.onLoaded = onLoaded
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard !hasLoaded else { return }
            hasLoaded = true
            DispatchQueue.main.async {
                self.onLoaded()
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Fallback timeout to ensure shimmer dismisses even if iframe script handler isn't reached
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self, !self.hasLoaded else { return }
                self.hasLoaded = true
                self.onLoaded()
            }
        }
    }
}
