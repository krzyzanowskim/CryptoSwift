//
//  ExtensionsTest.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation
import XCTest
import CryptoSwift

class ExtensionsTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testArrayChunksPerformance() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, forBlock: { () -> Void in
            let message = [UInt8](count: 1024 * 1024, repeatedValue: 7)
            self.startMeasuring()
            let blocks = message.chunks(AES.blockSize)
            self.stopMeasuring()
        })
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
    
    func testShiftLeft() {
        // Unsigned
        var i:UInt32 = 1
        XCTAssert(i &<< 1 == 2, "shift left failed")
        XCTAssert(i &<< 8 == 256, "shift left failed")
        XCTAssert(i &<< 31 == i << 31, "shift left failed")
        XCTAssert(i &<< 32 == 0, "shift left failed")

        // Signed
        var ii:Int = 21
        XCTAssert(ii &<< 1 == ii << 1, "shift left failed")
        XCTAssert(ii &<< 8 == ii << 8, "shift left failed")
        XCTAssert(ii &<< ((sizeofValue(ii) * 8) - 1) == ii << ((sizeofValue(ii) * 8) - 1), "shift left failed")
        XCTAssert(ii &<< ((sizeofValue(ii) * 8)) == 0, "shift left failed")
        
        var iii:UInt32 = 21
        XCTAssert(iii &<< 1 == iii << 1, "shift left failed")
        XCTAssert(iii &<< 8 == iii << 8, "shift left failed")
        XCTAssert((iii &<< 32) == 0, "shift left failed")

    }
}
