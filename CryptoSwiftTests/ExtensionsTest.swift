//
//  ExtensionsTest.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import UIKit
import XCTest

class ExtensionsTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIntExtension() {
        let i1:Int = 1024
        let i1Array = i1.bytes(32 / 8) // 32 bit
        let i1recovered = Int.withBytes(i1Array)
        
        XCTAssertEqual(i1, i1recovered, "Bytes conversion failed")
        
        let i2:Int = 1024
        let i2Array = i2.bytes(160 / 8) // 160 bit
        let i2recovered = Int.withBytes(i1Array)
        
        XCTAssertEqual(i2, i2recovered, "Bytes conversion failed")
    }
    
    func testBytes() {
        let size = sizeof(UInt32) // 32 or 64  bit
        
        let i:UInt32 = 1024
        var bytes = i.bytes()
        XCTAssertTrue(bytes.count == size, "Invalid bytes length =  \(bytes.count)")
        
        // test padding
        bytes = i.bytes(16)
        XCTAssertTrue(bytes.count == 16, "Invalid return type \(bytes.count)")
        XCTAssertTrue(bytes[14] == 4, "Invalid return type \(bytes.count)")
    }
}
