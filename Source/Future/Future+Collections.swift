//
//  Future+Collections.swift
//  FunctionalFoundation
//
//  Created by Maxim Bazarov on 4/13/18.
//  Copyright © 2018 Functional Swift. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element: FutureType {
    typealias Value = Iterator.Element.Value

    func onAllComplete(execute: @escaping ([Value]) -> ()) {
        allCompleted.onComplete { values in
            execute(values)
        }
    }

    var allCompleted: Future<[Value]> {
        return Future<[Value]> { resolve in
            let queue = DispatchQueue(label: "whenAll<Future<T>> -> Future<[T]> private queue (FunctionalFoundation)")
            var result = [Value]()
            let group = DispatchGroup()
            for future in self {
                group.enter()
                future.onComplete { v in
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

