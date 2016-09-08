//
//  ExtensionsTest.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
import XCTest
import Foundation
@testable import CryptoSwift

final class ExtensionsTest: XCTestCase {

    func testArrayChunksPerformance() {
        measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, for: { () -> Void in
            let message = Array<UInt8>(repeating: 7, count: 1024 * 1024)
            self.startMeasuring()
            _ = message.chunks(size: AES.blockSize)
            self.stopMeasuring()
        })
    }

    
    func testIntExtension() {
        let i1:Int = 1024
        let i1Array = i1.bytes(totalBytes: 32 / 8) // 32 bit
        let i1recovered = Int(bytes: i1Array)
        
        XCTAssertEqual(i1, i1recovered, "Bytes conversion failed")
        
        let i2:Int = 1024
        let i2Array = i2.bytes(totalBytes: 160 / 8) // 160 bit
        let i2recovered = Int(bytes: i2Array)
        
        XCTAssertEqual(i2, i2recovered, "Bytes conversion failed")
    }
    
    func testBytes() {
        let size = MemoryLayout<UInt32>.size // 32 or 64  bit
        
        let i:UInt32 = 1024
        var bytes = i.bytes()
        XCTAssertTrue(bytes.count == size, "Invalid bytes length =  \(bytes.count)")
        
        // test padding
        bytes = i.bytes(totalBytes: 16)
        XCTAssertTrue(bytes.count == 16, "Invalid return type \(bytes.count)")
        XCTAssertTrue(bytes[14] == 4, "Invalid return type \(bytes.count)")
    }
    
    func testShiftLeft() {
        // Unsigned
        let i:UInt32 = 1
        XCTAssert(i &<< 1 == 2, "shift left failed")
        XCTAssert(i &<< 8 == 256, "shift left failed")
        XCTAssert(i &<< 31 == i << 31, "shift left failed")
        XCTAssert(i &<< 32 == 0, "shift left failed")

        // Signed
        let ii:Int = 21
        XCTAssert(ii &<< 1 == ii << 1, "shift left failed")
        XCTAssert(ii &<< 8 == ii << 8, "shift left failed")
        let shiftLeft1 = ii &<< ((MemoryLayout<Int>.size * 8) - 1)
        let shiftLeft2 = ii << ((MemoryLayout<Int>.size * 8) - 1)
        XCTAssert(shiftLeft1 == shiftLeft2, "shift left failed")
        XCTAssert(ii &<< ((MemoryLayout<Int>.size * 8)) == 0, "shift left failed")
        
        let iii:UInt32 = 21
        XCTAssert(iii &<< 1 == iii << 1, "shift left failed")
        XCTAssert(iii &<< 8 == iii << 8, "shift left failed")
        XCTAssert((iii &<< 32) == 0, "shift left failed")
    }
    
    func testToUInt32Array() {
        let chunk:ArraySlice<UInt8> = [1,1,1,7,2,3,4,5]
        let result = chunk.toUInt32Array()
        
        XCTAssert(result.count == 2, "Invalid conversion")
        XCTAssert(result[0] == 117506305, "Invalid conversion")
        XCTAssert(result[1] == 84148994, "Invalid conversion")
    }

    func testDataInit() {
        let data = Data(bytes: [0x01, 0x02, 0x03])
        XCTAssert(data.count == 3, "Invalid data")
    }

    func testStringEncrypt() {
        do {
            let encryptedHex = try "my secret string".encrypt(cipher: AES(key: "secret0key000000", iv: "0123456789012345"))
            XCTAssertEqual(encryptedHex, "68f7ff8bdb61f625febdfe3d791ecf624daaed2e719a6de39112de8e0cc7349b")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testStringDecryptBase64() {
        let encryptedBase64 = "aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs="
        let decrypted = try! encryptedBase64.decryptBase64ToString(cipher: AES(key: "secret0key000000", iv: "0123456789012345"))
        XCTAssertEqual(decrypted, "my secret string")
    }

    func testArrayInitHex() {
        let bytes = Array<UInt8>(hex: "0xb1b1b2b2")
        XCTAssertEqual(bytes, [177,177,178,178])

        let str = "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"
        let array = Array<UInt8>(hex: str)
        let hex = array.toHexString()
        XCTAssertEqual(str, hex)
    }

    static let allTests =  [
        ("testArrayChunksPerformance", testArrayChunksPerformance),
        ("testIntExtension", testIntExtension),
        ("testBytes", testBytes),
        ("testShiftLeft", testShiftLeft),
        ("testToUInt32Array", testToUInt32Array),
        ("testDataInit", testDataInit),
        ("testStringEncrypt", testStringEncrypt),
        ("testStringDecryptBase64", testStringDecryptBase64),
        ("testArrayInitHex", testArrayInitHex)
    ]
}
