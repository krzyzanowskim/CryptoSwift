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

final class ChaCha20Tests: XCTestCase {
    func testChaCha20() {
        let keys: [Array<UInt8>] = [
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01],
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
            [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f],
        ]

        let ivs: [Array<UInt8>] = [
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
            [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01],
            [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00],
            [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07],
        ]

        let expectedHexes = [
            "76B8E0ADA0F13D90405D6AE55386BD28BDD219B8A08DED1AA836EFCC8B770DC7DA41597C5157488D7724E03FB8D84A376A43B8F41518A11CC387B669B2EE6586",
            "4540F05A9F1FB296D7736E7B208E3C96EB4FE1834688D2604F450952ED432D41BBE2A0B6EA7566D2A5D1E7E20D42AF2C53D792B1C43FEA817E9AD275AE546963",
            "DE9CBA7BF3D69EF5E786DC63973F653A0B49E015ADBFF7134FCB7DF137821031E85A050278A7084527214F73EFC7FA5B5277062EB7A0433E445F41E3",
            "EF3FDFD6C61578FBF5CF35BD3DD33B8009631634D21E42AC33960BD138E50D32111E4CAF237EE53CA8AD6426194A88545DDC497A0B466E7D6BBDB0041B2F586B",
            "F798A189F195E66982105FFB640BB7757F579DA31602FC93EC01AC56F85AC3C134A4547B733B46413042C9440049176905D3BE59EA1C53F15916155C2BE8241A38008B9A26BC35941E2444177C8ADE6689DE95264986D95889FB60E84629C9BD9A5ACB1CC118BE563EB9B3A4A472F82E09A7E778492B562EF7130E88DFE031C79DB9D4F7C7A899151B9A475032B63FC385245FE054E3DD5A97A5F576FE064025D3CE042C566AB2C507B138DB853E3D6959660996546CC9C4A6EAFDC777C040D70EAF46F76DAD3979E5C5360C3317166A1C894C94A371876A94DF7628FE4EAAF2CCB27D5AAAE0AD7AD0F9D4B6AD3B54098746D4524D38407A6DEB3AB78FAB78C9",
        ]

        for idx in 0..<keys.count {
            let expectedHex = expectedHexes[idx]
            let message = Array<UInt8>(repeating: 0, count: (expectedHex.count / 2))

            do {
                let encrypted = try message.encrypt(cipher: ChaCha20(key: keys[idx], iv: ivs[idx]))
                let decrypted = try encrypted.decrypt(cipher: ChaCha20(key: keys[idx], iv: ivs[idx]))
                XCTAssertEqual(message, decrypted, "ChaCha20 decryption failed")
                XCTAssertEqual(encrypted, Array<UInt8>(hex: expectedHex))
            } catch CipherError.encrypt {
                XCTAssert(false, "Encryption failed")
            } catch CipherError.decrypt {
                XCTAssert(false, "Decryption failed")
            } catch {
                XCTAssert(false, "Failed")
            }
        }
    }

    func testCore() {
        let key: Array<UInt8> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
        var counter: Array<UInt8> = [1, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 74, 0, 0, 0, 0]
        let input = Array<UInt8>.init(repeating: 0, count: 129)
        let chacha = try! ChaCha20(key: key, iv: Array(key[4..<16]))
        let result = chacha.process(bytes: input.slice, counter: &counter, key: key)
        XCTAssertEqual(result.toHexString(), "10f1e7e4d13b5915500fdd1fa32071c4c7d1f4c733c068030422aa9ac3d46c4ed2826446079faa0914c2d705d98b02a2b5129cd1de164eb9cbd083e8a2503c4e0a88837739d7bf4ef8ccacb0ea2bb9d69d56c394aa351dfda5bf459f0a2e9fe8e721f89255f9c486bf21679c683d4f9c5cf2fa27865526005b06ca374c86af3bdc")
    }

    func testVector1Py() {
        let key: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        let iv: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        let expected: Array<UInt8> = [0x76, 0xb8, 0xe0, 0xad, 0xa0, 0xf1, 0x3d, 0x90, 0x40, 0x5d, 0x6a, 0xe5, 0x53, 0x86, 0xbd, 0x28, 0xbd, 0xd2, 0x19, 0xb8, 0xa0, 0x8d, 0xed, 0x1a, 0xa8, 0x36, 0xef, 0xcc, 0x8b, 0x77, 0x0d, 0xc7, 0xda, 0x41, 0x59, 0x7c, 0x51, 0x57, 0x48, 0x8d, 0x77, 0x24, 0xe0, 0x3f, 0xb8, 0xd8, 0x4a, 0x37, 0x6a, 0x43, 0xb8, 0xf4, 0x15, 0x18, 0xa1, 0x1c, 0xc3, 0x87, 0xb6, 0x69, 0xb2, 0xee, 0x65, 0x86]
        let message = Array<UInt8>(repeating: 0, count: expected.count)

        do {
            let encrypted = try ChaCha20(key: key, iv: iv).encrypt(message)
            XCTAssertEqual(encrypted, expected, "Ciphertext failed")
        } catch {
            XCTFail()
        }
    }

    func testChaCha20EncryptPartial() {
        let key: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        let expectedHex = "F798A189F195E66982105FFB640BB7757F579DA31602FC93EC01AC56F85AC3C134A4547B733B46413042C9440049176905D3BE59EA1C53F15916155C2BE8241A38008B9A26BC35941E2444177C8ADE6689DE95264986D95889FB60E84629C9BD9A5ACB1CC118BE563EB9B3A4A472F82E09A7E778492B562EF7130E88DFE031C79DB9D4F7C7A899151B9A475032B63FC385245FE054E3DD5A97A5F576FE064025D3CE042C566AB2C507B138DB853E3D6959660996546CC9C4A6EAFDC777C040D70EAF46F76DAD3979E5C5360C3317166A1C894C94A371876A94DF7628FE4EAAF2CCB27D5AAAE0AD7AD0F9D4B6AD3B54098746D4524D38407A6DEB3AB78FAB78C9"
        let plaintext: Array<UInt8> = Array<UInt8>(repeating: 0, count: (expectedHex.count / 2))

        do {
            let cipher = try ChaCha20(key: key, iv: iv)

            var ciphertext = Array<UInt8>()
            var encryptor = cipher.makeEncryptor()
            ciphertext += try encryptor.update(withBytes: Array(plaintext[0..<8]))
            ciphertext += try encryptor.update(withBytes: Array(plaintext[8..<16]))
            ciphertext += try encryptor.update(withBytes: Array(plaintext[16..<80]))
            ciphertext += try encryptor.update(withBytes: Array(plaintext[80..<256]))
            ciphertext += try encryptor.finish()
            XCTAssertEqual(Array<UInt8>(hex: expectedHex), ciphertext)
        } catch {
            XCTFail()
        }
    }
}

extension ChaCha20Tests {
    static func allTests() -> [(String, (ChaCha20Tests) -> () -> Void)] {
        let tests = [
            ("testChaCha20", testChaCha20),
            ("testCore", testCore),
            ("testVector1Py", testVector1Py),
            ("testChaCha20EncryptPartial", testChaCha20EncryptPartial),
        ]

        return tests
    }
}
