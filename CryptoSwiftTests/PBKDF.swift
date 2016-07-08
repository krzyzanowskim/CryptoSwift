//
//  PBKDF.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 04/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
@testable import CryptoSwift

class PBKDF: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_pbkdf1() {
        let password: Array<UInt8> = [0x70,0x61,0x73,0x73,0x77,0x6F,0x72,0x64]
        let salt: Array<UInt8> = [0x78,0x57,0x8E,0x5A,0x5D,0x63,0xCB,0x06]
        let value = try! PKCS5.PBKDF1(password: password, salt: salt, iterations: 1000, keyLength: 16, variant: .sha1).calculate()
        XCTAssertEqual(value.toHexString(), "dc19847e05c64d2faf10ebfb4a3d2a20")
    }

    func test_pbkdf2() {
        let password: Array<UInt8> = "s33krit".utf8.map {$0}
        let salt: Array<UInt8> = "nacl".utf8.map {$0}
        let value = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 2, keyLength: 140, variant: .sha1).calculate()
        XCTAssert(value.toHexString() == "a53cf3df485e5cd91c17c4978048e3ca86e03cced5f748fb55eff9c1edfce7f9f490c0beee768b85c1ba14ec5750cf059fea52565ffd9e4f9dba01c5c953955e7f1012b6a9eb40629ce767982e598df9081048e22781b35187c16d61ac43f69b88630a9e80233b4c58bdc74ea5c06b5bb1b2c2a86e3ddc2775b852c4508ac85a6a47c0e23a3d8dc6e4dca583", "PBKDF2 fail")
    }

    func test_pbkdf2_length() {
        let password: Array<UInt8> = "s33krit".utf8.map {$0}
        let salt: Array<UInt8> = "nacl".utf8.map {$0}
        let value = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 2, keyLength: 8, variant: .sha1).calculate()
        XCTAssert(value.toHexString() == "a53cf3df485e5cd9", "PBKDF2 fail")
    }

}
