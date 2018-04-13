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

    func testCollectionOfFuture_AllWithSameDelayBeforeResolving_shouldCallOnCompleteAfterDelayX2() {
        let exp = expectation(description: "resolved future")
        let values = [(),()] // array of voids

        let sut = [future2sDelay(),future2sDelay()]


        let s = Future.whenAll(sut)

//        if values.count == 2 { exp.fulfill() }
        wait(for: [exp], timeout: FutureTests.delay * 2 + 0.1)
    }

    // MARK: - Utils

    static let delay: Double = 2 // 2 sec
    func future2sDelay() -> Future<Void> {
        return Future<Void> { resolve in
            DispatchQueue.main.asyncAfter(deadline: .now() + FutureTests.delay) {
                resolve(())
            }
        }
    }


   

}
