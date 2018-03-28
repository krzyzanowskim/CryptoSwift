//
//  ChaCha20Poly1305Tests.swift
//  CryptoSwiftTests
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
//
//  https://tools.ietf.org/html/rfc7539#section-2.8.1

@testable import CryptoSwift
import XCTest

class ChaCha20Poly1305Tests: XCTestCase {
    static let allTests = [
        ("testCCPoly1", test1),
        ("testCCPoly2", test2),
        ("testCCPoly3", test3),
    ]

    func test1() {
        executeTestCase("6b65792e6b65792e6b65792e6b65792e6b65792e6b65792e6b65792e6b65792e",
                        "6e6f6e63652e6e6f6e63652e",
                        "",
                        "6d657373616765",
                        "5d9c0a9fe7d5e5",
                        "c93aa61fc3cc66a819ac96f6ce365aee")
    }

    func test2() {
        /* Test vector from section 2.8.2. */
        executeTestCase("808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f",
                        "070000004041424344454647",
                        "50515253c0c1c2c3c4c5c6c7",
                        "4c616469657320616e642047656e746c656d656e206f662074686520636c617373206f66202739393a204966204920636f756c64206f6666657220796f75206f6e6c79206f6e652074697020666f7220746865206675747572652c2073756e73637265656e20776f756c642062652069742e",
                        "d31a8d34648e60db7b86afbc53ef7ec2a4aded51296e08fea9e2b5a736ee62d63dbea45e8ca9671282fafb69da92728b1a71de0a9e060b2905d6a5b67ecd3b3692ddbd7f2d778b8c9803aee328091b58fab324e4fad675945585808b4831d7bc3ff4def08e4b7a9de576d26586cec64b6116",
                        "1ae10b594f09e26a7e902ecbd0600691")
    }

    func test3() {
        /* Test vector from A.5. */
        executeTestCase("1c9240a5eb55d38af333888604f6b5f0473917c1402b80099dca5cbc207075c0",
                        "000000000102030405060708",
                        "f33388860000000000004e91",
                        "496e7465726e65742d4472616674732061726520647261667420646f63756d656e74732076616c696420666f722061206d6178696d756d206f6620736978206d6f6e74687320616e64206d617920626520757064617465642c207265706c616365642c206f72206f62736f6c65746564206279206f7468657220646f63756d656e747320617420616e792074696d652e20497420697320696e617070726f70726961746520746f2075736520496e7465726e65742d447261667473206173207265666572656e6365206d6174657269616c206f7220746f2063697465207468656d206f74686572207468616e206173202fe2809c776f726b20696e2070726f67726573732e2fe2809d",
                        "64a0861575861af460f062c79be643bd5e805cfd345cf389f108670ac76c8cb24c6cfc18755d43eea09ee94e382d26b0bdb7b73c321b0100d4f03b7f355894cf332f830e710b97ce98c8a84abd0b948114ad176e008d33bd60f982b1ff37c8559797a06ef4f0ef61c186324e2b3506383606907b6a7c02b0f9f6157b53c867e4b9166c767b804d46a59b5216cde7a4e99040c5a40433225ee282a1b0a06c523eaf4534d7f83fa1155b0047718cbc546a0d072b04b3564eea1b422273f548271a0bb2316053fa76991955ebd63159434ecebb4e466dae5a1073a6727627097a1049e617d91d361094fa68f0ff77987130305beaba2eda04df997b714d6c6f2c29a6ad5cb4022b02709b",
                        "eead9d67890cbb22392336fea1851f38")
    }

    func executeTestCase(_ key: String, _ nonce: String, _ header: String, _ message: String, _ cipher: String, _ tag: String) {
        let keyArr = Array<UInt8>(hex: key)
        let nonceArr = Array<UInt8>(hex: nonce)
        let headerArr = Array<UInt8>(hex: header)
        let messageArr = Array<UInt8>(hex: message)
        let cipherArr = Array<UInt8>(hex: cipher)
        let tagArr = Array<UInt8>(hex: tag)

        do {
            let encryptResult = try AEADChaCha20Poly1305.encrypt(messageArr, key: keyArr, iv: nonceArr, authenticationHeader: headerArr)

            XCTAssertEqual(encryptResult.cipherText, cipherArr, "cipher not equal")
            XCTAssertEqual(encryptResult.authenticationTag, tagArr, "tag not equal")
        } catch {
            XCTAssert(false, "Encryption Failed with error: \(error.localizedDescription)")
        }

        do {
            let decryptResult = try AEADChaCha20Poly1305.decrypt(cipherArr, key: keyArr, iv: nonceArr, authenticationHeader: headerArr, authenticationTag: tagArr)

            XCTAssertEqual(decryptResult.success, true, "decrypt mac check failed")
            XCTAssertEqual(decryptResult.plainText, messageArr, "message not equal")
        } catch {
            XCTAssert(false, "Encryption Failed with error: \(error.localizedDescription)")
        }
    }
}
