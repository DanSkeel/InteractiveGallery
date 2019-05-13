/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See APPLE_EXAMPLES_LICENSE.txt for this sample’s licensing information
    
    Abstract:
    An extension to NSLock to simplify executing critical code.
    Source: https://github.com/richardtin/Advanced-NSOperations
*/

import Foundation

extension NSLock {
    func withCriticalScope<T>(block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}
