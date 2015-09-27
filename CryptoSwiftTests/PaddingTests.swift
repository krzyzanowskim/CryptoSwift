//
//  PaddingTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
import XCTest
@testable import CryptoSwift

final class PaddingTests: XCTestCase {
    func testPKCS7_0() {
        let input:[UInt8]    = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6]
        let expected:[UInt8] = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]
        let padded = PKCS7().add(input, blockSize: 16)
        XCTAssertEqual(padded, expected, "PKCS7 failed")
        let clean = PKCS7().remove(padded, blockSize: nil)
        XCTAssertEqual(clean, input, "PKCS7 failed")
    }
    
    func testPKCS7_1() {
        let input:[UInt8]    = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5]
        let expected:[UInt8] = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,1]
        let padded = PKCS7().add(input, blockSize: 16)
        XCTAssertEqual(padded, expected, "PKCS7 failed")
        let clean = PKCS7().remove(padded, blockSize: nil)
        XCTAssertEqual(clean, input, "PKCS7 failed")
    }
    
    func testPKCS7_2() {
        let input:[UInt8]    = [1,2,3,4,5,6,7,8,9,0,1,2,3,4]
        let expected:[UInt8] = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,2,2]
        let padded = PKCS7().add(input, blockSize: 16)
        XCTAssertEqual(padded, expected, "PKCS7 failed")
        let clean = PKCS7().remove(padded, blockSize: nil)
        XCTAssertEqual(clean, input, "PKCS7 failed")
    }
}
