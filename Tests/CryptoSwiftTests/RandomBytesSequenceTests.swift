//
//  RandomBytesSequenceTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 10/10/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
@testable import CryptoSwift

class RandomBytesSequenceTests: XCTestCase {

    func testSequence() {
        XCTAssertNil(RandomBytesSequence(size: 0).makeIterator().next())

        for value in RandomBytesSequence(size: 100) {
            XCTAssertTrue(value <= UInt8.max)
        }
    }

    static let allTests = [("testSequence", testSequence)]
}
