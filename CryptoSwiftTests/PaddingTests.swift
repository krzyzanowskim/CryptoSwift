//
//  PaddingTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation
import XCTest
import CryptoSwift

class PaddingTests: XCTestCase {
    func testPKCS7_0() {
        let input:[UInt8]    = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6]
        let expected:[UInt8] = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]
        let padded = PKCS7(data: NSData.withBytes(input)).addPadding(16)
        XCTAssertEqual(padded, NSData.withBytes(expected), "PKCS7 failed")
        let clean = PKCS7(data: padded).removePadding()
        XCTAssertEqual(clean, NSData.withBytes(input), "PKCS7 failed")
    }
    
    func testPKCS7_1() {
        let input:[UInt8]    = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5]
        let expected:[UInt8] = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,1]
        let padded = PKCS7(data: NSData.withBytes(input)).addPadding(16)
        XCTAssertEqual(padded, NSData.withBytes(expected), "PKCS7 failed")
        let clean = PKCS7(data: padded).removePadding()
        XCTAssertEqual(clean, NSData.withBytes(input), "PKCS7 failed")
    }
    
    func testPKCS7_2() {
        let input:[UInt8]    = [1,2,3,4,5,6,7,8,9,0,1,2,3,4]
        let expected:[UInt8] = [1,2,3,4,5,6,7,8,9,0,1,2,3,4,2,2]
        let padded = PKCS7(data: NSData.withBytes(input)).addPadding(16)
        XCTAssertEqual(padded, NSData.withBytes(expected), "PKCS7 failed")
        let clean = PKCS7(data: padded).removePadding()
        XCTAssertEqual(clean, NSData.withBytes(input), "PKCS7 failed")
    }
}
