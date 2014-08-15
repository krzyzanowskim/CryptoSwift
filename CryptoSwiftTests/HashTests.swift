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
        let data2:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [Byte], length: 3) // "1", "2", "3"
        
        if let d = MD5(data1).calculate() {
            XCTAssertEqual(d.hexString, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        } else {
            XCTFail("MD5 fail")
        }
        
        //FIXME: fail on 32-bit simulator for some unknown reason.
        //       because it's working fine for the first time, and break for the second
        //       time with the very same input data
        if let d = MD5(data2).calculate() {
            XCTAssertEqual(d.hexString, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        } else {
            XCTFail("MD5 fail")
        }

        let string = "123"
        if let hash = string.md5() {
            XCTAssertEqual(hash, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        } else {
            XCTFail("MD5 fail")
        }

    }
    
//    func testSHA1() {
//        var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
//        var sha1:NSData = data.sha1()
//        XCTAssertNotNil(sha1, "SHA1 calculation failed")
//        
//        var sha1String:String = sha1.toHexString()
//        XCTAssertEqualObjects(sha1String, "40BD001563085FC35165329EA1FF5C5ECBDBBEEF", "SHA1 calculation failed");
//    }
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
