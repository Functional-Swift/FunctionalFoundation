//
//  Future+Collections.swift
//  FunctionalFoundation
//
//  Created by Maxim Bazarov on 4/13/18.
//  Copyright © 2018 Functional Swift. All rights reserved.
//

import Foundation


extension Sequence where Iterator.Element: FutureType {
    var allCompleted: Future<[Iterator.Element.ValueType]> {
        return Future(value: [Iterator.Element.ValueType]())
    }
}

extension Future {
    public static func whenAll<T>(_ futures: [Future<T>]) -> Future<[T]> {
        
        return Future<[T]> { resolve in
            let queue = DispatchQueue(label: "whenAll<Future<T>> -> Future<[T]> private queue (FunctionalFoundation)")
            var result = [T]()
            let group = DispatchGroup()
            for future in futures {
                group.enter()
                future.onComplete {
                    result.append($0)
                    group.leave()
                    
                }
            }
            
            group.notify(queue: queue) {
                resolve(result)
            }
            
        }
    }
    
}
