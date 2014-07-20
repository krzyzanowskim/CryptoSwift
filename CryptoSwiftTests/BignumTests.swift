//
//  BignumTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 20/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

class BignumTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }


    func testBignum() {
        var bignum1:Bignum = Bignum();
        var bignum2:Bignum = Bignum();
        
        var add = bignum1 + bignum2;
        XCTAssertNotNil(add, "Add failed");
        
        var sub = bignum1 - bignum2;
        XCTAssertNotNil(sub, "Substract failed");
    }
    
    func testBignumFromData() {
        let testString:String = "ABCDE"
        let data:NSData = testString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        let bignum1:Bignum! = Bignum.bignumWithData(data)
        XCTAssertNotNil(bignum1, "Bignum failed1")
        
        let dataRet:NSData! = bignum1.data()
        XCTAssertNotNil(dataRet, "Bignum failed2")
        let resultString:String! = String.stringWithBytes(dataRet.arrayOfBytes(), length: dataRet.length, encoding: NSUTF8StringEncoding)
        XCTAssertEqual(testString, resultString, "Bignum to data failed")
    }

}
