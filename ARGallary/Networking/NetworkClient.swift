//
//  APIClient.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Client that works with network
class NetworkClient: Networking {
    var userId: Int?
    
    private let urlSession = URLSession.shared
    private let queue: OperationQueue = {
        var queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func operation<T>(for request: T, completionHandler: @escaping CompletionHandler<T> = {_ in}) throws -> Operation
        where T : NetworkRequestProtocol
    {
            let url = try self.url(for: request)
            
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    completionHandler(Result.failure(NetworkError.requestFailed(underlyingError: error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    preconditionFailure()
                }
                let statusCode = httpResponse.statusCode
                guard statusCode == 200 else {
                    completionHandler(Result.failure(NetworkError.unsuccessfulStatus(statusCode: statusCode)))
                    return
                }
                
                guard let data = data else {
                    completionHandler(Result.failure(NetworkError.emptyData))
                    return
                }
                
                var result = Result { try request.responseDecoder.decode(from: data) }
                result = result.mapError { NetworkError.deserializationFailed(underlyingError: $0) }
                completionHandler(result)
            }
            
            let operation = URLSessionTaskOperation(task: dataTask)
            return operation
    }
    
    func perform<T>(request: T, in queue: OperationQueue, completionHandler: @escaping CompletionHandler<T> = {_ in})
        where T: NetworkRequestProtocol
    {
        let operation: Operation
        do {
           operation = try self.operation(for: request, completionHandler: completionHandler)
        } catch {
            completionHandler(Result.failure(error))
            return
        }
        
        queue.addOperation(operation)
    }
    
    func perform<T>(request: T, completionHandler: @escaping CompletionHandler<T> = {_ in}) {
        perform(request: request, in: queue, completionHandler: completionHandler)
    }

    private func url<T>(for request: T) throws -> URL
        where T: NetworkRequestProtocol {
            
            guard var components = URLComponents(url: request.baseUrl, resolvingAgainstBaseURL: true) else {
                    throw NetworkError.badUrl
            }
            
            if let path = request.path {
                assert(path.isEmpty || path.hasPrefix("/"))
                components.path = path
            }
            
            if let parameters = request.parameters {
                components.queryItems = parameters.compactMap { parameter in
                    URLQueryItem(name: parameter.key, value: parameter.value)
                }
            }
            
            guard let url = components.url else {
                throw NetworkError.badUrl
            }
            return url
    }
}

extension NetworkClient: APIProtocol {
    typealias ResultHandler<R> = (Result<R, Error>) -> Void
    
    private func apiResultHandler<R>(for handler: @escaping ResultHandler<R>) -> ResultHandler<R> {
        return { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
    }
    
    func albums(completionHandler: @escaping (Result<[Album], Error>) -> Void) {
        guard let userId = self.userId else {
            completionHandler(Result.failure(NetworkError.unauthorized))
            return
        }
        perform(request: APIRequestAlbums(userId: userId),
                completionHandler: apiResultHandler(for: completionHandler))
    }
    
    func photos(in album: Album, completionHandler: @escaping (Result<[Photo], Error>) -> Void) {
        perform(request: APIRequestPhotos(albumId: album.id),
                completionHandler: apiResultHandler(for: completionHandler))
    }
}
