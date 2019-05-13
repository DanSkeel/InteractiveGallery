//
//  ImageLoader.swift
//  ARGallary
//
//  Created by Danila Shikulin on 13/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

class ImageLoader: ImageLoading {
    let networkClient: Networking
    
    private let cache = NSCache<NSURL, UIImage>()
    private var operations = NSMapTable<Key, Operation>.weakToWeakObjects()
    
    private let queue: OperationQueue = {
        var queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func loadImage(at url: URL, key: Key, completionHandler: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: url as NSURL) {
            completionHandler(image)
            return
        }
        
        let dataHandler = { [weak self] (result: Result<DataRequest.ResultValue, Error>) in
            var loadedImage: UIImage? = nil
            defer {
                DispatchQueue.main.async {
                    completionHandler(loadedImage)
                }
            }
            
            do {
                let imageData = try result.get()
                if let image = UIImage(data: imageData) {
                    self?.cache.setObject(image, forKey: url as NSURL)
                    loadedImage = image
                }
            } catch {
                print("Failed to load image(\(url)): \(error)")
            }
        }
        
        let operation: Operation
        do {
            let imageDataRequest = DataRequest(url: url)
            operation = try networkClient.operation(for: imageDataRequest, completionHandler: dataHandler)
        } catch {
            assertionFailure("Failed to create operation")
            completionHandler(nil)
            return
        }
        
        operations.setObject(operation, forKey: key)
        queue.addOperation(operation)
    }
    
    func cancelLoading(for key: Key) {
        if let operation = operations.object(forKey: key) {
            operation.cancel()
        }
    }
}
