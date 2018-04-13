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
        let sut = [0,0] // array of voids

        sut.map(future2sDelay).allCompleted.onComplete { values in
            if values.count == 2 { exp.fulfill() }
        }

        wait(for: [exp], timeout: FutureTests.delay + 0.1)
    }


    // MARK: - Utils

    static let delay: Double = 2 // 2 sec
    func future2sDelay(_ v: Int) -> Future<Int> {
        return Future<Int> { resolve in
            DispatchQueue.main.asyncAfter(deadline: .now() + FutureTests.delay) {
                resolve(v)
            }
        }
    }


   

}
