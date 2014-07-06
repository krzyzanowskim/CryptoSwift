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
        var data:NSData = NSData(bytes: [49, 50, 51] as Byte[], length: 3)
        var md5:NSData = data.md5()
        XCTAssertNotNil(md5, "MD5 calculation failed")
        
        var md5String:String = md5.toHexString();
        XCTAssertEqualObjects(md5String, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
    }
    
    func testSHA1() {
        var data:NSData = NSData(bytes: [49, 50, 51] as Byte[], length: 3)
        var sha1:NSData = data.sha1()
        XCTAssertNotNil(sha1, "SHA1 calculation failed")
        
        var sha1String:String = sha1.toHexString()
        XCTAssertEqualObjects(sha1String, "40BD001563085FC35165329EA1FF5C5ECBDBBEEF", "SHA1 calculation failed");
    }
    
//    func testPerformanceExample() {
//        self.measureBlock() {
//        }
//    }
    
}
