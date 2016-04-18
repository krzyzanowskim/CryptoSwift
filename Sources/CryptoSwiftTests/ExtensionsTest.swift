//
//  ExtensionsTest.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
import XCTest
import CryptoSwift
import Foundation

final class ExtensionsTest: XCTestCase {
    
    static let allTests: [(String, ExtensionsTest -> () throws -> Void)] = [("testIntExtension", testIntExtension), ("testBytes", testBytes), ("testShiftLeft", testShiftLeft), ("testtoUInt32Array", testtoUInt32Array), ("test_NSData_init", test_NSData_init), ("test_String_encrypt_base64", test_String_encrypt_base64), ("test_String_decrypt_base64", test_String_decrypt_base64)]
    
    // MARK: - Functional Tests
    
    func testIntExtension() {
        let i1:Int = 1024
        let i1Array = i1.bytes(32 / 8) // 32 bit
        let i1recovered = Int.with(bytes: i1Array)
        
        XCTAssertEqual(i1, i1recovered, "Bytes conversion failed")
        
        let i2:Int = 1024
        let i2Array = i2.bytes(160 / 8) // 160 bit
        let i2recovered = Int.with(bytes: i2Array)
        
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
        let i:UInt32 = 1
        XCTAssert(i &<< 1 == 2, "shift left failed")
        XCTAssert(i &<< 8 == 256, "shift left failed")
        XCTAssert(i &<< 31 == i << 31, "shift left failed")
        XCTAssert(i &<< 32 == 0, "shift left failed")

        // Signed
        let ii:Int = 21
        XCTAssert(ii &<< 1 == ii << 1, "shift left failed")
        XCTAssert(ii &<< 8 == ii << 8, "shift left failed")
        XCTAssert(ii &<< ((sizeofValue(ii) * 8) - 1) == ii << ((sizeofValue(ii) * 8) - 1), "shift left failed")
        XCTAssert(ii &<< ((sizeofValue(ii) * 8)) == 0, "shift left failed")
        
        let iii:UInt32 = 21
        XCTAssert(iii &<< 1 == iii << 1, "shift left failed")
        XCTAssert(iii &<< 8 == iii << 8, "shift left failed")
        XCTAssert((iii &<< 32) == 0, "shift left failed")
    }
    
    func testtoUInt32Array() {
        let chunk:ArraySlice<UInt8> = [1,1,1,7,2,3,4,5]
        let result = Testable.toUInt32Array(chunk)
        
        XCTAssert(result.count == 2, "Invalid conversion")
        XCTAssert(result[0] == 117506305, "Invalid conversion")
        XCTAssert(result[1] == 84148994, "Invalid conversion")
    }

    func test_NSData_init() {
        let data = NSData(bytes: [0x01, 0x02, 0x03])
        XCTAssert(data.length == 3, "Invalid data")
    }

    func test_String_encrypt_base64() {
        let encryptedBase64 = try! "my secret string".encrypt(AES(key: "secret0key000000", iv: "0123456789012345")).toBase64()
        XCTAssertEqual(encryptedBase64, "aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs=")
    }

    func test_String_decrypt_base64() {
        let encryptedBase64 = "aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs="
        let decrypted = try! encryptedBase64.decryptBase64ToString(AES(key: "secret0key000000", iv: "0123456789012345"))
        XCTAssertEqual(decrypted, "my secret string")
    }
    
    // MARK: - Performance Tests
    
    #if !os(Linux)
    
    func testArrayChunksPerformance() {
        measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, for: { () -> Void in
            let message = [UInt8](repeating: 7, count: 1024 * 1024)
            self.startMeasuring()
            message.chunks(AES.blockSize)
            self.stopMeasuring()
        })
    }
    
    #endif
}
