//
//  HMACTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 29/08/14.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation
import XCTest
import CryptoSwift

class HMACTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testMD5() {
        let key:[UInt8] = []
        let msg:[UInt8] = []
        let expectedMac:[UInt8] = [0x74,0xe6,0xf7,0x29,0x8a,0x9c,0x2d,0x16,0x89,0x35,0xf5,0x8c,0x00,0x1b,0xad,0x88]
        
        let hmac = Authenticator.HMAC(key: NSData.withBytes(key), variant: .md5).authenticate(NSData.withBytes(msg))
        XCTAssertEqual(hmac!, NSData.withBytes(expectedMac), "Invalid authentication result")
    }
    
    func testSHA1() {
        let key:[UInt8] = []
        let msg:[UInt8] = []
        let expectedMac:[UInt8] = [0xfb,0xdb,0x1d,0x1b,0x18,0xaa,0x6c,0x08,0x32,0x4b,0x7d,0x64,0xb7,0x1f,0xb7,0x63,0x70,0x69,0x0e,0x1d]
        
        let hmac = Authenticator.HMAC(key: NSData.withBytes(key), variant: .sha1).authenticate(NSData.withBytes(msg))
        XCTAssertEqual(hmac!, NSData.withBytes(expectedMac), "Invalid authentication result")
    }

    func testSHA256() {
        let key:[UInt8] = []
        let msg:[UInt8] = []
        let expectedMac:[UInt8] = [0xb6,0x13,0x67,0x9a,0x08,0x14,0xd9,0xec,0x77,0x2f,0x95,0xd7,0x78,0xc3,0x5f,0xc5,0xff,0x16,0x97,0xc4,0x93,0x71,0x56,0x53,0xc6,0xc7,0x12,0x14,0x42,0x92,0xc5,0xad]
        
        let hmac = Authenticator.HMAC(key: NSData.withBytes(key), variant: .sha256).authenticate(NSData.withBytes(msg))
        XCTAssertEqual(hmac!, NSData.withBytes(expectedMac), "Invalid authentication result")
    }

}
