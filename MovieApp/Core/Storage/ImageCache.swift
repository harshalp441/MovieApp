//
//  ImageCache.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import UIKit

protocol ImageCacheProtocol: AnyObject {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
    subscript(url: URL) -> UIImage? { get set }
}

final class ImageCache: ImageCacheProtocol {

    static let shared = ImageCache()

    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        // Store up to 150 decoded images in memory
        cache.countLimit = 150
        // Cap maximum memory usage at ~80 MB
        cache.totalCostLimit = 80 * 1024 * 1024
        return cache
    }()

    private var memoryWarningObserver: NSObjectProtocol?

    init() {
        // Automatically purge all in-memory images when system is under memory pressure
        memoryWarningObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.removeAllImages()
        }
    }

    deinit {
        if let observer = memoryWarningObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insertImage(_ image: UIImage, for url: URL) {
        // Estimate byte cost based on image dimensions (width * height * 4 bytes per pixel)
        let cost = Int(image.size.width * image.size.height * image.scale * image.scale * 4)
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }

    func removeImage(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }

    func removeAllImages() {
        cache.removeAllObjects()
    }

    subscript(url: URL) -> UIImage? {
        get {
            image(for: url)
        }
        set {
            if let image = newValue {
                insertImage(image, for: url)
            } else {
                removeImage(for: url)
            }
        }
    }
}
