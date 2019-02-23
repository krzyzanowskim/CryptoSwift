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

// import without @testable to test public API
import CryptoSwift
import Foundation
import XCTest

class Access: XCTestCase {
    let cipher = try! AES(key: "secret0key000000", iv: "0123456789012345")
    let authenticator = HMAC(key: Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"), variant: .sha1)

    func testChecksum() {
        _ = Checksum.crc32([1, 2, 3])
        _ = Checksum.crc32c([1, 2, 3])
        _ = Checksum.crc16([1, 2, 3])
    }

    func testRandomIV() {
        _ = AES.randomIV(AES.blockSize)
        _ = ChaCha20.randomIV(ChaCha20.blockSize)
    }

    func testDigest() {
        _ = Digest.md5([1, 2, 3])
        _ = Digest.sha1([1, 2, 3])
        _ = Digest.sha224([1, 2, 3])
        _ = Digest.sha256([1, 2, 3])
        _ = Digest.sha384([1, 2, 3])
        _ = Digest.sha512([1, 2, 3])
        _ = Digest.sha3([1, 2, 3], variant: .sha224)

        _ = SHA1().calculate(for: [0])
        _ = SHA2(variant: .sha224).calculate(for: [0])
        _ = SHA3(variant: .sha256).calculate(for: [0])

        _ = MD5().calculate(for: [0])
    }

    func testArrayExtension() {
        let array = Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3")
        _ = array.toHexString()

        _ = array.md5()
        _ = array.sha1()
        _ = array.sha256()
        _ = array.sha384()
        _ = array.sha512()
        _ = array.sha2(.sha224)
        _ = array.sha3(.sha224)
        _ = array.crc32()
        _ = array.crc32c()
        _ = array.crc16()

        do {
            _ = try array.encrypt(cipher: cipher)
            _ = try array.decrypt(cipher: cipher)
            _ = try array.authenticate(with: authenticator)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCollectionExtension() {
        // nothing public
    }

    func testStringExtension() {
        let string = "foofoobarbar"
        _ = string.md5()
        _ = string.sha1()
        _ = string.sha224()
        _ = string.sha256()
        _ = string.sha384()
        _ = string.sha512()
        _ = string.sha3(.sha224)
        _ = string.crc16()
        _ = string.crc32()
        _ = string.crc32c()

        do {
            _ = try string.encrypt(cipher: cipher)
            _ = try string.authenticate(with: authenticator)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testStringFoundationExtension() {
        let string = "aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs="
        do {
            _ = try string.decryptBase64ToString(cipher: cipher)
            _ = try string.decryptBase64(cipher: cipher)
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
        let data = Data( [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8])
        _ = data.checksum()
        _ = data.md5()
        _ = data.sha1()
        _ = data.sha224()
        _ = data.sha256()
        _ = data.sha384()
        _ = data.sha512()
        _ = data.sha3(.sha224)
        _ = data.crc16()
        _ = data.crc32()
        _ = data.crc32c()

        _ = data.bytes
        _ = data.toHexString()

        do {
            _ = try data.encrypt(cipher: cipher)
            _ = try data.decrypt(cipher: cipher)
            _ = try data.authenticate(with: authenticator)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPadding() {
        // PKCS7
        _ = Padding.pkcs7.add(to: [1, 2, 3], blockSize: 16)
        _ = Padding.pkcs7.remove(from: [1, 2, 3], blockSize: 16)

        // PKCS5
        _ = Padding.pkcs5.add(to: [1, 2, 3], blockSize: 16)
        _ = Padding.pkcs5.remove(from: [1, 2, 3], blockSize: 16)

        // NoPadding
        _ = Padding.noPadding.add(to: [1, 2, 3], blockSize: 16)
        _ = Padding.noPadding.remove(from: [1, 2, 3], blockSize: 16)

        // ZeroPadding
        _ = Padding.zeroPadding.add(to: [1, 2, 3], blockSize: 16)
        _ = Padding.zeroPadding.remove(from: [1, 2, 3], blockSize: 16)
    }

    func testPBKDF() {
        do {
            _ = PKCS5.PBKDF1.Variant.md5
            _ = try PKCS5.PBKDF1(password: [1, 2, 3, 4, 5, 6, 7], salt: [1, 2, 3, 4, 5, 6, 7, 8]).calculate()
            _ = try PKCS5.PBKDF2(password: [1, 2, 3, 4, 5, 6, 7], salt: [1, 2, 3, 4]).calculate()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAuthenticators() {
        do {
            _ = try HMAC(key: Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"), variant: .sha1).authenticate([1, 2, 3])
            _ = try Poly1305(key: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2]).authenticate([1, 2, 3])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAES() {
        do {
            let cipher = try AES(key: "secret0key000000", iv: "0123456789012345")
            var encryptor = try cipher.makeEncryptor()
            _ = try encryptor.update(withBytes: [1, 2, 3])
            _ = try encryptor.finish()

            var decryptor = try cipher.makeDecryptor()
            _ = try decryptor.update(withBytes: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
            _ = try decryptor.finish()

            let enc = try cipher.encrypt([1, 2, 3])
            _ = try cipher.decrypt(enc)

            _ = try AES(key: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6], blockMode: CBC(iv: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]), padding: .noPadding)

            _ = AES.Variant.aes128
            _ = AES.blockSize
        } catch {
            XCTFail("\(error)")
        }
    }

    func testBlowfish() {
        do {
            let cipher = try Blowfish(key: "secret0key000000", iv: "01234567")
            let enc = try cipher.encrypt([1, 2, 3])
            _ = try cipher.decrypt(enc)

            _ = try Blowfish(key: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6], padding: .noPadding)

            _ = Blowfish.blockSize
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRabbit() {
        do {
            let rabbit = try Rabbit(key: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            let enc = try rabbit.encrypt([1, 2, 3])
            _ = try rabbit.decrypt(enc)

            XCTAssertThrowsError(try Rabbit(key: "123"))

            _ = Rabbit.blockSize
            _ = Rabbit.keySize
            _ = Rabbit.ivSize
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testChaCha20() {
        let key: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        let iv: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

        do {
            _ = ChaCha20.blockSize
            let chacha20 = try ChaCha20(key: key, iv: iv)
            let enc = try chacha20.encrypt([1, 3, 4])
            _ = try chacha20.decrypt(enc)

            XCTAssertThrowsError(try ChaCha20(key: "123", iv: "12345678"))

            _ = chacha20.makeEncryptor()
            _ = chacha20.makeDecryptor()

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testUpdatable() {
        // TODO:
    }

    static let allTests = [
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
        ("testBlowfish", testBlowfish),
        ("testRabbit", testRabbit),
        ("testChaCha20", testChaCha20),
        ("testUpdatable", testUpdatable),
        ("testRandomIV", testRandomIV),
    ]
}
