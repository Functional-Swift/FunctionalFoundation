//
//  FutureTests.swift
//  FunctionalFoundation
//
//  Created by Maxim Bazarov on 4/13/18.
//  Copyright © 2018 Functional Swift. All rights reserved.
//

import XCTest
@testable import FunctionalFoundation


class FutureTests: XCTestCase {
    
    func testFuture_withDelayBeforeResolving_shouldCallOnCompleteAfterDelay() {
        let exp = expectation(description: "resolved future")
        let sut = future2sDelay()
        sut.onComplete { exp.fulfill() }
        wait(for: [exp], timeout: delay + maxDeviation)
    }

    func testFuture_F1_thenF2_BothWithSameDelayBeforeResolving_shouldCallOnCompleteAfterDelayX2() {
        let exp = expectation(description: "resolved future")
        let sut = future2sDelay().then(future2sDelay)
        sut.onComplete {
            exp.fulfill()
        }
        wait(for: [exp], timeout: delay * 2 + maxDeviation)
    }



    func testFuture_F1_AndF2_AndF3_AllWithSameDelayBeforeResolving_shouldCallOnCompleteAfterDelay() {
        let exp = expectation(description: "resolved future")
        let sut = future2sDelay()
            .and(future2sDelay())
            .and(future2sDelay())
        sut.onComplete { _, _ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: delay + maxDeviation)
    }

    // MARK: - Utils
    let maxDeviation: Double = 0.15
    let delay: Double = 2 // 2 sec
    func future2sDelay() -> Future<Void> {
        return Future<Void> { resolve in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                resolve(())
            }
        }
    }
}
