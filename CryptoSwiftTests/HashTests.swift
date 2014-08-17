//
//  CryptoSwiftTests.swift
//  CryptoSwiftTests
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

class CryptoSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMD5() {
        let data1:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [Byte], length: 3) // "1", "2", "3"
        
        if let hash = MD5(data1).calculate() {
            XCTAssertEqual(hash.hexString, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        }
        
        if let hash = "123".md5() {
            XCTAssertEqual(hash, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        }
        
        if let hash = "".md5() {
            XCTAssertEqual(hash, "D41D8CD98F00B204E9800998ECF8427E", "MD5 calculation failed")
        }
        
        if let hash = "a".md5() {
            XCTAssertEqual(hash, "0CC175B9C0F1B6A831C399E269772661", "MD5 calculation failed")
        }
        
        if let hash = "abc".md5() {
            XCTAssertEqual(hash, "900150983CD24FB0D6963F7D28E17F72", "MD5 calculation failed")
        }
        
        if let hash = "message digest".md5() {
            XCTAssertEqual(hash, "F96B697D7CB7938D525A2F31AAF161D0", "MD5 calculation failed")
        }

        if let hash = "abcdefghijklmnopqrstuvwxyz".md5() {
            XCTAssertEqual(hash, "C3FCD3D76192E4007DFB496CCA67E13B", "MD5 calculation failed")
        }

        if let hash = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5() {
            XCTAssertEqual(hash, "D174AB98D277D9F5A5611C2C9F419D9F", "MD5 calculation failed")
        }

        if let hash = "12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5() {
            XCTAssertEqual(hash, "57EDF4A22BE3C955AC49DA2E2107B67A", "MD5 calculation failed")
        }
    }
    
    func testSHA1() {
        var data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [Byte], length: 3)
        if let hash = data.sha1() {
            XCTAssertEqual(hash.hexString, "40BD001563085FC35165329EA1FF5C5ECBDBBEEF", "SHA1 calculation failed");
        }
    }
//
//    func testSHA512() {
//        var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
//        var sha512:NSData = data.sha512()
//        XCTAssertNotNil(sha512, "SHA512 calculation failed")
//        
//        var sha512String:String = sha512.toHexString()
//        XCTAssertEqualObjects(sha512String, "3C9909AFEC25354D551DAE21590BB26E38D53F2173B8D3DC3EEE4C047E7AB1C1EB8B85103E3BE7BA613B31BB5C9C36214DC9F14A42FD7A2FDB84856BCA5C44C2", "SHA512 calculation failed");
//    }
//
//    func testHashEnum() {
//        var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
//        let md5 = CryptoHash.md5.hash(data);
//        var md5String:String = md5.toHexString();
//        XCTAssertEqualObjects(md5String, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
//    }
    
}
