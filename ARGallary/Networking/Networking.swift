//
//  Networking.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation

/// Protocol that defines essencial methods for making network requests.
protocol Networking {
    typealias CompletionHandler<T> = (Result<T.ResultValue, Error>) -> Void
        where T: NetworkRequestProtocol
    
    /// Creates and returnes operation that makes network request.
    ///
    /// - Parameters:
    ///   - request: Model for network request.
    ///   - completionHandler: The completion handler to call when the load request is complete.
    /// Called on private queue.
    /// - Returns: Operatoin.
    /// - Throws: If request model has some issues, throws errors. E.g. `.badUrl`.
    func operation<T>(for request: T, completionHandler: @escaping CompletionHandler<T>) throws -> Operation
        where T: NetworkRequestProtocol
    
    /// Performs request in particular queue.
    ///
    /// - Parameters:
    ///   - request: Model for network request.
    ///   - queue: Queue in witch all networking operations are added.
    ///   - completionHandler: The completion handler to call when the load request is complete.
    /// Called on private queue.
    func perform<T>(request: T, in queue: OperationQueue, completionHandler: @escaping CompletionHandler<T>)
        where T: NetworkRequestProtocol
    
    /// Performs network request
    ///
    /// - Parameters:
    ///   - request: Model for network request.
    ///   - completionHandler: The completion handler to call when the load request is complete.
    /// Called on private queue.
    func perform<T>(request: T, completionHandler: @escaping CompletionHandler<T>)
        where T: NetworkRequestProtocol
}
