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

final class AESTests: XCTestCase {
    // 128 bit key
    let aesKey: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]

    func testAESEncrypt() {
        let input: Array<UInt8> = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff]
        let expected: Array<UInt8> = [0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x4, 0x30, 0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a]

        let aes = try! AES(key: aesKey, blockMode: ECB(), padding: .noPadding)
        let encrypted = try! aes.encrypt(input)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, input, "decryption failed")
    }

    func testAESEncrypt2() {
        let key: Array<UInt8> = [0x36, 0x37, 0x39, 0x66, 0x62, 0x31, 0x64, 0x64, 0x66, 0x37, 0x64, 0x38, 0x31, 0x62, 0x65, 0x65]
        let iv: Array<UInt8> = [0x6b, 0x64, 0x66, 0x36, 0x37, 0x33, 0x39, 0x38, 0x44, 0x46, 0x37, 0x33, 0x38, 0x33, 0x66, 0x64]
        let input: Array<UInt8> = [0x62, 0x72, 0x61, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

        let expected: Array<UInt8> = [0xae, 0x8c, 0x59, 0x95, 0xb2, 0x6f, 0x8e, 0x3d, 0xb0, 0x6f, 0x0a, 0xa5, 0xfe, 0xc4, 0xf0, 0xc2]

        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .noPadding)
        do {
            let encrypted = try aes.encrypt(input)
            XCTAssertEqual(encrypted, expected, "encryption failed")
            let decrypted = try aes.decrypt(encrypted)
            XCTAssertEqual(decrypted, input, "decryption failed")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAESEncrypt3() {
        let key = "679fb1ddf7d81bee"
        let iv = "kdf67398DF7383fd"
        let input: Array<UInt8> = [0x62, 0x72, 0x61, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        let expected: Array<UInt8> = [0xae, 0x8c, 0x59, 0x95, 0xb2, 0x6f, 0x8e, 0x3d, 0xb0, 0x6f, 0x0a, 0xa5, 0xfe, 0xc4, 0xf0, 0xc2]

        do {
            let aes = try AES(key: key, iv: iv, padding: .noPadding)
            let encrypted = try aes.encrypt(input)
            XCTAssertEqual(encrypted, expected, "encryption failed")
            let decrypted = try aes.decrypt(encrypted)
            XCTAssertEqual(decrypted, input, "decryption failed")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAESEncryptCBCNoPadding() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0x76, 0x49, 0xab, 0xac, 0x81, 0x19, 0xb2, 0x46, 0xce, 0xe9, 0x8e, 0x9b, 0x12, 0xe9, 0x19, 0x7d]

        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    func testAESEncryptCBCWithPadding() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0x76, 0x49, 0xab, 0xac, 0x81, 0x19, 0xb2, 0x46, 0xce, 0xe9, 0x8e, 0x9b, 0x12, 0xe9, 0x19, 0x7d, 0x89, 0x64, 0xe0, 0xb1, 0x49, 0xc1, 0x0b, 0x7b, 0x68, 0x2e, 0x6e, 0x39, 0xaa, 0xeb, 0x73, 0x1c]

        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    func testAESEncryptCBCWithPaddingPartial() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a, 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]

        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)

        var ciphertext = Array<UInt8>()
        var encryptor = try! aes.makeEncryptor()
        ciphertext += try! encryptor.update(withBytes: plaintext[0..<8])
        ciphertext += try! encryptor.update(withBytes: plaintext[8..<16])
        ciphertext += try! encryptor.update(withBytes: plaintext[16..<32])
        ciphertext += try! encryptor.finish()
        XCTAssertEqual(try! aes.encrypt(plaintext), ciphertext, "encryption failed")
    }

    func testAESEncryptIncremental() {
        do {
            var ciphertext = Array<UInt8>()
            let plaintext = "Today Apple launched the open source Swift community, as well as amazing new tools and resources."
            let aes = try AES(key: "passwordpassword".bytes, blockMode: CBC(iv: "drowssapdrowssap".bytes))
            var encryptor = try! aes.makeEncryptor()

            ciphertext += try encryptor.update(withBytes: plaintext.bytes)
            ciphertext += try encryptor.finish()
            XCTAssertEqual(try aes.encrypt(plaintext.bytes), ciphertext, "encryption failed")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAESDecryptCBCWithPaddingPartial() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let ciphertext: Array<UInt8> = [118, 73, 171, 172, 129, 25, 178, 70, 206, 233, 142, 155, 18, 233, 25, 125, 76, 187, 200, 88, 117, 107, 53, 129, 37, 82, 158, 150, 152, 163, 143, 68, 169, 105, 137, 234, 93, 98, 239, 215, 41, 45, 51, 254, 138, 92, 251, 17]

        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        var plaintext = Array<UInt8>()
        var decryptor = try! aes.makeDecryptor()
        plaintext += try! decryptor.update(withBytes: ciphertext[0..<8])
        plaintext += try! decryptor.update(withBytes: ciphertext[8..<16])
        plaintext += try! decryptor.update(withBytes: ciphertext[16..<32])
        plaintext += try! decryptor.finish()
        XCTAssertEqual(try! aes.decrypt(ciphertext), plaintext, "encryption failed")
    }

    func testAESEncryptCFB() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0x3b, 0x3f, 0xd9, 0x2e, 0xb7, 0x2d, 0xad, 0x20, 0x33, 0x34, 0x49, 0xf8, 0xe8, 0x3c, 0xfb, 0x4a]

        let aes = try! AES(key: key, blockMode: CFB(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/issues/142
    func testAESEncryptCFBLong() {
        let key: Array<UInt8> = [56, 118, 37, 51, 125, 78, 103, 107, 119, 40, 74, 88, 117, 112, 123, 75, 122, 89, 72, 36, 46, 91, 106, 60, 54, 110, 34, 126, 69, 126, 61, 87]
        let iv: Array<UInt8> = [69, 122, 99, 87, 83, 112, 110, 65, 54, 109, 107, 89, 73, 122, 74, 49]
        let plaintext: Array<UInt8> = [123, 10, 32, 32, 34, 67, 111, 110, 102, 105, 114, 109, 34, 32, 58, 32, 34, 116, 101, 115, 116, 105, 110, 103, 34, 44, 10, 32, 32, 34, 70, 105, 114, 115, 116, 78, 97, 109, 101, 34, 32, 58, 32, 34, 84, 101, 115, 116, 34, 44, 10, 32, 32, 34, 69, 109, 97, 105, 108, 34, 32, 58, 32, 34, 116, 101, 115, 116, 64, 116, 101, 115, 116, 46, 99, 111, 109, 34, 44, 10, 32, 32, 34, 76, 97, 115, 116, 78, 97, 109, 101, 34, 32, 58, 32, 34, 84, 101, 115, 116, 101, 114, 34, 44, 10, 32, 32, 34, 80, 97, 115, 115, 119, 111, 114, 100, 34, 32, 58, 32, 34, 116, 101, 115, 116, 105, 110, 103, 34, 44, 10, 32, 32, 34, 85, 115, 101, 114, 110, 97, 109, 101, 34, 32, 58, 32, 34, 84, 101, 115, 116, 34, 10, 125]
        let encrypted: Array<UInt8> = try! AES(key: key, blockMode: CFB(iv: iv)).encrypt(plaintext)
        let decrypted: Array<UInt8> = try! AES(key: key, blockMode: CFB(iv: iv)).decrypt(encrypted)
        XCTAssert(decrypted == plaintext, "decryption failed")
    }

    func testAESEncryptOFB128() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0x3b, 0x3f, 0xd9, 0x2e, 0xb7, 0x2d, 0xad, 0x20, 0x33, 0x34, 0x49, 0xf8, 0xe8, 0x3c, 0xfb, 0x4a]

        let aes = try! AES(key: key, blockMode: OFB(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    func testAESEncryptOFB256() {
        let key: Array<UInt8> = [0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81, 0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0xdc, 0x7e, 0x84, 0xbf, 0xda, 0x79, 0x16, 0x4b, 0x7e, 0xcd, 0x84, 0x86, 0x98, 0x5d, 0x38, 0x60]

        let aes = try! AES(key: key, blockMode: OFB(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    func testAESEncryptPCBC256() {
        let key: Array<UInt8> = [0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81, 0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0xf5, 0x8c, 0x4c, 0x04, 0xd6, 0xe5, 0xf1, 0xba, 0x77, 0x9e, 0xab, 0xfb, 0x5f, 0x7b, 0xfb, 0xd6]

        let aes = try! AES(key: key, blockMode: PCBC(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        print(encrypted.toHexString())
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    func testAESEncryptCTR() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a]
        let expected: Array<UInt8> = [0x87, 0x4d, 0x61, 0x91, 0xb6, 0x20, 0xe3, 0x26, 0x1b, 0xef, 0x68, 0x64, 0x99, 0x0d, 0xb6, 0xce]

        let aes = try! AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted.count, plaintext.count)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted.count, plaintext.count)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/issues/424
    func testAESEncryptCTRZeroPadding() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a, 0x01]
        let expected: Array<UInt8>  = [0x87, 0x4d, 0x61, 0x91, 0xb6, 0x20, 0xe3, 0x26, 0x1b, 0xef, 0x68, 0x64, 0x99, 0x0d, 0xb6, 0xce, 0x37, 0x2b, 0x7c, 0x3c, 0x67, 0x73, 0x51, 0x63, 0x18, 0xa0, 0x77, 0xd7, 0xfc, 0x50, 0x73, 0xae]

        let aes = try! AES(key: key, blockMode: CTR(iv: iv), padding: .zeroPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertEqual(plaintext.count, 17)
        XCTAssertEqual(encrypted.count, 32, "padding failed")
        XCTAssertEqual(encrypted, expected, "encryption failed")
    }

    func testAESEncryptCTRIrregularLength() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a, 0x01]
        let expected: Array<UInt8> = [0x87, 0x4d, 0x61, 0x91, 0xb6, 0x20, 0xe3, 0x26, 0x1b, 0xef, 0x68, 0x64, 0x99, 0x0d, 0xb6, 0xce, 0x37]

        let aes = try! AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(encrypted, expected, "encryption failed")
        let decrypted = try! aes.decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/pull/290
    func testAESDecryptCTRSeek() {
        let key: Array<UInt8> = [0x52, 0x72, 0xb5, 0x9c, 0xab, 0x07, 0xc5, 0x01, 0x11, 0x7a, 0x39, 0xb6, 0x10, 0x35, 0x87, 0x02]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x00, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01]
        var plaintext: Array<UInt8> = Array<UInt8>(repeating: 0, count: 6000)

        for i in 0..<plaintext.count / 6 {
            let s = String(format: "%05d", i).bytes
            plaintext[i * 6 + 0] = s[0]
            plaintext[i * 6 + 1] = s[1]
            plaintext[i * 6 + 2] = s[2]
            plaintext[i * 6 + 3] = s[3]
            plaintext[i * 6 + 4] = s[4]
            plaintext[i * 6 + 5] = "|".utf8.first!
        }

        var aes = try! AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        aes = try! AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
        var decryptor = try! aes.makeDecryptor()
        try! decryptor.seek(to: 2)
        var part1 = try! decryptor.update(withBytes: Array(encrypted[2..<5]))
        part1 += try! decryptor.finish()
        XCTAssertEqual(part1, Array(plaintext[2..<5]), "seek decryption failed")

        try! decryptor.seek(to: 1000)
        var part2 = try! decryptor.update(withBytes: Array(encrypted[1000..<1010]))
        part2 += try! decryptor.finish()
        XCTAssertEqual(part2, Array(plaintext[1000..<1010]), "seek decryption failed")

        try! decryptor.seek(to: 5500)
        var part3 = try! decryptor.update(withBytes: Array(encrypted[5500..<6000]))
        part3 += try! decryptor.finish()
        XCTAssertEqual(part3, Array(plaintext[5500..<6000]), "seek decryption failed")

        try! decryptor.seek(to: 0)
        var part4 = try! decryptor.update(withBytes: Array(encrypted[0..<80]))
        part4 += try! decryptor.finish()
        XCTAssertEqual(part4, Array(plaintext[0..<80]), "seek decryption failed")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/pull/289
    func testAESEncryptCTRIrregularLengthIncrementalUpdate() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let iv: Array<UInt8> = [0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff]
        let plaintext: Array<UInt8> = [0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a, 0x01, 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a, 0x01]
        let expected: Array<UInt8> = [0x87, 0x4d, 0x61, 0x91, 0xb6, 0x20, 0xe3, 0x26, 0x1b, 0xef, 0x68, 0x64, 0x99, 0xd, 0xb6, 0xce, 0x37, 0x40, 0xbd, 0x82, 0x85, 0x5d, 0x11, 0xfc, 0x8e, 0x49, 0x4a, 0xa9, 0xed, 0x23, 0xe0, 0xb9, 0x40, 0x2d]

        let aes = try! AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
        var encryptor = try! aes.makeEncryptor()
        var encrypted = Array<UInt8>()
        encrypted += try! encryptor.update(withBytes: plaintext[0..<5])
        encrypted += try! encryptor.update(withBytes: plaintext[5..<15])
        encrypted += try! encryptor.update(withBytes: plaintext[15...])
        encrypted += try! encryptor.finish()
        XCTAssertEqual(encrypted, expected, "encryption failed")

        var decryptor = try! aes.makeDecryptor()
        var decrypted = Array<UInt8>()
        decrypted += try! decryptor.update(withBytes: expected[0..<5])
        decrypted += try! decryptor.update(withBytes: expected[5..<15])
        decrypted += try! decryptor.update(withBytes: expected[15...])
        decrypted += try! decryptor.finish()
        XCTAssertEqual(decrypted, plaintext, "decryption failed")
    }


    func testAESEncryptCTRStream() {
        let key = Array<UInt8>(hex: "0xbe3e9020816eb838782e2d9f4a2f40d4")
        let iv  =  Array<UInt8>(hex: "0x0000000000000000a9bbd681ded0c0c8")

        do {
            let aes = try AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
            var encryptor = try aes.makeEncryptor()
            
            let encrypted1 = try encryptor.update(withBytes: [0x00, 0x01, 0x02, 0x03] as [UInt8])
            XCTAssertEqual(encrypted1, Array<UInt8>(hex: "d79d0344"))
            let encrypted2 = try encryptor.update(withBytes: [0x04, 0x05, 0x06, 0x07] as [UInt8])
            XCTAssertEqual(encrypted2, Array<UInt8>(hex: "b2a08879"))
            let encrypted3 = try encryptor.update(withBytes: [0x08] as [UInt8])
            XCTAssertEqual(encrypted3, Array<UInt8>(hex: "db"))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAESWithWrongKey() {
        let key: Array<UInt8> = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c]
        let key2: Array<UInt8> = [0x22, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x33]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]
        let plaintext: Array<UInt8> = [49, 46, 50, 50, 50, 51, 51, 51, 51]

        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        let aes2 = try! AES(key: key2, blockMode: CBC(iv: iv), padding: .pkcs7)
        let encrypted = try! aes.encrypt(plaintext)
        let decrypted = try? aes2.decrypt(encrypted)
        XCTAssertTrue(decrypted! != plaintext, "failed")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/issues/298
    func testIssue298() {
        let encryptedValue = "47595cfa90f7b0b0e0d9d7240a2e035f7f4acde27d7ca778a7d8b05add32a0a92d945c0a59f7f0e029d7f2fbb258b2f0"
        let expected: Array<UInt8> = [55, 52, 98, 54, 53, 51, 101, 51, 54, 52, 51, 48, 100, 55, 97, 57, 99, 100, 57, 49, 97, 50, 52, 100, 57, 57, 52, 52, 98, 48, 51, 50, 79, 114, 70, 101, 99, 107, 114, 87, 111, 0, 0, 0, 0, 0, 0, 0]
        let key = "0123456789abcdef"
        let iv = "fedcba9876543210"

        do {
            let aes = try AES(key: key, iv: iv, padding: .noPadding)
            let ciphertext = try aes.decrypt(Array<UInt8>(hex: encryptedValue))
            XCTAssertEqual(ciphertext, expected)
        } catch {
            XCTFail("failed")
        }
    }

    // https://github.com/krzyzanowskim/CryptoSwift/issues/394
    func testIssue394() {
        let plaintext = "Nullam quis risus eget urna mollis ornare vel eu leo.".bytes
        let key = "passwordpassword".bytes.md5() // -md md5
        let iv = "drowssapdrowssap".bytes // -iv 64726f777373617064726f7773736170
        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) // -aes-128-cbc
        let ciphertext = try! aes.encrypt(plaintext) // enc

        // $ echo -n "Nullam quis risus eget urna mollis ornare vel eu leo." | openssl enc -aes-128-cbc -md md5 -nosalt -iv 64726f777373617064726f7773736170 -pass pass:passwordpassword -base64
        // cij+965z2Xqoj9tIHgtA72ZPfv5sxnt76vwkIt1CodYY313oa7mr0pSc5o++g0CX
        // YczxK2fGIa84xtwDtRMwBQ==
        XCTAssertEqual(ciphertext.toBase64(), "cij+965z2Xqoj9tIHgtA72ZPfv5sxnt76vwkIt1CodYY313oa7mr0pSc5o++g0CXYczxK2fGIa84xtwDtRMwBQ==")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/issues/411
    func testIssue411() {
        let ciphertext: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05, 0xaf, 0x46, 0x58, 0x2d, 0x66, 0x52, 0x10, 0xae, 0x86, 0xd3, 0x8e, 0x8f] // test
        let key = "passwordpassword".bytes.md5() // -md md5
        let iv = "drowssapdrowssap".bytes // -iv 64726f777373617064726f7773736170
        let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7) // -aes-128-cbc
        let plaintext = try! ciphertext.decrypt(cipher: aes)
        XCTAssertEqual("74657374", plaintext.toHexString())
    }
}

// MARK: - GCM
extension AESTests {
    func testAESGCMTestCase1() {
        // Test Case 1
        let key = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let iv = Array<UInt8>(hex: "0x000000000000000000000000")

        let gcm = GCM(iv: iv, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt([UInt8]())
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "58e2fccefa7e3061367f1d57a4e7455a")) // T (128-bit)
    }

    func testAESGCMTestCase2() {
        // Test Case 2
        let key = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let plaintext = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let iv = Array<UInt8>(hex: "0x000000000000000000000000")

        let gcm = GCM(iv: iv, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0388dace60b6a392f328c2b971b2fe78")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "ab6e47d42cec13bdf53a67b21257bddf")) // T (128-bit)
    }

    func testAESGCMTestCase3() {
        // Test Case 3
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = Array<UInt8>(hex: "0xd9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b391aafd255")
        let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")

        let encGCM = GCM(iv: iv, mode: .detached)
        let aes = try! AES(key: key, blockMode: encGCM, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertNotNil(encGCM.authenticationTag)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0x42831ec2217774244b7221b784d0d49ce3aa212f2c02a4e035c17e2329aca12e21d514b25466931c7d8f6a5aac84aa051ba30b396a0aac973d58e091473f5985")) // C
        XCTAssertEqual(encGCM.authenticationTag, [UInt8](hex: "0x4d5c2af327cd64a62cf35abd2ba6fab4")) // T (128-bit)

        // decrypt
        func decrypt(_ encrypted: Array<UInt8>, tag: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, authenticationTag: tag, mode: .detached)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }

        let decrypted = decrypt(encrypted, tag: encGCM.authenticationTag!)
        XCTAssertEqual(decrypted, plaintext)
    }

    func testAESGCMTestCase3Combined() {
        // Test Case 3
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = Array<UInt8>(hex: "0xd9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b391aafd255")
        let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")

        let encGCM = GCM(iv: iv, mode: .combined)
        let aes = try! AES(key: key, blockMode: encGCM, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertNotNil(encGCM.authenticationTag)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0x42831ec2217774244b7221b784d0d49ce3aa212f2c02a4e035c17e2329aca12e21d514b25466931c7d8f6a5aac84aa051ba30b396a0aac973d58e091473f59854d5c2af327cd64a62cf35abd2ba6fab4")) // C
        XCTAssertEqual(encGCM.authenticationTag, [UInt8](hex: "0x4d5c2af327cd64a62cf35abd2ba6fab4")) // T (128-bit)

        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, mode: .combined)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }

        let decrypted = decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext)
    }

    func testAESGCMTestCase4() {
        // Test Case 4
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = Array<UInt8>(hex: "0xd9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b39")
        let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")
        let auth = Array<UInt8>(hex: "0xfeedfacedeadbeeffeedfacedeadbeefabaddad2")

        let gcm = GCM(iv: iv, additionalAuthenticatedData: auth, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0x42831ec2217774244b7221b784d0d49ce3aa212f2c02a4e035c17e2329aca12e21d514b25466931c7d8f6a5aac84aa051ba30b396a0aac973d58e091")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "0x5bc94fbc3221a5db94fae95ae7121a47")) // T (128-bit)
    }

    func testAESGCMTestCase5() {
        // Test Case 5
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = Array<UInt8>(hex: "0xd9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b39")
        let iv = Array<UInt8>(hex: "0xcafebabefacedbad")
        let auth = Array<UInt8>(hex: "0xfeedfacedeadbeeffeedfacedeadbeefabaddad2")

        let gcm = GCM(iv: iv, additionalAuthenticatedData: auth, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0x61353b4c2806934a777ff51fa22a4755699b2a714fcdc6f83766e5f97b6c742373806900e49f24b22b097544d4896b424989b5e1ebac0f07c23f4598")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "0x3612d2e79e3b0785561be14aaca2fccb")) // T (128-bit)
    }

    func testAESGCMTestCase6() {
        // Test Case 6
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = Array<UInt8>(hex: "0xd9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b39")
        let iv = Array<UInt8>(hex: "0x9313225df88406e555909c5aff5269aa6a7a9538534f7da1e4c303d2a318a728c3c0c95156809539fcf0e2429a6b525416aedbf5a0de6a57a637b39b")
        let auth = Array<UInt8>(hex: "0xfeedfacedeadbeeffeedfacedeadbeefabaddad2")

        let gcm = GCM(iv: iv, additionalAuthenticatedData: auth, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0x8ce24998625615b603a033aca13fb894be9112a5c3a211a8ba262a3cca7e2ca701e4a9a4fba43c90ccdcb281d48c7c6fd62875d2aca417034c34aee5")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "0x619cc5aefffe0bfa462af43c1699d050")) // T (128-bit)
    }

    func testAESGCMTestCase7() {
        // Test Case 7
        let key = Array<UInt8>(hex: "0x000000000000000000000000000000000000000000000000")
        let plaintext = Array<UInt8>(hex: "")
        let iv = Array<UInt8>(hex: "0x000000000000000000000000")

        let gcm = GCM(iv: iv, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertEqual(Array(encrypted), [UInt8](hex: "")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "0xcd33b28ac773f74ba00ed1f312572435")) // T (128-bit)
    }
    
    func testAESGCMTagLengthDetached() {
        // Test Case 2
        let key = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let plaintext = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let iv = Array<UInt8>(hex: "0x000000000000000000000000")
        
        let gcm = GCM(iv: iv, tagLength: 12, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0388dace60b6a392f328c2b971b2fe78")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "ab6e47d42cec13bdf53a67b2")) // T (96-bit)
        
        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, authenticationTag: gcm.authenticationTag!, mode: .detached)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }
        
        let decrypted = decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext)
    }
    
    func testAESGCMTagLengthCombined() {
        // Test Case 2
        let key = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let plaintext = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let iv = Array<UInt8>(hex: "0x000000000000000000000000")
        
        let gcm = GCM(iv: iv, tagLength: 12, mode: .combined)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0388dace60b6a392f328c2b971b2fe78ab6e47d42cec13bdf53a67b2")) // C
        XCTAssertEqual(gcm.authenticationTag, [UInt8](hex: "ab6e47d42cec13bdf53a67b2")) // T (96-bit)
        
        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, authenticationTag: gcm.authenticationTag!, mode: .combined)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }
        
        let decrypted = decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext)
    }
    
    func testAESGCMTagLengthCombined2() {
        let key = Array<UInt8>(hex: "0x00000000000000000000000000000000")
        let plaintext = Array<UInt8>(hex: "0x0000000000000000000000000000000000000000")
        let iv = Array<UInt8>(hex: "0x000000000000")
        
        let gcm = GCM(iv: iv, tagLength: 12, mode: .combined)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)
        
        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, authenticationTag: gcm.authenticationTag!, mode: .combined)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }
        
        let decrypted = decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext)
    }

    func testAESGCMTestCaseIrregularCombined1() {
        // echo -n "0123456789010123456789012345" | openssl enc -aes-128-gcm -K feffe9928665731c6d6a8f9467308308 -iv cafebabefacedbaddecaf888 -nopad -nosalt
        // openssl note: The enc program does not support authenticated encryption modes like CCM and GCM. The utility does not store or retrieve the authentication tag
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = "0123456789010123456789012345".bytes
        let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")

        let encGCM = GCM(iv: iv, mode: .combined)
        let aes = try! AES(key: key, blockMode: encGCM, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertNotNil(encGCM.authenticationTag)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0xab831ed4edc644f6d61218431b14c0355138be4b010f630b29be7a2b9793b9fbecc7b44cc86dfd697a50c1c6")) // C
        XCTAssertEqual(encGCM.authenticationTag, [UInt8](hex: "0x9793b9fbecc7b44cc86dfd697a50c1c6")) // T (128-bit)

        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, mode: .combined)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }

        let decrypted = decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext)
    }

    func testAESGCMTestCaseIrregularCombined2() {
        // echo -n "0123456789010123456789012345012345678901012345678901234567" | openssl enc -aes-128-gcm -K feffe9928665731c6d6a8f9467308308 -iv cafebabefacedbaddecaf888 -nopad -nosalt
        // openssl note: The enc program does not support authenticated encryption modes like CCM and GCM. The utility does not store or retrieve the authentication tag
        let key = Array<UInt8>(hex: "0xfeffe9928665731c6d6a8f9467308308")
        let plaintext = "0123456789010123456789012345012345678901012345678901234567".bytes
        let iv = Array<UInt8>(hex: "0xcafebabefacedbaddecaf888")

        let encGCM = GCM(iv: iv, mode: .combined)
        let aes = try! AES(key: key, blockMode: encGCM, padding: .noPadding)
        let encrypted = try! aes.encrypt(plaintext)

        XCTAssertNotNil(encGCM.authenticationTag)
        XCTAssertEqual(Array(encrypted), [UInt8](hex: "0xab831ed4edc644f6d61218431b14c0355138be4b010f630b29be7a2b93ac196f09dc2e10f937aa7e6271564dd117291792f0d6fdf2347ef5b10c86a7f414f0c91a8e59fd2405b850527e")) // C
        XCTAssertEqual(encGCM.authenticationTag, [UInt8](hex: "0x86a7f414f0c91a8e59fd2405b850527e")) // T (128-bit)

        // decrypt
        func decrypt(_ encrypted: Array<UInt8>) -> Array<UInt8> {
            let decGCM = GCM(iv: iv, mode: .combined)
            let aes = try! AES(key: key, blockMode: decGCM, padding: .noPadding)
            return try! aes.decrypt(encrypted)
        }

        let decrypted = decrypt(encrypted)
        XCTAssertEqual(decrypted, plaintext)
    }
}

extension AESTests {
    static func allTests() -> [(String, (AESTests) -> () -> Void)] {
        let tests = [
            ("testAESEncrypt", testAESEncrypt),
            ("testAESEncrypt2", testAESEncrypt2),
            ("testAESEncrypt3", testAESEncrypt3),
            ("testAESEncryptCBCNoPadding", testAESEncryptCBCNoPadding),
            ("testAESEncryptCBCWithPadding", testAESEncryptCBCWithPadding),
            ("testAESEncryptCBCWithPaddingPartial", testAESEncryptCBCWithPaddingPartial),
            ("testAESEncryptIncremental", testAESEncryptIncremental),
            ("testAESDecryptCBCWithPaddingPartial", testAESDecryptCBCWithPaddingPartial),
            ("testAESEncryptCFB", testAESEncryptCFB),
            ("testAESEncryptCFBLong", testAESEncryptCFBLong),
            ("testAESEncryptOFB128", testAESEncryptOFB128),
            ("testAESEncryptOFB256", testAESEncryptOFB256),
            ("testAESEncryptPCBC256", testAESEncryptPCBC256),
            ("testAESEncryptCTR", testAESEncryptCTR),
            ("testAESEncryptCTRZeroPadding", testAESEncryptCTRZeroPadding),
            ("testAESEncryptCTRIrregularLength", testAESEncryptCTRIrregularLength),
            ("testAESDecryptCTRSeek", testAESDecryptCTRSeek),
            ("testAESEncryptCTRIrregularLengthIncrementalUpdate", testAESEncryptCTRIrregularLengthIncrementalUpdate),
            ("testAESEncryptCTRStream", testAESEncryptCTRStream),
            ("testIssue298", testIssue298),
            ("testIssue394", testIssue394),
            ("testIssue411", testIssue411),
            ("testAESWithWrongKey", testAESWithWrongKey),
            ("testAESGCMTestCase1", testAESGCMTestCase1),
            ("testAESGCMTestCase2", testAESGCMTestCase2),
            ("testAESGCMTestCase3", testAESGCMTestCase3),
            ("testAESGCMTestCase3Combined", testAESGCMTestCase3Combined),
            ("testAESGCMTestCase4", testAESGCMTestCase4),
            ("testAESGCMTestCase5", testAESGCMTestCase5),
            ("testAESGCMTestCase6", testAESGCMTestCase6),
            ("testAESGCMTestCase7", testAESGCMTestCase7),
            ("testAESGCMTestTagLengthDetached", testAESGCMTagLengthDetached),
            ("testAESGCMTestTagLengthCombined", testAESGCMTagLengthCombined),
            ("testAESGCMTestCaseIrregularCombined1", testAESGCMTestCaseIrregularCombined1),
            ("testAESGCMTestCaseIrregularCombined2", testAESGCMTestCaseIrregularCombined2)
        ]
        return tests
    }
}
