//
//  Networking.swift
//  ARGallary
//
//  Created by Danila Shikulin on 12/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import Foundation


protocol Networking {
    typealias CompletionHandler<T> = (Result<T.ResultValue, Error>) -> Void
        where T: NetworkRequestProtocol
    
    func operation<T>(for request: T, completionHandler: @escaping CompletionHandler<T>) throws -> Operation
        where T: NetworkRequestProtocol
    
    func perform<T>(request: T, in queue: OperationQueue, completionHandler: @escaping CompletionHandler<T>)
        where T: NetworkRequestProtocol
    
    func perform<T>(request: T, completionHandler: @escaping CompletionHandler<T>)
        where T: NetworkRequestProtocol
}
