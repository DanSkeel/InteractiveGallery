/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See APPLE_EXAMPLES_LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This file contains the foundational subclass of Operation.
 Taken from https://github.com/richardtin/Advanced-NSOperations
 Updated for swift 5 and removed observers and conditions
 */

import Foundation

/**
 The subclass of `Operation` from which all other operations should be derived.
 This class notifies about operation state changes
 */
class AbstractOperation: Operation {
    
    // use the KVO mechanism to indicate that changes to "state" affect other properties as well
    @objc class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return ["state"]
    }
    
    @objc class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return ["state"]
    }
    
    @objc class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return ["state"]
    }
    
    // MARK: State Management
    
    fileprivate enum State: Int, Comparable {
        /**
         The `Operation`'s conditions have all been satisfied, and it is ready
         to execute.
         */
        case Ready
        
        /// The `Operation` is executing.
        case Executing
        
        /**
         Execution of the `Operation` has finished, but it has not yet notified
         the queue of this.
         */
        case Finishing
        
        /// The `Operation` has finished executing.
        case Finished
        
        func canTransitionToState(target: State) -> Bool {
            switch (self, target) {
            case (.Ready, .Executing):
                return true
            case (.Ready, .Finishing):
                return true
            case (.Executing, .Finishing):
                return true
            case (.Finishing, .Finished):
                return true
            default:
                return false
            }
        }
    }
    
    /// Private storage for the `state` property that will be KVO observed.
    private var _state = State.Ready
    
    /// A lock to guard reads and writes to the `_state` property
    private let stateLock = NSLock()
    
    private var state: State {
        get {
            return stateLock.withCriticalScope {
                _state
            }
        }
        
        set(newState) {
            /*
             It's important to note that the KVO notifications are NOT called from inside
             the lock. If they were, the app would deadlock, because in the middle of
             calling the `didChangeValueForKey()` method, the observers try to access
             properties like "isReady" or "isFinished". Since those methods also
             acquire the lock, then we'd be stuck waiting on our own lock. It's the
             classic definition of deadlock.
             */
            willChangeValue(forKey: "state")
            
            stateLock.withCriticalScope { () -> Void in
                guard _state != .Finished else {
                    return
                }
                
                assert(_state.canTransitionToState(target: newState), "Performing invalid state transition.")
                _state = newState
            }
            
            didChangeValue(forKey: "state")
        }
    }
    
    // Here is where we extend our definition of "readiness".
    override var isReady: Bool {
        switch state {
            
        case .Ready:
            // If the operation has been cancelled, "isReady" should return true
            return super.isReady || isCancelled
            
        default:
            return false
        }
    }
    
    override var isExecuting: Bool {
        return state == .Executing
    }
    
    override var isFinished: Bool {
        return state == .Finished
    }
    
    override func addDependency(_ operation: Operation) {
        assert(state < .Executing, "Dependencies cannot be modified after execution has begun.")
        
        super.addDependency(operation)
    }
    
    // MARK: Execution and Cancellation
    
    override final func start() {
        // Foundation.Operation.start() contains important logic that shouldn't be bypassed.
        super.start()
        
        // If the operation has been cancelled, we still need to enter the "Finished" state.
        if isCancelled {
            finish()
        }
    }
    
    override final func main() {
        assert(state == .Ready, "This operation must be performed on an operation queue.")
        
        if _internalErrors.isEmpty && !isCancelled {
            state = .Executing
            execute()
        }
        else {
            finish()
        }
    }
    
    /**
     `execute()` is the entry point of execution for all `Operation` subclasses.
     If you subclass `Operation` and wish to customize its execution, you would
     do so by overriding the `execute()` method.
     
     At some point, your `Operation` subclass must call one of the "finish"
     methods defined below; this is how you indicate that your operation has
     finished its execution, and that operations dependent on yours can re-evaluate
     their readiness state.
     */
    func execute() {
        print("\(type(of: self)) must override `execute()`.")
        
        finish()
    }
    
    private var _internalErrors = [NSError]()
    func cancelWithError(error: NSError? = nil) {
        if let error = error {
            _internalErrors.append(error)
        }
        
        cancel()
    }
    
    // MARK: Finishing
    
    /**
     Most operations may finish with a single error, if they have one at all.
     This is a convenience method to simplify calling the actual `finish()`
     method. This is also useful if you wish to finish with an error provided
     by the system frameworks. As an example, see `DownloadEarthquakesOperation`
     for how an error from an `NSURLSession` is passed along via the
     `finishWithError()` method.
     */
    final func finishWithError(error: NSError?) {
        if let error = error {
            finish(errors: [error])
        }
        else {
            finish()
        }
    }
    
    /**
     A private property to ensure we only notify the observers once that the
     operation has finished.
     */
    private var hasFinishedAlready = false
    final func finish(errors: [NSError] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .Finishing
            
            let combinedErrors = _internalErrors + errors
            finished(errors: combinedErrors)
            state = .Finished
        }
    }
    
    /**
     Subclasses may override `finished(_:)` if they wish to react to the operation
     finishing with errors.
     */
    func finished(errors: [NSError]) {
        // No op.
    }
    
    override final func waitUntilFinished() {
        /*
         Waiting on operations is almost NEVER the right thing to do. It is
         usually superior to use proper locking constructs, such as `dispatch_semaphore_t`
         or `dispatch_group_notify`, or even `NSLocking` objects. Many developers
         use waiting when they should instead be chaining discrete operations
         together using dependencies.
         
         To reinforce this idea, invoking `waitUntilFinished()` will crash your
         app, as incentive for you to find a more appropriate way to express
         the behavior you're wishing to create.
         */
        fatalError("Waiting on operations is an anti-pattern. Remove this ONLY if you're absolutely sure there is No Other Way™.")
    }
    
}

// Simple operator functions to simplify the assertions used above.
private func <(lhs: AbstractOperation.State, rhs: AbstractOperation.State) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

private func ==(lhs: AbstractOperation.State, rhs: AbstractOperation.State) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
