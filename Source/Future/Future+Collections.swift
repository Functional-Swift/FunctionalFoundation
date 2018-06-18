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


extension Sequence where Iterator.Element: FutureType {
    public typealias Value = Iterator.Element.Value

    public func onAllComplete(execute: @escaping ([Value]) -> ()) {
        allCompleted.onComplete { values in
            execute(values)
        }
    }

    public var allCompleted: Future<[Value]> {
        return Future<[Value]> { resolve in
            let queue = DispatchQueue(label: "[Future<T>] -> Future<[T]> private queue (FunctionalFoundation)")
            var result = [Value]()
            let group = DispatchGroup()
            for future in self {
                group.enter()
                future.onComplete(on: nil) { v in
                    queue.async {
                        result.append(v)
                        group.leave()
                    }
                }
            }

            group.notify(queue: queue) {
                resolve(result)
            }

        }
    }
}
