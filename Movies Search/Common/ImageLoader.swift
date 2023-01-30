//
//  ImageLoader.swift
//  Movies Search
//
//  Created by Kalpesh Talkar on 28/01/2023.
//

import UIKit
import Combine

class AsyncImageView: UIImageView {

    private var subscription: AnyCancellable?

    private var cache = AsyncImageCache.shared

    func load(url: URL) {
        if let image: UIImage = cache[url.absoluteString] {
            self.image = image
            return
        }

        subscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { self.cache[url.absoluteString] = $0 })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        subscription?.cancel()
    }

    deinit {
        cancel()
        subscription = nil
    }
}

class AsyncImageCache {

    static let shared = AsyncImageCache()

    private var cache: NSCache = NSCache<NSString, UIImage>()

    subscript(key: String) -> UIImage? {
        get { cache.object(forKey: key as NSString) }
        set(image) { image == nil ? self.cache.removeObject(forKey: (key as NSString)) : self.cache.setObject(image!, forKey: (key as NSString)) }
    }
}
