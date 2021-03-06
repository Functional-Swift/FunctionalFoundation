//
//  FunctionalFoundationTests.swift
//  FunctionalFoundationTests
//
//  Created by Maxim Bazarov on 4/2/18.
//

import XCTest
@testable import FunctionalFoundation


class ObservableTests: XCTestCase {
    
    func testAdd10ObserversAndChangeValue_ShouldBe10Values() {
        let count = 10
        let sut = Observable("sut")
        let testValue = "test"
        var result = [String]()
        var unsubscribeTable = [Int: CancelSubscription]()
        (1...count).forEach({ (index) in
            let unsubscribe = sut.subscribe { value in
                result.append(value)
            }
            unsubscribeTable[index] = unsubscribe
        })
        
        sut.value = testValue
        // x2 because one for each change and one for value when subscribe
        XCTAssertEqual(result.count, count*2)
    }
    
    func testAdd10ObserversAndChangeValue10Times_ShouldBe100Values() {
        let sut = Observable("sut")
        var result = [String]()
        var unsubscribeTable = [Int: CancelSubscription]()
        (1...10).forEach({ (index) in
            let unsubscribe = sut.subscribe { value in
                result.append(value)
            }
            unsubscribeTable[index] = unsubscribe
        })
        
        (1...10).forEach({ (index) in
            sut.value = "\(index)"
        })
        
        // +10 for subscribe
        XCTAssertEqual(result.count, 110)
    }
    
    func testChangeValue_ObservableValueShouldBeEqualNewValue() {
        let sut = Observable(0)
        sut.value = 10
        XCTAssertEqual(sut.value, 10)
    }
    
    func testIncrementValue_ValueShouldBeIncremented() {
        let sut = Observable(0)
        sut.value = sut.value + 10
        XCTAssertEqual(sut.value, 10)
    }
    
}
