//
//  FutureCollectionsTests.swift
//  FunctionalFoundation iOS Tests
//
//  Created by Maxim Bazarov on 4/13/18.
//  Copyright © 2018 Functional Swift. All rights reserved.
//

import XCTest
@testable import FunctionalFoundation

class FutureCollectionsTests: XCTestCase {

    func testCollectionOfFuture_AllWithSameDelayBeforeResolving_shouldCallOnCompleteAfterDelay() {
        let exp = expectation(description: "resolved future")
        let count = 100
        let sut = [Int].init(repeating: 1, count: count)

        sut.map(future2sDelay).onAllComplete { values in
            if values.count == count { exp.fulfill() }
        }

        wait(for: [exp], timeout: delay + 0.1)
    }


    // MARK: - Utils

    let delay: Double = 1 // 1 sec
    func future2sDelay(_ v: Int) -> Future<Int> {
        return Future<Int> { resolve in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                resolve(v)
            }
        }
    }
    


   

}
