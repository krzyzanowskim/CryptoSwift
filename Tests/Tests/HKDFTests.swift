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

class HKDFTests: XCTestCase {
    /// All test cases are implemented with regard to RFC 5869
    /// https://www.ietf.org/rfc/rfc5869.txt

    func testHKDF1() {
        let password = Array<UInt8>(hex: "0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
        let salt = Array<UInt8>(hex: "0x000102030405060708090a0b0c")
        let info = Array<UInt8>(hex: "0xf0f1f2f3f4f5f6f7f8f9")
        let keyLength = 42
        let variant = HMAC.Variant.sha256
        let reference = Array<UInt8>(hex: "0x3cb25f25faacd57a90434f64d0362f2a2d2d0a90cf1a5a4c5db02d56ecc4c5bf34007208d5b887185865")

        XCTAssertEqual(reference, try HKDF(password: password, salt: salt, info: info, keyLength: keyLength, variant: variant).calculate())
    }

    func testHKDF2() {
        let password = Array<UInt8>(hex: "0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f")
        let salt = Array<UInt8>(hex: "0x606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeaf")
        let info = Array<UInt8>(hex: "0xb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff")
        let keyLength = 82
        let variant = HMAC.Variant.sha256
        let reference = Array<UInt8>(hex: "0xb11e398dc80327a1c8e7f78c596a49344f012eda2d4efad8a050cc4c19afa97c59045a99cac7827271cb41c65e590e09da3275600c2f09b8367793a9aca3db71cc30c58179ec3e87c14c01d5c1f3434f1d87")

        XCTAssertEqual(reference, try HKDF(password: password, salt: salt, info: info, keyLength: keyLength, variant: variant).calculate())
    }

    func testHKDF3() {
        let password = Array<UInt8>(hex: "0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
        let keyLength = 42
        let variant = HMAC.Variant.sha256
        let reference = Array<UInt8>(hex: "0x8da4e775a563c18f715f802a063c5a31b8a11f5c5ee1879ec3454e5f3c738d2d9d201395faa4b61a96c8")

        XCTAssertEqual(reference, try HKDF(password: password, keyLength: keyLength, variant: variant).calculate())
    }

    func testHKDF4() {
        let password = Array<UInt8>(hex: "0x0b0b0b0b0b0b0b0b0b0b0b")
        let salt = Array<UInt8>(hex: "0x000102030405060708090a0b0c")
        let info = Array<UInt8>(hex: "0xf0f1f2f3f4f5f6f7f8f9")
        let keyLength = 42
        let variant = HMAC.Variant.sha1
        let reference = Array<UInt8>(hex: "0x085a01ea1b10f36933068b56efa5ad81a4f14b822f5b091568a9cdd4f155fda2c22e422478d305f3f896")

        XCTAssertEqual(reference, try HKDF(password: password, salt: salt, info: info, keyLength: keyLength, variant: variant).calculate())
    }

    func testHKDF5() {
        let password = Array<UInt8>(hex: "0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f")
        let salt = Array<UInt8>(hex: "0x606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeaf")
        let info = Array<UInt8>(hex: "0xb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff")
        let keyLength = 82
        let variant = HMAC.Variant.sha1
        let reference = Array<UInt8>(hex: "0x0bd770a74d1160f7c9f12cd5912a06ebff6adcae899d92191fe4305673ba2ffe8fa3f1a4e5ad79f3f334b3b202b2173c486ea37ce3d397ed034c7f9dfeb15c5e927336d0441f4c4300e2cff0d0900b52d3b4")

        XCTAssertEqual(reference, try HKDF(password: password, salt: salt, info: info, keyLength: keyLength, variant: variant).calculate())
    }

    func testHKDF6() {
        let password = Array<UInt8>(hex: "0x0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b")
        let keyLength = 42
        let variant = HMAC.Variant.sha1
        let reference = Array<UInt8>(hex: "0x0ac1af7002b3d761d1e55298da9d0506b9ae52057220a306e07b6b87e8df21d0ea00033de03984d34918")

        XCTAssertEqual(reference, try HKDF(password: password, keyLength: keyLength, variant: variant).calculate())
    }

    static func allTests() -> [(String, (HKDFTests) -> () -> Void)] {
        let tests = [
            ("Basic test case with SHA-256", testHKDF1),
            ("Test with SHA-256 and longer inputs/outputs", testHKDF2),
            ("Test with SHA-256 and zero-length salt/info", testHKDF3),
            ("Basic test case with SHA-1", testHKDF4),
            ("Test with SHA-1 and longer inputs/outputs", testHKDF5),
            ("Test with SHA-1 and zero-length salt/info", testHKDF6),
        ]

        return tests
    }
}
