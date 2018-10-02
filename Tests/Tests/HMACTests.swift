//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

@testable import CryptoSwift
import XCTest

final class HMACTests: XCTestCase {
    func testMD5() {
        let key: Array<UInt8> = []
        let msg: Array<UInt8> = []
        let expectedMac: Array<UInt8> = [0x74, 0xe6, 0xf7, 0x29, 0x8a, 0x9c, 0x2d, 0x16, 0x89, 0x35, 0xf5, 0x8c, 0x00, 0x1b, 0xad, 0x88]

        let hmac = try! HMAC(key: key, variant: .md5).authenticate(msg)
        XCTAssertEqual(hmac, expectedMac, "Invalid authentication result")
    }

    func testSHA1() {
        XCTAssertEqual(try HMAC(key: [], variant: .sha1).authenticate([]), Array<UInt8>(hex: "fbdb1d1b18aa6c08324b7d64b71fb76370690e1d"))
        // echo -n "test" | openssl sha1 -hmac 'test'
        XCTAssertEqual(try HMAC(key: Array<UInt8>(hex: "74657374"), variant: .sha1).authenticate(Array<UInt8>(hex: "74657374")), Array<UInt8>(hex: "0c94515c15e5095b8a87a50ba0df3bf38ed05fe6"))
        // echo -n "test" | openssl sha1 -hmac '0123456789012345678901234567890123456789012345678901234567890123'
        XCTAssertEqual(try HMAC(key: Array<UInt8>(hex: "30313233343536373839303132333435363738393031323334353637383930313233343536373839303132333435363738393031323334353637383930313233"), variant: .sha1).authenticate(Array<UInt8>(hex: "74657374")), Array<UInt8>(hex: "23cea58b0c484ed005434938ee70a938d7524e91"))
    }

    func testSHA256() {
        let key: Array<UInt8> = []
        let msg: Array<UInt8> = []
        let expectedMac: Array<UInt8> = [0xb6, 0x13, 0x67, 0x9a, 0x08, 0x14, 0xd9, 0xec, 0x77, 0x2f, 0x95, 0xd7, 0x78, 0xc3, 0x5f, 0xc5, 0xff, 0x16, 0x97, 0xc4, 0x93, 0x71, 0x56, 0x53, 0xc6, 0xc7, 0x12, 0x14, 0x42, 0x92, 0xc5, 0xad]

        let hmac = try! HMAC(key: key, variant: .sha256).authenticate(msg)
        XCTAssertEqual(hmac, expectedMac, "Invalid authentication result")
    }

    func testSHA384() {
        let key: Array<UInt8> = []
        let msg: Array<UInt8> = []
        let expectedMac: Array<UInt8> = [0x6c, 0x1f, 0x2e, 0xe9, 0x38, 0xfa, 0xd2, 0xe2, 0x4b, 0xd9, 0x12, 0x98, 0x47, 0x43, 0x82, 0xca, 0x21, 0x8c, 0x75, 0xdb, 0x3d, 0x83, 0xe1, 0x14, 0xb3, 0xd4, 0x36, 0x77, 0x76, 0xd1, 0x4d, 0x35, 0x51, 0x28, 0x9e, 0x75, 0xe8, 0x20, 0x9c, 0xd4, 0xb7, 0x92, 0x30, 0x28, 0x40, 0x23, 0x4a, 0xdc]

        let hmac = try! HMAC(key: key, variant: .sha384).authenticate(msg)
        XCTAssertEqual(hmac, expectedMac, "Invalid authentication result")
    }

    func testSHA512() {
        let key: Array<UInt8> = []
        let msg: Array<UInt8> = []
        let expectedMac: Array<UInt8> = [0xb9, 0x36, 0xce, 0xe8, 0x6c, 0x9f, 0x87, 0xaa, 0x5d, 0x3c, 0x6f, 0x2e, 0x84, 0xcb, 0x5a, 0x42, 0x39, 0xa5, 0xfe, 0x50, 0x48, 0x0a, 0x6e, 0xc6, 0x6b, 0x70, 0xab, 0x5b, 0x1f, 0x4a, 0xc6, 0x73, 0x0c, 0x6c, 0x51, 0x54, 0x21, 0xb3, 0x27, 0xec, 0x1d, 0x69, 0x40, 0x2e, 0x53, 0xdf, 0xb4, 0x9a, 0xd7, 0x38, 0x1e, 0xb0, 0x67, 0xb3, 0x38, 0xfd, 0x7b, 0x0c, 0xb2, 0x22, 0x47, 0x22, 0x5d, 0x47]

        let hmac = try! HMAC(key: key, variant: .sha512).authenticate(msg)
        XCTAssertEqual(hmac, expectedMac, "Invalid authentication result")
    }

    static let allTests = [
        ("testMD5", testMD5),
        ("testSHA1", testSHA1),
        ("testSHA256", testSHA256),
        ("testSHA384", testSHA384),
        ("testSHA512", testSHA512),
    ]
}
