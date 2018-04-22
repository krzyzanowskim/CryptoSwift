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
import Foundation
import XCTest

final class ExtensionsTest: XCTestCase {
    func testBytes() {
        let size = MemoryLayout<UInt32>.size // 32 or 64  bit

        let i: UInt32 = 1024
        var bytes = i.bytes()
        XCTAssertTrue(bytes.count == size, "Invalid bytes length =  \(bytes.count)")

        // test padding
        bytes = i.bytes(totalBytes: 16)
        XCTAssertTrue(bytes.count == 16, "Invalid return type \(bytes.count)")
        XCTAssertTrue(bytes[14] == 4, "Invalid return type \(bytes.count)")
    }

    func testToUInt32Array() {
        let chunk: ArraySlice<UInt8> = [0x8, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1]
        let result = chunk.toUInt32Array()

        XCTAssert(result.count == 2, "Invalid conversion")
        XCTAssertEqual(result[0], 0x5060708)
        XCTAssertEqual(result[1], 0x1020304)
    }

    func testDataInit() {
        let data = Data(bytes: [0x01, 0x02, 0x03])
        XCTAssert(data.count == 3, "Invalid data")
    }

    func testStringEncrypt() {
        do {
            let encryptedHex = try "my secret string".encrypt(cipher: AES(key: "secret0key000000", iv: "0123456789012345"))
            XCTAssertEqual(encryptedHex, "68f7ff8bdb61f625febdfe3d791ecf624daaed2e719a6de39112de8e0cc7349b")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEmptyStringEncrypt() {
        do {
            let cipher = try AES(key: "secret0key000000".bytes.md5(), blockMode: ECB())
            let encrypted = try "".encryptToBase64(cipher: cipher)
            let decrypted = try encrypted?.decryptBase64ToString(cipher: cipher)
            XCTAssertEqual("", decrypted)

            XCTAssertThrowsError(try "".decryptBase64(cipher: cipher))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testStringDecryptBase64() {
        let encryptedBase64 = "aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs="
        let decrypted = try! encryptedBase64.decryptBase64ToString(cipher: AES(key: "secret0key000000", iv: "0123456789012345"))
        XCTAssertEqual(decrypted, "my secret string")
    }

    func testArrayInitHex() {
        let bytes = Array<UInt8>(hex: "0xb1b1b2b2")
        XCTAssertEqual(bytes, [177, 177, 178, 178])

        let str = "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"
        let array = Array<UInt8>(hex: str)
        let hex = array.toHexString()
        XCTAssertEqual(str, hex)
    }
}

extension ExtensionsTest {
    static func allTests() -> [(String, (ExtensionsTest) -> () -> Void)] {
        let tests = [
            ("testBytes", testBytes),
            ("testToUInt32Array", testToUInt32Array),
            ("testDataInit", testDataInit),
            ("testStringEncrypt", testStringEncrypt),
            ("testStringDecryptBase64", testStringDecryptBase64),
            ("testEmptyStringEncrypt", testEmptyStringEncrypt),
            ("testArrayInitHex", testArrayInitHex),
        ]

        return tests
    }
}
