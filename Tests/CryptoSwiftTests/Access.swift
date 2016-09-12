//
//  Access.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import Foundation
// import without @testable to test public API
import CryptoSwift

class Access: XCTestCase {
    let cipher = try! AES(key: "secret0key000000", iv: "0123456789012345")
    let authenticator = HMAC(key: Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"), variant: .sha1)

    func testChecksum() {
        let _ = Checksum.crc32([1,2,3])
        let _ = Checksum.crc16([1,2,3])
    }

    func testDigest() {
        let _ = Digest.md5([1,2,3])
        let _ = Digest.sha1([1,2,3])
        let _ = Digest.sha224([1,2,3])
        let _ = Digest.sha256([1,2,3])
        let _ = Digest.sha384([1,2,3])
        let _ = Digest.sha512([1,2,3])

        let _ = MD5()
    }

    func testArrayExtension() {
        let array = Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3")
        let _ = array.toHexString()

        let _ = array.md5()
        let _ = array.sha1()
        let _ = array.sha256()
        let _ = array.sha384()
        let _ = array.sha512()
        let _ = array.crc32()
        let _ = array.crc16()

        do {
            let _ = try array.encrypt(cipher: cipher)
            let _ = try array.decrypt(cipher: cipher)
            let _ = try array.authenticate(with: authenticator)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCollectionExtension() {
        // nothing public
    }

    func testStringExtension() {
        let string = "foofoobarbar"
        let _ = string.md5()
        let _ = string.sha1()
        let _ = string.sha224()
        let _ = string.sha256()
        let _ = string.sha384()
        let _ = string.sha512()
        let _ = string.crc16()
        let _ = string.crc32()

        do {
            let _ = try string.encrypt(cipher: cipher)
            let _ = try string.authenticate(with: authenticator)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testStringFoundationExtension() {
        let string = "aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs="
        do {
            let _ = try string.decryptBase64ToString(cipher: cipher)
            let _ = try string.decryptBase64(cipher: cipher)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIntExtension() {
        // nothing public
    }

    func testUInt16Extension() {
        // nothing public
    }

    func testUInt32Extension() {
        // nothing public
    }

    func testUInt64Extension() {
        // nothing public
    }

    func testUInt8Extension() {
        // nothing public
    }

    func testDataExtension() {
        let data = Data(bytes: [1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8])
        let _ = data.checksum()
        let _ = data.md5()
        let _ = data.sha1()
        let _ = data.sha224()
        let _ = data.sha256()
        let _ = data.sha384()
        let _ = data.sha512()
        let _ = data.crc16()
        let _ = data.crc32()

        let _ = data.bytes
        let _ = data.toHexString()

        do {
            let _ = try data.encrypt(cipher: cipher)
            let _ = try data.decrypt(cipher: cipher)
            let _ = try data.authenticate(with: authenticator)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPadding() {
        // PKCS7
        let _ = PKCS7().add(to: [1,2,3], blockSize: 16)
        let _ = PKCS7().remove(from: [1,2,3], blockSize: 16)

        // NoPadding
        let _ = NoPadding().add(to: [1,2,3], blockSize: 16)
        let _ = NoPadding().remove(from: [1,2,3], blockSize: 16)

        // ZeroPadding
        let _ = ZeroPadding().add(to: [1,2,3], blockSize: 16)
        let _ = ZeroPadding().remove(from: [1,2,3], blockSize: 16)
    }

    func testPBKDF() {
        do {
            let _ = PKCS5.PBKDF1.Variant.md5
            let _ = try PKCS5.PBKDF1(password: [1,2,3,4,5,6,7], salt: [1,2,3,4,5,6,7,8]).calculate()
            let _ = try PKCS5.PBKDF2(password: [1,2,3,4,5,6,7], salt: [1,2,3,4]).calculate()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAuthenticators() {
        do {
            let _ = try HMAC(key: Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"), variant: .sha1).authenticate([1,2,3])
            let _ = try Poly1305(key: [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2]).authenticate([1,2,3])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAES() {
        do {
            let aes = try AES(key: "secret0key000000", iv: "0123456789012345")
            var encryptor = aes.makeEncryptor()
            let _ = try encryptor.update(withBytes: [1,2,3])
            let _ = try encryptor.finish()

            var decryptor = aes.makeDecryptor()
            let _ = try decryptor.update(withBytes: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16])
            let _ = try decryptor.finish()

            let enc = try aes.encrypt([1,2,3])
            let _ = try aes.decrypt(enc)

            let _ = try AES(key: [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6], iv: [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6], blockMode: .CBC, padding: NoPadding())

            let _ = AES.Variant.aes128
            let _ = AES.blockSize
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRabbit() {
        do {
            let rabbit = try Rabbit(key: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            let enc = rabbit.encrypt([1,2,3])
            let _   = rabbit.decrypt(enc)

            XCTAssertThrowsError(try Rabbit(key: "123"))

            let _ = Rabbit.blockSize
            let _ = Rabbit.keySize
            let _ = Rabbit.ivSize
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testChaCha20() {
        let key:Array<UInt8> = [0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c];
        let iv:Array<UInt8> = [0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F]

        do {
            let _ = ChaCha20.blockSize
            let chacha20 = try ChaCha20(key: key, iv: iv)
            let enc = try chacha20.encrypt([1,3,4])
            let _ = try chacha20.decrypt(enc)

            XCTAssertThrowsError(try ChaCha20(key: "123", iv: "12345678"))

            let _ = chacha20.makeEncryptor()
            let _ = chacha20.makeDecryptor()

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testUpdatable() {
        // TODO
    }
    
    static let allTests =  [
        ("testChecksum", testChecksum),
        ("testDigest", testDigest),
        ("testArrayExtension", testArrayExtension),
        ("testCollectionExtension", testCollectionExtension),
        ("testStringExtension", testStringExtension),
        ("testStringFoundationExtension", testStringFoundationExtension),
        ("testIntExtension", testIntExtension),
        ("testUInt16Extension", testUInt16Extension),
        ("testUInt32Extension", testUInt32Extension),
        ("testUInt64Extension", testUInt64Extension),
        ("testUInt8Extension", testUInt8Extension),
        ("testDataExtension", testDataExtension),
        ("testPadding", testPadding),
        ("testPBKDF", testPBKDF),
        ("testAuthenticators", testAuthenticators),
        ("testAES", testAES),
        ("testRabbit", testRabbit),
        ("testChaCha20", testChaCha20),
        ("testUpdatable", testUpdatable)
    ]
}
