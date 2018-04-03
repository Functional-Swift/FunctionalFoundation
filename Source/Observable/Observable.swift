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

public typealias CancelSubscription = () -> (Void)

public final class Observable<T> {
    
    /// Subscribe to value changes
    ///
    /// - Parameter callback: runs every value changes
    /// - Returns: unsubscribe function
    @discardableResult
    public func subscribe(callback: @escaping (T) -> Void) -> CancelSubscription {
        let observer = Observer(handler: callback)
        lock.async {
            self.observers.add(observer)
        }
        return { [weak self] in self?.removeObserver(observer: observer) }
    }
    
    /// Value
    private var _value: T
    var value: T {
        get {
            return lock.sync {
                return self._value
            }
        }
        
        set {
            let observers: [Observer] = lock.sync { () -> [Observer] in
                self._value = newValue
                return self.observers.allObjects
            }
            
            for observer in observers {
                observer.handler(newValue)
            }
        }
        
    }
    
    public init(_ value: T) {
        self._value = value
    }
    
    // MARK: Private stuff
    typealias Handler = (T) -> Void
    
    private final class Observer {
        let handler: Handler
        init(handler: @escaping Handler) {
            self.handler = handler
        }
    }
    
    private let lock = DispatchQueue(label: "Observable.lockQueue")
    
    private var observers = NSHashTable<Observer>()
    
    private func removeObserver(observer: Observer) {
        lock.async { [weak self] in
            self?.observers.remove(observer)
        }
    }
}
