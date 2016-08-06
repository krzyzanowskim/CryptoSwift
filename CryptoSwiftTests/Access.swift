//
//  Access.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

class Access: XCTestCase {
    let cipher = try! AES(key: Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"))
    let authenticator = Authenticator.HMAC(key: Array<UInt8>(hex: "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"), variant: .sha1)

    func testCRC() {
        let _ = CRC.crc32([1,2,3])
        let _ = CRC.crc16([1,2,3])
    }

    func testHash() {
        let _ = Hash.md5([1,2,3])
        let _ = Hash.sha1([1,2,3])
        let _ = Hash.sha224([1,2,3])
        let _ = Hash.sha256([1,2,3])
        let _ = Hash.sha384([1,2,3])
        let _ = Hash.sha512([1,2,3])
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
}
