//
//  PBKDF2Tests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 04/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
@testable import CryptoSwift

class PBKDF2Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test1() {
        let password: [UInt8] = "s33krit".utf8.map {$0}
        let salt: [UInt8] = "nacl".utf8.map {$0}
        let value = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 2, keyLength: 123, hashVariant: .sha1).calculate()
        XCTAssert(value.toHexString() == "a53cf3df485e5cd91c17c4978048e3ca86e03cced5f748fb55eff9c1edfce7f9f490c0beee768b85c1ba14ec5750cf059fea52565ffd9e4f9dba01c5c953955e7f1012b6a9eb40629ce767982e598df9081048e22781b35187c16d61ac43f69b88630a9e80233b4c58bdc74ea5c06b5bb1b2c2a86e3ddc2775b852c4508ac85a6a47c0e23a3d8dc6e4dca583", "PBKDF2 fail")
    }

}