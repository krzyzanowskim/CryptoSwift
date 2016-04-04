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
        let p = try! PKCS5.PBKDF2(password: "s33krit".utf8.map({ $0 }), salt: "nacl".utf8.map({ $0 }), iterations: 2, keyLength: 123, hashVariant: .sha1)
        let value = p.calculate()
        print(value.toHexString());
        print("done")
    }

}