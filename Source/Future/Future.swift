//
//  FunctionalFoundation.h
//  FunctionalFoundation
//
//  Created by Maxim Bazarov on 4/2/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
import Foundation

public protocol FutureType {
    associatedtype Value
    func onComplete(on queue: DispatchQueue?, execute: @escaping (Value) -> ())
    init(on queue: DispatchQueue?, _ value: Value)
    init(on queue: DispatchQueue?, task: (@escaping (Value) -> ()) -> ())
}

public final class Future<T>: FutureType {
    
    public typealias Value = T
    
    private let queue : DispatchQueue
    
    private var value: T?
    private var callbacks: [(T) -> ()] = []
    
    public func onComplete(on queue: DispatchQueue? = nil, execute: @escaping (T) -> ()) {
        let dispatchQueue = queue ?? self.queue
        dispatchQueue.async {
            if let value = self.value {
                execute(value)
            } else {
                self.callbacks.append(execute)
            }
        }
    }
    
    public init(on queue: DispatchQueue? = nil, _ value: T) {
        self.queue = queue ?? DispatchQueue(label: "Future<T> private queue (FunctionalFoundation)")
        self.value = value
    }
    
    public init(on queue: DispatchQueue? = nil, task: (@escaping (T) -> ()) -> ()) {
        self.queue = queue ?? DispatchQueue(label: "Future<T> private queue (FunctionalFoundation)")
        task { value in
            self.queue.async {
                self.value = value
                self.callbacks.forEach { $0(value) }
                self.callbacks = []
            }
        }
    }
}

extension FutureType {
    func map<U>(_ transform: @escaping (Value) -> U) -> Future<U> {
        return Future<U> { complete in
            self.onComplete(on: nil) { t in complete(transform(t)) }
        }
    }
}

extension FutureType {
    public func then<U>(_ execute: @escaping (Value) -> Future<U>) -> Future<U> {
        return Future<U> { complete in
            self.onComplete(on: nil) { value in
                execute(value).onComplete(execute: complete)
            }
        }
    }
}

extension FutureType {
    public func and<NewValue>(_ future: Future<NewValue>) -> Future<(Value, NewValue)> {
        return Future<(Value, NewValue)> { complete in
            self.onComplete(on: nil) { (value: Value) in
                future.onComplete { (anotherValue: NewValue) in
                    complete((value, anotherValue))
                }
            }
        }
    }
}
