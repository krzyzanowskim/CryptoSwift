//
//  PaddingTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (C) 2014-2017 Krzyzanowski. All rights reserved.
//
import XCTest
@testable import CryptoSwift

final class PaddingTests: XCTestCase {

    func testPKCS7_0() {
        let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
        let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16]
        let padded = PKCS7.Padding().add(to: input, blockSize: 16)
        XCTAssertEqual(padded, expected, "PKCS7 failed")
        let clean = PKCS7.Padding().remove(from: padded, blockSize: nil)
        XCTAssertEqual(clean, input, "PKCS7 failed")
    }

    func testPKCS7_1() {
        let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5]
        let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 1]
        let padded = PKCS7.Padding().add(to: input, blockSize: 16)
        XCTAssertEqual(padded, expected, "PKCS7 failed")
        let clean = PKCS7.Padding().remove(from: padded, blockSize: nil)
        XCTAssertEqual(clean, input, "PKCS7 failed")
    }

    func testPKCS7_2() {
        let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4]
        let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 2, 2]
        let padded = PKCS7.Padding().add(to: input, blockSize: 16)
        XCTAssertEqual(padded, expected, "PKCS7 failed")
        let clean = PKCS7.Padding().remove(from: padded, blockSize: nil)
        XCTAssertEqual(clean, input, "PKCS7 failed")
    }

    func testZeroPadding() {
        let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0]
        let padding = ZeroPadding()
        XCTAssertEqual(padding.add(to: input, blockSize: 16), expected, "ZeroPadding failed")
        XCTAssertEqual(padding.remove(from: padding.add(to: input, blockSize: 16), blockSize: 16), input, "ZeroPadding failed")
    }

    static let allTests = [
        ("testPKCS7_0", testPKCS7_0),
        ("testPKCS7_1", testPKCS7_1),
        ("testPKCS7_2", testPKCS7_2),
        ("testZeroPadding", testZeroPadding),
    ]
}
