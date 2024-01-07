//
//  CryptoSwift
//
//  Copyright (C) 2014-2022 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

import Foundation
import XCTest
@testable import CryptoSwift

final class RSATests: XCTestCase {

  func testSmallRSA() {
    /*
     * Example taken from the book "Understanding Cryptography"
     *
     * p = 3; q = 11; n = pq = 33; e = 3; d = 7
     */

    let n: Array<UInt8> = [33]
    let e: Array<UInt8> = [3]
    let d: Array<UInt8> = [7]
    let message: Array<UInt8> = [4]
    let expected: Array<UInt8> = [31]

    let rsa = RSA(n: n, e: e, d: d)
    XCTAssertEqual(rsa.keySize, 6, "key size is not correct")

    let encrypted = try! rsa.encrypt(message, variant: .unsafe)
    XCTAssertEqual(encrypted, expected, "small encrypt failed")

    let decrypted = try! rsa.decrypt(encrypted, variant: .unsafe)
    XCTAssertEqual(decrypted, message, "small decrypt failed")
  }

  func testRSA1() {
    /*
     * Taken from http://cryptomanager.com/tv.html
     *
     * 1. 1024-bit RSA bare exponentiation
     */

    let n: Array<UInt8> = [
      0xF0, 0xC4, 0x2D, 0xB8, 0x48, 0x6F, 0xEB, 0x95, 0x95, 0xD8, 0xC7, 0x8F, 0x90, 0x8D, 0x04, 0xA9,
      0xB6, 0xC8, 0xC7, 0x7A, 0x36, 0x10, 0x5B, 0x1B, 0xF2, 0x75, 0x53, 0x77, 0xA6, 0x89, 0x3D, 0xC4,
      0x38, 0x3C, 0x54, 0xEC, 0x6B, 0x52, 0x62, 0xE5, 0x68, 0x8E, 0x5F, 0x9D, 0x9D, 0xD1, 0x64, 0x97,
      0xD0, 0xE3, 0xEA, 0x83, 0x3D, 0xEE, 0x2C, 0x8E, 0xBC, 0xD1, 0x43, 0x83, 0x89, 0xFC, 0xCA, 0x8F,
      0xED, 0xE7, 0xA8, 0x8A, 0x81, 0x25, 0x7E, 0x8B, 0x27, 0x09, 0xC4, 0x94, 0xD4, 0x2F, 0x72, 0x3D,
      0xEC, 0x2E, 0x0B, 0x5C, 0x09, 0x73, 0x1C, 0x55, 0x0D, 0xCC, 0x9D, 0x7E, 0x75, 0x25, 0x89, 0x89,
      0x1C, 0xBB, 0xC3, 0x02, 0x13, 0x07, 0xDD, 0x91, 0x8E, 0x10, 0x0B, 0x34, 0xC0, 0x14, 0xA5, 0x59,
      0xE0, 0xE1, 0x82, 0xAF, 0xB2, 0x1A, 0x72, 0xB3, 0x07, 0xCC, 0x39, 0x5D, 0xEC, 0x99, 0x57, 0x47
    ]
    let e: Array<UInt8> = [
      0x01, 0x00, 0x01
    ]
    let d: Array<UInt8> = [
      0x24, 0x89, 0x10, 0x8B, 0x0B, 0x6A, 0xF8, 0x6B, 0xED, 0x9E, 0x44, 0xC2, 0x33, 0x64, 0x42, 0xD5,
      0xE2, 0x27, 0xDB, 0xA5, 0x5E, 0xF8, 0xE2, 0x6A, 0x7E, 0x43, 0x71, 0x94, 0x11, 0x90, 0x77, 0xF0,
      0x03, 0xBC, 0x9C, 0x02, 0x78, 0x52, 0xBB, 0x31, 0x26, 0xC9, 0x9C, 0x16, 0xD5, 0xF1, 0x05, 0x7B,
      0xC8, 0x36, 0x1D, 0xCB, 0x26, 0xA5, 0xB2, 0xDB, 0x42, 0x29, 0xDB, 0x3D, 0xE5, 0xBD, 0x97, 0x9B,
      0x2E, 0x59, 0x7D, 0x19, 0x16, 0xD7, 0xBB, 0xC9, 0x27, 0x46, 0xFC, 0x07, 0x59, 0x5C, 0x76, 0xB4,
      0x4B, 0x39, 0xA4, 0x76, 0xA6, 0x5C, 0x86, 0xF0, 0x86, 0xDC, 0x92, 0x83, 0xCA, 0x6D, 0x1E, 0xEF,
      0xC1, 0x49, 0x15, 0x98, 0x2F, 0x9C, 0x4C, 0xED, 0x5F, 0x62, 0xA9, 0xFF, 0x3B, 0xE2, 0x42, 0x18,
      0xA9, 0x93, 0x57, 0xB5, 0xB6, 0x5C, 0x3B, 0x10, 0xAE, 0xB3, 0x67, 0xE9, 0x11, 0xEB, 0x9E, 0x21
    ]
    let message: Array<UInt8> = [
      0x11, 0x22, 0x33, 0x44
    ]
    let expected: Array<UInt8> = [
      0x50, 0x5B, 0x09, 0xBD, 0x5D, 0x0E, 0x66, 0xD7, 0xC8, 0x82, 0x9F, 0x5B, 0x47, 0x3E, 0xD3, 0x4D,
      0xB5, 0xCF, 0xDB, 0xB5, 0xD5, 0x8C, 0xE7, 0x83, 0x29, 0xC8, 0xBF, 0x85, 0x20, 0xE4, 0x86, 0xD3,
      0xC4, 0xCF, 0x9B, 0x70, 0xC6, 0x34, 0x65, 0x94, 0x35, 0x80, 0x80, 0xF4, 0x3F, 0x47, 0xEE, 0x86,
      0x3C, 0xFA, 0xF2, 0xA2, 0xE5, 0xF0, 0x3D, 0x1E, 0x13, 0xD6, 0xFE, 0xC5, 0x7D, 0xFB, 0x1D, 0x55,
      0x22, 0x24, 0xC4, 0x61, 0xDA, 0x41, 0x1C, 0xFE, 0x5D, 0x0B, 0x05, 0xBA, 0x87, 0x7E, 0x3A, 0x42,
      0xF6, 0xDE, 0x4D, 0xA4, 0x6A, 0x96, 0x5C, 0x9B, 0x69, 0x5E, 0xE2, 0xD5, 0x0E, 0x40, 0x08, 0x94,
      0x06, 0x1C, 0xB0, 0xA2, 0x1C, 0xA3, 0xA5, 0x24, 0xB4, 0x07, 0xE9, 0xFF, 0xBA, 0x87, 0xFC, 0x96,
      0x6B, 0x3B, 0xA9, 0x45, 0x90, 0x84, 0x9A, 0xEB, 0x90, 0x8A, 0xAF, 0xF4, 0xC7, 0x19, 0xC2, 0xE4
    ]

    let rsa = RSA(n: n, e: e, d: d)
    XCTAssertEqual(rsa.keySize, 1024, "key size is not correct")

    let encrypted = try! rsa.encrypt(message, variant: .unsafe)
    XCTAssertEqual(encrypted, expected, "encrypt failed")

    let decrypted = try! rsa.decrypt(encrypted, variant: .unsafe)
    XCTAssertEqual(decrypted, message, "decrypt failed")
  }

  func testRSA2() {
    /*
     * Taken from http://cryptomanager.com/tv.html
     *
     * 2. 2048-bit PKCS V. 1.5 enciphering.
     */

    let n: Array<UInt8> = [
      0xF7, 0x48, 0xD8, 0xD9, 0x8E, 0xD0, 0x57, 0xCF, 0x39, 0x8C, 0x43, 0x7F, 0xEF, 0xC6, 0x15, 0xD7,
      0x57, 0xD3, 0xF8, 0xEC, 0xE6, 0xF2, 0xC5, 0x80, 0xAE, 0x07, 0x80, 0x76, 0x8F, 0x9E, 0xC8, 0x3A,
      0xAA, 0x08, 0x1F, 0xF0, 0x9E, 0x53, 0x17, 0xED, 0x60, 0x99, 0xC6, 0x3F, 0xD1, 0x5C, 0xFE, 0x11,
      0x17, 0x2F, 0x78, 0x90, 0x8C, 0xD5, 0x8C, 0x03, 0xAE, 0xC9, 0x3A, 0x48, 0x1F, 0xF5, 0x0E, 0x17,
      0x22, 0x04, 0xAF, 0xED, 0xFC, 0x1F, 0x16, 0xAF, 0xDB, 0x99, 0x0A, 0xAB, 0x45, 0xBE, 0x19, 0x0B,
      0xC1, 0x92, 0x59, 0xBD, 0x4A, 0x1B, 0xFC, 0xDF, 0xBE, 0x2A, 0x29, 0x8B, 0x3C, 0x0E, 0x31, 0x8F,
      0x78, 0xA3, 0x39, 0x19, 0x88, 0x23, 0x28, 0xDA, 0xCA, 0xC8, 0x5C, 0xB3, 0x5A, 0x0D, 0xE5, 0x37,
      0xB1, 0x63, 0x76, 0x97, 0x52, 0x17, 0xE5, 0xA5, 0xEA, 0xAF, 0x98, 0x26, 0x6B, 0x58, 0x8C, 0x2D,
      0xBA, 0xFD, 0x0B, 0xE3, 0x71, 0xC3, 0x49, 0x89, 0xCB, 0x36, 0xE6, 0x23, 0xD7, 0x5E, 0xFF, 0xED,
      0xBE, 0x4A, 0x95, 0x1A, 0x68, 0x40, 0x98, 0x2B, 0xC2, 0x79, 0xB3, 0x0F, 0xCD, 0x41, 0xDA, 0xC8,
      0x7C, 0x00, 0x74, 0xD4, 0x62, 0xF1, 0x01, 0x29, 0x00, 0xB8, 0x97, 0x3B, 0x46, 0xAD, 0xC7, 0xEA,
      0xC0, 0x17, 0x70, 0xDF, 0xC6, 0x32, 0xEA, 0x96, 0x7F, 0x94, 0x71, 0xE9, 0x78, 0x98, 0x31, 0xF3,
      0xA4, 0x10, 0x73, 0x0F, 0xF9, 0x14, 0x34, 0x8B, 0xE1, 0x11, 0x86, 0x3C, 0x13, 0x37, 0x63, 0x01,
      0x07, 0x97, 0x56, 0xA1, 0x47, 0xD8, 0x01, 0x03, 0xCE, 0x9F, 0xA6, 0x88, 0xA3, 0x38, 0xE2, 0x2B,
      0x2D, 0x91, 0x6C, 0xAD, 0x42, 0xD6, 0x73, 0xC9, 0xD0, 0x0F, 0x08, 0x21, 0x4D, 0xE5, 0x44, 0xF5,
      0xDE, 0x81, 0x2A, 0x9A, 0x94, 0x91, 0x89, 0x07, 0x8B, 0x2B, 0xDA, 0x14, 0xB2, 0x8C, 0xA6, 0x2F
    ]
    let e: Array<UInt8> = [
      0x01, 0x00, 0x01
    ]
    let d: Array<UInt8> = [
      0x1C, 0xBC, 0x9A, 0x76, 0xAD, 0xE2, 0x08, 0x52, 0x4C, 0x9D, 0xC0, 0x3A, 0x5D, 0xE2, 0xE7, 0x26,
      0xDF, 0x4E, 0x02, 0xDF, 0x84, 0xF7, 0x31, 0x7C, 0x82, 0xBC, 0xDC, 0x70, 0xEA, 0xBF, 0xC9, 0x05,
      0x08, 0x3D, 0x69, 0x78, 0xCC, 0xED, 0x5B, 0x1A, 0x7A, 0xDF, 0x63, 0xEA, 0x86, 0xAA, 0x07, 0xDC,
      0x74, 0x95, 0x4F, 0xAD, 0x7C, 0xB0, 0x54, 0x55, 0x19, 0x3A, 0xC9, 0x4B, 0x18, 0x6B, 0xA1, 0xF7,
      0x8E, 0x3C, 0x7D, 0x35, 0x6A, 0xD7, 0x32, 0x0B, 0xBD, 0xB9, 0x4B, 0x44, 0x1C, 0x16, 0xBB, 0x52,
      0x62, 0x6C, 0x5F, 0x81, 0x5F, 0xDB, 0x60, 0xC7, 0x9F, 0x91, 0xC6, 0xC2, 0x27, 0x78, 0x7E, 0xC9,
      0xED, 0x7B, 0x0A, 0x67, 0xAD, 0x2A, 0x68, 0xD5, 0x04, 0x3B, 0xC4, 0x8A, 0x13, 0x2D, 0x0A, 0x36,
      0x2E, 0xA7, 0x20, 0x60, 0xF5, 0x69, 0x51, 0x86, 0xB6, 0x7F, 0x31, 0x6F, 0x45, 0x8A, 0x44, 0xBF,
      0xD1, 0x40, 0x3D, 0x93, 0xA9, 0xB9, 0x12, 0xCB, 0xB5, 0x98, 0x15, 0x91, 0x6A, 0x14, 0xA2, 0xBA,
      0xD4, 0xF9, 0xA1, 0xED, 0x57, 0x8E, 0xBD, 0x2B, 0x5D, 0x47, 0x2F, 0x62, 0x3B, 0x4B, 0xB5, 0xF9,
      0xB8, 0x0B, 0x93, 0x57, 0x2B, 0xEA, 0x61, 0xBD, 0x10, 0x68, 0x09, 0x4E, 0x41, 0xE8, 0x39, 0x0E,
      0x2E, 0x28, 0xA3, 0x51, 0x43, 0x3E, 0xDD, 0x1A, 0x09, 0x9A, 0x8C, 0x6E, 0x68, 0x92, 0x60, 0x4A,
      0xEF, 0x16, 0x3A, 0x43, 0x9B, 0x1C, 0xAE, 0x6A, 0x09, 0x5E, 0x68, 0x94, 0x3C, 0xA6, 0x7B, 0x18,
      0xC8, 0xDC, 0x7F, 0x98, 0xCC, 0x5F, 0x8E, 0xFA, 0x22, 0xBB, 0xC8, 0x7D, 0x2E, 0x73, 0x57, 0x83,
      0xD2, 0xBA, 0xA3, 0x8F, 0x4C, 0x17, 0xD5, 0xED, 0x0C, 0x58, 0x36, 0x6D, 0xCE, 0xF5, 0xE8, 0x52,
      0xDD, 0x3D, 0x6E, 0x0F, 0x63, 0x72, 0x95, 0x43, 0xE2, 0x63, 0x8B, 0x29, 0x14, 0xD7, 0x2A, 0x01
    ]
    let message: Array<UInt8> = [
      0x11, 0x22, 0x33, 0x44
    ]
    let expected: Array<UInt8> = [
      0xEE, 0x69, 0x09, 0x9A, 0xFD, 0x9F, 0x99, 0xD6, 0x06, 0x5D, 0x65, 0xE1, 0x5F, 0x90, 0xB9, 0x23,
      0x7C, 0x16, 0x98, 0x7D, 0x48, 0x72, 0xE2, 0xB9, 0x94, 0xED, 0x2B, 0x9E, 0x56, 0x85, 0xF9, 0xBA,
      0x48, 0x9A, 0xB9, 0x36, 0xCC, 0x1E, 0x3D, 0xFD, 0x15, 0xB3, 0x5F, 0xEE, 0x21, 0x53, 0x6F, 0x8C,
      0x22, 0x20, 0xAE, 0x43, 0x21, 0x7D, 0x91, 0xD8, 0x1C, 0x9E, 0xD0, 0x1D, 0xE5, 0xBA, 0xEE, 0xF4,
      0xEF, 0xC7, 0x21, 0xD7, 0x0D, 0x67, 0xB5, 0x16, 0x6E, 0x43, 0xD8, 0x27, 0x24, 0xF3, 0x9B, 0xF0,
      0xBD, 0x19, 0x7C, 0x31, 0xE7, 0x48, 0x51, 0x8D, 0xEE, 0x63, 0xEC, 0x10, 0x98, 0x7A, 0x08, 0x39,
      0x0B, 0x15, 0xCC, 0x41, 0x57, 0x67, 0x7C, 0x54, 0x22, 0x6A, 0x8B, 0x04, 0xB4, 0x76, 0x84, 0xAE,
      0xDD, 0x02, 0xB4, 0x8C, 0x8E, 0xD4, 0x8A, 0x44, 0xBD, 0x13, 0x53, 0x97, 0xAC, 0x28, 0x69, 0x76,
      0x9B, 0x68, 0xC7, 0xD3, 0xBF, 0xAC, 0xDB, 0x72, 0xAF, 0xCD, 0x74, 0x42, 0xC2, 0x25, 0x17, 0xE0,
      0x44, 0x99, 0x6C, 0xB6, 0x8E, 0x0A, 0x31, 0x1D, 0xF5, 0xD6, 0xD2, 0xD2, 0x86, 0x37, 0x25, 0x56,
      0xF0, 0x19, 0x31, 0x66, 0xCC, 0x36, 0x4E, 0x65, 0x4E, 0xF4, 0x05, 0xDD, 0x22, 0xFB, 0xE5, 0x84,
      0xDB, 0xF6, 0x0F, 0x05, 0x52, 0x96, 0x06, 0x68, 0xFB, 0x69, 0x52, 0x2C, 0x1B, 0x52, 0x64, 0xF1,
      0x94, 0xFA, 0xC9, 0xF3, 0x56, 0x22, 0xE9, 0x82, 0x27, 0x63, 0x8F, 0xF2, 0x8B, 0x91, 0x0D, 0x8C,
      0xC9, 0x0E, 0x50, 0x11, 0x02, 0x12, 0x12, 0xC9, 0x6C, 0x64, 0xC8, 0x58, 0x20, 0x87, 0x7A, 0x7D,
      0x15, 0x59, 0x23, 0x5E, 0x99, 0xC3, 0x2A, 0xBE, 0xF3, 0x3D, 0x95, 0xE2, 0x8E, 0x18, 0xCC, 0xA3,
      0x44, 0x2E, 0x6E, 0x3A, 0x43, 0x2F, 0xFF, 0xEA, 0x10, 0x10, 0x4A, 0x8E, 0xEE, 0x94, 0xC3, 0x62
    ]

    let rsa = RSA(n: n, e: e, d: d)
    XCTAssertEqual(rsa.keySize, 2048, "key size is not correct")

    let encrypted = try! rsa.encrypt(message, variant: .unsafe)
    XCTAssertEqual(encrypted, expected, "encrypt failed")

    let decrypted = try! rsa.decrypt(encrypted, variant: .unsafe)
    XCTAssertEqual(decrypted, message, "decrypt failed")
  }

  func testGenerateKeyPair() {
    /*
     * To test key generation and its validity
     */
    let message: Array<UInt8> = [
      0x11, 0x22, 0x33, 0x44
    ]

    do {
      let rsa = try RSA(keySize: 2048)
      // Sometimes the modulus size is 2047 bits, but it's okay (with two 1024 bits primes)
      //XCTAssertEqual(rsa.keySize, 2048, "key size is not correct")

      let decrypted = try rsa.decrypt(rsa.encrypt(message, variant: .unsafe), variant: .unsafe)
      XCTAssertEqual(decrypted, message, "encrypt+decrypt failed")
    } catch {
      XCTFail("\(error)")
    }
  }

  /// This test walks through the PKCS1 Encryption scheme manually
  ///
  /// This test enforces that
  /// 1) We can decrypt a message appropriately using the PKCS1v15 Encryption Scheme
  ///     - Note: This signature scheme is non-deterministic so we can only test that decryption results in the expected message.
  func testRSAPKCS1_v15EncryptionManual() throws {
    let fixture = TestFixtures.RSA_1024

    guard let privateDERData = Data(base64Encoded: fixture.privateDER) else {
      XCTFail("Invalid Base64String Public DER")
      return
    }

    // Import RSA Key
    let rsa = try RSA(rawRepresentation: privateDERData)

    let expectedMessage = "RSA Keys"
    let messageToDecrypt = Data(base64Encoded: fixture.messages[expectedMessage]!.encryptedMessage["algid:encrypt:RSA:PKCS1"]!)!.bytes

    // Decrypt the data
    let decrypted = BigUInteger(Data(messageToDecrypt)).power(rsa.d!, modulus: rsa.n).serialize().bytes

    let unpadded = Padding.eme_pkcs1v15.remove(from: [0x00] + decrypted, blockSize: rsa.keySize)

    XCTAssertEqual(expectedMessage, String(data: Data(unpadded), encoding: .utf8), "Failed to decrypt the message")
  }

  /// This test focuses on ensuring that the encryption & decryption round trip works as expected.
  ///
  /// This test enforces that
  /// 1) We can encrypt and then decrypt a random integer
  /// 2) We recover the original integer after decryption
  func testEncryptDecryptRoundTripRandomIntegers() {
    do {
      let rsa = try RSA(keySize: 1024)

      for _ in 0..<5 {
        let message = BigUInteger.randomInteger(withMaximumWidth: 256).serialize().bytes

        let decrypted = try rsa.decrypt(rsa.encrypt(message, variant: .pksc1v15), variant: .pksc1v15)
        XCTAssertEqual(decrypted, message, "encrypt+decrypt failed")
      }
    } catch {
      XCTFail("\(error)")
    }
  }

  /// This test focuses on ensuring that the signature & signature verification works as expected.
  ///
  /// This test enforces that
  /// 1) We can sign and then verify a random integer
  /// 2) if we modify the signature or the message in any way, the verify function returns false or throws an error.
  func testSignatureVerificationRandomIntegers() {
    do {
      let rsa = try RSA(keySize: 1024)

      for _ in 0..<5 {
        let message = BigUInteger.randomInteger(withMaximumWidth: 256).serialize().bytes

        let signature = try rsa.sign(message, variant: .message_pkcs1v15_SHA256)
        XCTAssertTrue(try rsa.verify(signature: signature, for: message, variant: .message_pkcs1v15_SHA256), "Failed to Verify Signature for `\(message)`")
        XCTAssertFalse(try rsa.verify(signature: signature, for: message.shuffled()))
        XCTAssertFalse(try rsa.verify(signature: signature.shuffled(), for: message))
        XCTAssertThrowsError(try rsa.verify(signature: signature.dropLast(), for: message))
      }
    } catch {
      XCTFail("\(error)")
    }
  }

  /// This test walks through the PKCS1 Signature scheme manually
  ///
  /// This test enforces that
  /// 1) We can prepare and sign a message appropriately using the PKCS1v15 Signature Scheme
  ///     - Note: This signature scheme is deterministic so we can test against a known static value
  func testRSAPKCS1_v15SignatureManual() throws {
    let fixture = TestFixtures.RSA_1024

    guard let privateDERData = Data(base64Encoded: fixture.privateDER) else {
      XCTFail("Invalid Base64String Public DER")
      return
    }

    // Import RSA Key
    let rsa = try RSA(rawRepresentation: privateDERData)

    let message = "CryptoSwift RSA Keys!"

    /// 1.  Apply the hash function to the message M to produce a hash
    let hashedMessage = SHA2(variant: .sha256).calculate(for: message.bytes)

    /// 2. Encode the algorithm ID for the hash function and the hash value into an ASN.1 value of type DigestInfo
    /// PKCS#1_15 DER Structure (OID == sha256WithRSAEncryption)
    let asn: ASN1.Node = .sequence(nodes: [
      .sequence(nodes: [
        .objectIdentifier(data: Data(Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01))),
        .null
      ]),
      .octetString(data: Data(hashedMessage))
    ])

    let t = ASN1.Encoder.encode(asn)

    /// 3.  If emLen < tLen + 11, output "intended encoded message length too short" and stop
    if rsa.keySizeBytes < t.count + 11 { throw RSA.Error.invalidMessageLengthForSigning }

    /// 4.  Generate an octet string PS consisting of emLen - tLen - 3
    /// octets with hexadecimal value 0xff. The length of PS will be
    /// at least 8 octets.
    /// 5.  Concatenate PS, the DER encoding T, and other padding to form
    /// the encoded message EM as EM = 0x00 || 0x01 || PS || 0x00 || T.
    let padded = EMSAPKCS1v15Padding().add(to: t, blockSize: rsa.keySizeBytes)

    // Sign the data
    let signedData = BigUInteger(Data(padded)).power(rsa.d!, modulus: rsa.n).serialize().bytes

    // Ensure the signed data matches that of our test fixture
    XCTAssertEqual(signedData.toBase64(), fixture.messages[message]!.signedMessage["algid:sign:RSA:message-PKCS1v15:SHA256"], "Failed to correctly sign the data")
  }

  /// Tests invalid message length for signatures
  ///
  /// This test enforces that
  /// 1) The signature method throws an error when the data you're trying to sign is of an invalid length while using the `digest` variant
  ///     - The `digest` variants skip the hashing step
  /// 2) The signature method hashes and signs the message appropriately when using the `message` variant
  func testRSAPKCS1_v15SignaturesLength() throws {
    let fixture = TestFixtures.RSA_1024

    guard let privateDERData = Data(base64Encoded: fixture.privateDER) else {
      XCTFail("Invalid Base64String Public DER")
      return
    }

    // Import RSA Key
    let rsa = try RSA(rawRepresentation: privateDERData)

    let message = Data("This is a long message that if not hashed, will be tool large to safely sign / encrypt, therefore it should throw an error instead of resulting in a signature".utf8).bytes

    // The unhashed message is too long to sign, we expect an error to be thrown...
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA1))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA224))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA256))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA384))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA512))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA512_224))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA512_256))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA3_256))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA3_384))
    XCTAssertThrowsError(try rsa.sign(message, variant: .digest_pkcs1v15_SHA3_512))

    // But if we hash the message first, then the signature works as expected...
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA1))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA224))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA256))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA384))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA512))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA512_224))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA512_256))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA3_256))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA3_384))
    XCTAssertNoThrow(try rsa.sign(message, variant: .message_pkcs1v15_SHA3_512))
  }

  /// This test uses the Fixtures (generated using Apple's `Security` framework) to test the entirety of an RSA keys functionality
  ///
  /// - Note: These Fixtures were generated using the `testCreateTestFixture` function in `RSASecKeyTests` file.
  ///
  /// For each fixture in the `fixtures` array, we test...
  /// 1) Importing the RSA Public DER Representation
  ///   - Ensure the key was imported correctly
  ///   - Ensure that we can export the public key in it's DER representation and that it matches the expected data
  ///   - Ensure that we are able to encrypt the messages and that we receive the same data when testing deterministic encryption variants
  ///   - Ensure that attempting to decrypt a message without a private key throws and error
  ///   - Ensure that attempting to sign data without a private key throws an error
  ///   - Ensure that we can verify that the signed data was in fact signed with this public keys corresponding private key
  /// 2) Importing the RSA Private DER Representation
  ///   - Ensure the key was imported correctly
  ///   - Ensure that we can export the public key in it's DER representation and that it matches the expected data
  ///   - Ensure that we can export the private key in it's DER representation and that it matches the expected data
  ///   - Ensure that we are able to encrypt the messages and that we receive the same data when testing deterministic encryption variants
  ///   - Ensure that we are able to decrypt the messages and that we recover the original plaintext message
  ///   - Ensure that we are able to sign the plaintext messages and that it produces the expected data
  ///   - Ensure that we can verify that the signed data was in fact signed with this public keys corresponding private key
  func testRSAKeys() {
    // These tests can take a very long time. Therefore the larger keys have been commented out in order to make the tests complete a little quicker.
    let fixtures = [TestFixtures.RSA_1023, TestFixtures.RSA_1024, TestFixtures.RSA_1056, TestFixtures.RSA_2048] //, TestFixtures.RSA_3072, TestFixtures.RSA_4096]

    do {
      /// Public Key Functionality
      for fixture in fixtures {
        print("Testing RSA<\(fixture.keySize)>:Public Key Fixture")

        let tic = DispatchTime.now().uptimeNanoseconds

        guard let publicDERData = Data(base64Encoded: fixture.publicDER) else {
          XCTFail("Invalid Base64String Public DER")
          return
        }

        // Import RSA Key
        let rsa = try RSA(rawRepresentation: publicDERData)

        // Ensure that the Key Size is correct
        XCTAssertEqual(rsa.keySize, fixture.keySize, "\(rsa)::Invalid Key Size after import")

        // Ensure that we do not have a private key by checking the private exponent
        XCTAssertNil(rsa.d, "\(rsa)::Private exponent not nil ")

        // Ensure the public external representation matches the fixture
        XCTAssertEqual(try rsa.publicKeyExternalRepresentation(), Data(base64Encoded: fixture.publicDER), "\(rsa)::Public Key external Representation doesn't match fixture")

        // Ensure externalRepresentation results in the publicDER
        XCTAssertEqual(try rsa.externalRepresentation(), Data(base64Encoded: fixture.publicDER), "\(rsa)::Public Key external Representation doesn't match fixture")

        for message in fixture.messages {
          // Ensure each encryption algo matches the fixture
          for test in message.value.encryptedMessage {
            guard let variant = encryptionAlgoToVariant(test.key) else {
              print("Warning::RSA<\(fixture.keySize)>::Skipping Encryption Algorithm \(test.key)")
              continue
            }

            if variant == .raw {
              if test.value == "" {
                XCTAssertThrowsError(try rsa.encrypt(message.key.bytes, variant: variant), "Encryption<\(test.key)>::Did not throw error while encrypting `\(message.key)`")
              } else {
                // The Raw encryption method is deterministic so we can test that encrypting the message matches the data in the test fixture...
                let encrypted = try rsa.encrypt(message.key.bytes, variant: variant)
                XCTAssertEqual(encrypted.toHexString(), Data(base64Encoded: message.value.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes.toHexString(), "Encryption<\(test.key)>::Failed to encrypt the message `\(message.key)`")

                // Decryption requires access to the Private Key, therefore attempting to decrpyt with only a public key should throw an error
                XCTAssertThrowsError(try rsa.decrypt(Data(base64Encoded: message.value.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes), "Encryption<\(test.key)>::Did not throw error while decrypting `\(message.key)`")
              }
            } else {
              // Sometimes the message is too long to be safely encrypted by our key. When this happens we should encouter an error and our test value should be empty.
              if test.value == "" {
                XCTAssertThrowsError(try rsa.encrypt(message.key.bytes, variant: variant), "Encryption<\(test.key)>::Did not throw error while encrypting `\(message.key)`")
              } else {
                // We should be able to encrypt the data using just the public key
                let encrypted = try rsa.encrypt(test.key.bytes, variant: variant)
                XCTAssertNotEqual(encrypted, test.key.bytes)

                // Decryption requires a private key, so this should throw an error
                XCTAssertThrowsError(try rsa.decrypt(encrypted, variant: variant), "Encryption<\(test.key)>::Did not throw error while decrypting `\(message.key)`")
              }
            }
          }

          // Ensure each signature algo matches the fixture
          for test in message.value.signedMessage {
            guard let variant = signatureAlgoToVariant(test.key) else {
              print("Warning::RSA<\(fixture.keySize)>::Skipping Signature Algorithm \(test.key)")
              continue
            }

            // Signing data requires access to the private key, therefore this should throw an error when called on a public key
            XCTAssertThrowsError(try rsa.sign(message.key.bytes, variant: variant), "Signature<\(test.key)>::Did not throw error")

            // Sometimes the message is too long to be safely signed by our key. When this happens we should encouter an error and our test value should be empty.
            if test.value == "" {
              XCTAssertThrowsError(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Did not throw error")
            } else {
              // Ensure the signature is valid for the test fixtures rawMessage
              XCTAssertTrue(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Verification Failed")
              // Ensure a modifed message results in a false / invalid signature verification
              XCTAssertFalse(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes + [0x00], variant: variant), "Signature<\(test.key)>::Verified a signature for an incorrect message `\(message.key)`")
              if !message.key.bytes.isEmpty {
                XCTAssertFalse(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes.dropLast(), variant: variant), "Signature<\(test.key)>::Verified a signature for an incorrect message `\(message.key)`")
              }
              // Ensure a modifed signature results in a false / invalid signature verification (we replace the last element with a 1 in case the signature is all 0's)
              XCTAssertFalse(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes.shuffled().dropLast() + [0x01], for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Verified a False signature for message `\(message.key)`")
              // Ensure an invalid signature results in an error being thrown
              XCTAssertThrowsError(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes.dropLast(), for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Verified a False signature for message `\(message.key)`")
            }
          }
        }
        print("RSA<\(fixture.keySize)>Public Test took \(DispatchTime.now().uptimeNanoseconds - tic)ns")
      }

      /// Private Key Functionality
      for fixture in fixtures {
        print("Testing RSA<\(fixture.keySize)>:Private Key Fixture")

        let tic = DispatchTime.now().uptimeNanoseconds

        guard let privateDERData = Data(base64Encoded: fixture.privateDER) else {
          XCTFail("Invalid Base64String Private DER")
          return
        }

        // Import RSA Key
        let rsa = try RSA(rawRepresentation: privateDERData)

        // Ensure that the Key Size is correct
        XCTAssertEqual(rsa.keySize, fixture.keySize, "\(rsa)::Invalid Key Size after import")

        // Ensure that we have a private key by checking the private exponent
        XCTAssertNotNil(rsa.d, "\(rsa)::Failed to import private exponent from Private Key external representation")

        // Ensure the public external representation matches the fixture
        XCTAssertEqual(try rsa.publicKeyExternalRepresentation(), Data(base64Encoded: fixture.publicDER), "\(rsa)::Public Key external Representation doesn't match fixture")

        // Ensure the private external representation matches the fixture
        XCTAssertEqual(try rsa.externalRepresentation(), Data(base64Encoded: fixture.privateDER), "\(rsa)::Private Key external representation doesn't match fixture")

        for message in fixture.messages {
          // Ensure each encryption algo matches the fixture
          for test in message.value.encryptedMessage {
            guard let variant = encryptionAlgoToVariant(test.key) else {
              print("Warning::RSA<\(fixture.keySize)>::Skipping Encryption Algorithm \(test.key)")
              continue
            }

            //print("Testing \(rsa) Encryption<\(variant)> - Encrypting Message `\(message.key)`")

            if variant == .raw {
              if test.value == "" {
                XCTAssertThrowsError(try rsa.encrypt(message.key.bytes, variant: variant))
              } else {
                // The Raw encryption method is deterministic so we can test that encrypting the message matches the data in the test fixture...
                let encrypted = try rsa.encrypt(message.key.bytes, variant: variant)
                XCTAssertEqual(encrypted.toHexString(), Data(base64Encoded: message.value.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes.toHexString(), "Encryption<\(test.key)>::Failed to encrypt the message `\(message.key)`")

                // Decrypt the fixtures encrypted message and ensure it matches the plaintext message
                let decrypted = try rsa.decrypt(Data(base64Encoded: test.value)!.bytes, variant: variant)
                XCTAssertEqual(String(data: Data(decrypted), encoding: .utf8), message.key, "Encryption<\(test.key)>::Failed to decrypt the message `\(message.key)`")
              }
            } else {
              if test.value == "" {
                XCTAssertThrowsError(try rsa.encrypt(message.key.bytes, variant: variant), "Encryption<\(test.key)>::Encrypted invalid message `\(message.key)`. Should have thrown an error...")
              } else {
                // We should be able to encrypt the data using just the public key
                let encrypted = try rsa.encrypt(test.key.bytes, variant: variant)
                XCTAssertNotEqual(encrypted, test.key.bytes)

                // Ensure we can decrypt the data and that it matches the original message
                let decrypted = try rsa.decrypt(encrypted, variant: variant)
                XCTAssertEqual(test.key.bytes, decrypted, "Encryption<\(test.key)>::Failed to decrypt the message `\(message.key)`")

                // Ensure the encrypted fixture can be decrypted and results in the expected raw message
                let decryptedFixture = try rsa.decrypt(Data(base64Encoded: test.value)!.bytes, variant: variant)
                XCTAssertEqual(decryptedFixture, message.key.bytes, "Encryption<\(test.key)>::Failed to decrypt the message `\(message.key)`")
              }
            }
          }

          // Ensure each signature algo matches the fixture
          for test in message.value.signedMessage {
            guard let variant = signatureAlgoToVariant(test.key) else {
              print("Warning::RSA<\(fixture.keySize)>::Skipping Signature Algorithm \(test.key)")
              continue
            }

            // Our Message is too long for some of our hashing / padding schemes. When this happens we should encouter an error and our test value should be empty.
            if test.value == "" {
              XCTAssertThrowsError(try rsa.sign(message.key.bytes, variant: variant), "Signature<\(test.key)>::Did not throw error")
            } else {
              let signature = try rsa.sign(message.key.bytes, variant: variant)
              XCTAssertEqual(signature, Data(base64Encoded: test.value)?.bytes, "Signature<\(test.key)>::Signature does not match fixture")

              // Ensure the signature is valid for the test fixtures rawMessage
              XCTAssertTrue(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Verification Failed")
              // Ensure a modifed message results in a false / invalid signature verification
              XCTAssertFalse(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes + [0x00], variant: variant), "Signature<\(test.key)>::Verified a signature for an incorrect message `\(message.key)`")
              if !message.key.bytes.isEmpty {
                XCTAssertFalse(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes, for: message.key.bytes.dropLast(), variant: variant), "Signature<\(test.key)>::Verified a signature for an incorrect message `\(message.key)`")
              }
              // Ensure a modifed signature results in a false / invalid signature verification (we replace the last element with a 1 in case the signature is all 0's)
              XCTAssertFalse(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes.shuffled().dropLast() + [0x01], for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Verified a False signature for message `\(message.key)`")
              // Ensure an invalid signature results in an error being thrown
              XCTAssertThrowsError(try rsa.verify(signature: Data(base64Encoded: test.value)!.bytes.dropLast(), for: message.key.bytes, variant: variant), "Signature<\(test.key)>::Verified a False signature for message `\(message.key)`")
            }
          }
        }
        print("RSA<\(fixture.keySize)>Private Test took \(DispatchTime.now().uptimeNanoseconds - tic)ns")
      }
    } catch {
      print(error)
      XCTFail(error.localizedDescription)
    }
  }

  /// Converts an algorithm string key from our test fixture into an RSA.SignatureVariant enum case
  private func signatureAlgoToVariant(_ algoString: String) -> RSA.SignatureVariant? {
    switch algoString {
      case "algid:sign:RSA:raw":
        return .raw
      case "algid:sign:RSA:digest-PKCS1v15":
        return .digest_pkcs1v15_RAW
      case "algid:sign:RSA:digest-PKCS1v15:SHA1":
        return .digest_pkcs1v15_SHA1
      case "algid:sign:RSA:digest-PKCS1v15:SHA224":
        return .digest_pkcs1v15_SHA224
      case "algid:sign:RSA:digest-PKCS1v15:SHA256":
        return .digest_pkcs1v15_SHA256
      case "algid:sign:RSA:digest-PKCS1v15:SHA384":
        return .digest_pkcs1v15_SHA384
      case "algid:sign:RSA:digest-PKCS1v15:SHA512":
        return .digest_pkcs1v15_SHA512
      case "algid:sign:RSA:message-PKCS1v15:SHA1":
        return .message_pkcs1v15_SHA1
      case "algid:sign:RSA:message-PKCS1v15:SHA224":
        return .message_pkcs1v15_SHA224
      case "algid:sign:RSA:message-PKCS1v15:SHA256":
        return .message_pkcs1v15_SHA256
      case "algid:sign:RSA:message-PKCS1v15:SHA384":
        return .message_pkcs1v15_SHA384
      case "algid:sign:RSA:message-PKCS1v15:SHA512":
        return .message_pkcs1v15_SHA512
      default:
        return nil
    }
  }

  /// Converts an algorithm string key from our test fixture into an RSA.RSAEncryptionVariant enum case
  private func encryptionAlgoToVariant(_ algoString: String) -> RSA.RSAEncryptionVariant? {
    switch algoString {
      case "algid:encrypt:RSA:raw":
        return .raw
      case "algid:encrypt:RSA:PKCS1":
        return .pksc1v15
      default:
        return nil
    }
  }
}

extension RSATests {
  static func allTests() -> [(String, (RSATests) -> () throws -> Void)] {
    let tests = [
      ("testSmallRSA", testSmallRSA),
      ("testRSA1", testRSA1),
      ("testRSA2", testRSA2),
      ("testGenerateKeyPair", testGenerateKeyPair),
      ("testEncryptDecryptRoundTripRandomIntegers", testEncryptDecryptRoundTripRandomIntegers),
      ("testRSAPKCS1_v15EncryptionManual", testRSAPKCS1_v15EncryptionManual),
      ("testRSAPKCS1_v15SignatureManual", testRSAPKCS1_v15SignatureManual),
      ("testRSAPKCS1_v15SignaturesLength", testRSAPKCS1_v15SignaturesLength),
      ("testRSAKeys", testRSAKeys)
    ]

    return tests
  }
}

// - MARK: RSA Test Fixtures
extension RSATests {

  /// RSA Test Fixtures
  ///
  /// - Note: These fixtures were generated using the `testCreateTestFixture` function in `RSASecKeyTests` file.
  /// - Note: All values generated are done so via Apple's `Security` framework (we assume they got it right).
  struct TestFixtures {

    struct Fixture {
      let keySize: Int
      let publicDER: String
      let privateDER: String
      let messages: [String: (encryptedMessage: [String: String], signedMessage: [String: String])]
    }

    // An example of a 1024 bit RSA Key that's actually only 1023 bits
    static let RSA_1023 = Fixture(
      keySize: 1023,
      publicDER: """
      MIGIAoGAWLOVh+J+wTEgOLuM+vWMeBZJTH9M5j9QgwmiC2BaVNeoUyvyw0hm/b9mXPvIP209Ml0F7mm1c4iWZX+7WF/YpML3S682IqY3sNbxg3rZRn36FvEnltiL+ZpUStXPe12p397KkdinrHbdVohNt0gXQQjEN6m26xv99nitPU1XcjECAwEAAQ==
      """,
      privateDER: """
      MIICWwIBAAKBgFizlYfifsExIDi7jPr1jHgWSUx/TOY/UIMJogtgWlTXqFMr8sNIZv2/Zlz7yD9tPTJdBe5ptXOIlmV/u1hf2KTC90uvNiKmN7DW8YN62UZ9+hbxJ5bYi/maVErVz3tdqd/eypHYp6x23VaITbdIF0EIxDeptusb/fZ4rT1NV3IxAgMBAAECgYAbtkeCQ53sR6fUcavy/+IZ5oSR9LeWu7MwrULGIR03ooTBL1rR7f3XSwP1CuieAEf9QxjGSppY9RRfs49ZZeBuAqDgPmQ9iukya+e3pm5N444WyR65hxyDUuStMPHmwVtUJg+prMOUXEe43PJfusMtISi8BEiNMY9DacLTCJAeTQJBAIgMqq/Ux7HWyQ0tCisZNPQZqGrlkrw4Nzv2DZmLlYEgea967LmnOoYcASAZODAY/yxj3vnfLX3yvGX+CdlesBcCQQCm6CRzikQfRGtYEB92ddV5xeVgN5r8rnNxvD+kBuMB7qrljta3Ir1JHP3gmA/zz39IvfRf6obdd1Qd1Ym07FT3AkAjFlE3A8N0xBYaBdGnh9q2UZ+z4f1T+ZOVLUIYpX0rTjrT3PoMb2qSh8pqgtaQ4QF+a0toWfybjOy1ySy1GMyFAkBWS1ftVON7twg4870QpkPFPggmAxni4t9VQps010qvSRKatYtWDGQJVS/92yEEUZfhqDSdEsi/4F5hPnKAVGBpAkEAgbpGZ3pPOLjtVgGEkF9srvegUinFd4+s1wL9SVdb3aEk/dqGfScVU9JJqAKHTjD6ULX0qfHGZTrKWQJi3hf/IA==
      """,
      messages: [
        "": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "algid:encrypt:RSA:PKCS1": "GrwJv13cGvyLbX02dNMEuRYPPGiP7xxNi4kqPs/OHRHkHhA+4WmIZ+aYfOMlFdoNELJdNAr5lBrr6pwiEV8WOyp0Fnqql78qKIj8YvqDiK6ATUUxuZmWBQ9LzxavIulWeZg+/VqJSMKE3FEmpKkXWCkAi3SMo5l0fgE3CTe9luY="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "algid:sign:RSA:digest-PKCS1v15": "C+S8K4B+W3eM/et63v3nwRsh3ATZJ31bDbl8qhnJ9pdF6So85GzeHPQY64yzRfp4oo+JT4W0WZAhNOi6u9NiBbhdXUPzyj/89rTSYmMEi7tiIhlaoDQV8X+a8gVTJqfM44xAaT82DYLP77TBUjDJEG9WIWKLTBx1EytkvtamRpM=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "Pd0odftcQWd47zlDNmfQHZMdxZPpC9gmivXOfNxOxQ31TXU7g5lglVzUMrykz4YViffJtT6v4MC5J3RRk9a9INJHCpM8hHPx8IgtQiNVN2wHOMB16kFKNuy3d9DO4v1Qklg3MCntzGZUB057UNCwLuvKXc7P5ZwCXPt47Q+P3wc=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "J7/kWa5xUBIKdxLSmsOINlrDTlXLr043xbcH62P8mDNHIff0CHDvZOQHU/r0+lAdtlzB5l9jLOLR+hkyQ8reBL6t2jWyfKPUAVKyUJNT7zZfEfFaGtBi3IK4nS1GQKj7JPJ1d0SCWUCTX4SkLn6pESzR65YI3QIJK/GG/nxmHkk=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "FdkW7WKOlEIBkGSZfzBi9gsS0jFy++MDeZXwe4pWgR6S4J54a33Ws3uwQwnOW+D592IEq1QG4h+4pSmuusNk5tQ7w2qCHbbW7sTZgzWVgpF1HfZ8c0xAkd2oWzw2S8/31iDDromo3OLsaa6C+69bhbqsuNwgkvyKuSxyqziZWA8=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "K5PyLy399mIrI3avLx8T2FwIOKYjy/crsN3VH4GZaFprP4q3xdw9a2ldlngnkfThKTphyS3CCfpACO8V7pZB2Haicre04tgd6uqYwMMBKWTHi4VVIzgwS+SN5L/sC3d4Gwoh6Y9xtUyAbB0Do/s30hbFE8bGC9KV5JbnUairRB4=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "H4sU7sS/hFlrklqN86CWg6FHlF9l/Ll61SpS7wF1Te6Kj78tj1MZd7QMlVKEWGM7RLI1/bkqcTcNzoLGqh1zLI1sg+nUzEqJnx6nCyFT8Qy/V55FqC3wLVpICe99SewDnMsAQiWTwVpiIiwY0vqnS4r+FlCi5Rx/midH0HrzJ3Y=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "JEKtxjsHSejtvffWGafUqy3SjH2EVC5rmSSpz5v3IfPjIlVJxiiCRr7gDwaFNgfNiS4ZaVWGpw7hMeduP0RbsrLezS3hKtaRPlpIo89ET6QpDEjYnlDAeyVZQjgO9EOvkCCJ10FotsMRYJWoipePnkqHDlV1bf1wVh599iOMNqs=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "IvGyNwD8S9eSJ6TyxYv7Y/g2qOvpbcNem68LI1R6IlqBlTFz7xGpdGriLQOUC4AJL/O6NB1AtME4wJVQ3fKCDlSsASy6EGPtIdwXwdijSb5NkiR2AlxcWCBMFuNHlEpM9OrhhaEows4Y1W1k5l0ws4vbYY4/BrwceIeGSLKDux4=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "SavoMjikFHGb/7UOFVI6+FCr2igcsM4esTqvBxeFhHumFGc7Y28fJXIZ1gvw5oqYdj2jCL5okjBUVVnkUkY2TvokN7GHAt0KFdv6F83DdLCwMwaGURgfiAxfPw9kDGoDkqhi9bUdC4FTtOLaK6gVrQzIlqUugGBTBFKySwqdqF8=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "URo+XyJE9cFziAeXJliysj0eO629grgTUYXRgrEOA3B6uIOyh0CFZPi/pKpJFhjGJrSAARDzfbH5AbftEo/C3OSOYOVYsgT3ictJBlYk6NsplouCd/CnkdECi3NBe7MIrsp9ekZzkfULyNje5Y8tt1d0PfAgHNV0VHASxqVLJtw=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "DslGHod+WHWpUFKLrVU6mdJZh7KPE8E7IMPaBMEs6hPYHdp4Yqmv/2jiPBcnqgIfwTX8A5NVtUJ0EQnjVhFDIqYQXP5AplzaD33dP8IEa8ZhIOrBjfqTZs29ApLrSaPxiT3TRP9Z0FMLXCzU8E5QJuQSomLkpaaHIqyMOzyqWTY="
          ]
        ),
        "👋": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "HXPOd8MFU57jSnCPj+/mAvzfzjOEgZltWxp3Aek/hhfH31t3wgaB8JQ/A502umjrFlnBupMwQaQr9iJOWYKTFClfDx1T+BFUJfnH28I1etk8DeD3lEiPTMuV/caR3bT0cxDA2TKeMpp4BSOX7iiC9Vd3WaOMH3xbH5UYFUbEdHg=",
            "algid:encrypt:RSA:PKCS1": "Pi3h0pakf0/QanjJ0mM+AExhqPYnGFX6Z/fji7z8cX1gD8eIUyk26u4opDjyVPb82JOY+ulRBAUlBawcd1M2aiY3O8Bhzpn2awEy9Ps6HWUa9Yp4Un3hLEmySyajb8QdUko0OWzG28cEoInGiOgoU7ko3excvcbHG7O0aJG3FDg="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "TbQzWXDIIX3vir2A8YPSxBLJsIqc1EfydyhTcwSOvHPtKbkIS10bCbtrN3tcK8W/7Ii1VluZbQmf8rQjUXgVAF9s7LNoDmtrHp3kOBUwSBT5ebbr/OIskwVdt2IHoNyYtOFlx8V86LJc6HSLYAfQplEBQfVd83D8EjK6DHJJRWE=",
            "algid:sign:RSA:digest-PKCS1v15": "KJNf91GcrEFS6DZrRhqs2WlVJrJl2Rxmuf7OaPT+ymTDyUGMvGsfM3MGlousZAk0Z4HvaoJCKAj/cc2UecKTM0tf0q4RaO12/qSDM242Max5MotBVVY/LihV0Vv5FGLX4AvHkDCC9W9nC/jDSGMfGSzLqbCI/J4ljxcFrJ6zWeI=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "Bfn8f0RrkdJynMUp8dHWzpAqGPxuI5dKySwoXOmXHtGcqypvv6mnBwzURwIXq6dRA5wL8/GcQ6GAUkPLyQ7mbpnjKZEf0/nHfYkgNkihV2Ay/VtQmvpwwnrtlDWmd6s/a3eLACYZqiNOmNQan2jPTNCbQZZ1idP6ilv2GedO4Qw=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "SZN1dw+SCGZUI5Ue6x2rK6giO9JdTJozEkHXu2DsE1d51iVOHD5eo1PXAgmFRpkfV9DTzEckFViVP3G0BE5H3ZPsem+HyB6+nPuAVArqL7T0JBUzHgZ4T+vThfvMJzExcDISLK7gwc9NOTwIKjePWBoeTv9u+CPHVkxFm2uF+lM=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "RghR0cKvs4hWc4XS++IPdAC8K7fri54d8fxeOoWXMPejVh2AZy9dOxKJm7+NBMJxymVODrxa8JbzKmJ4h6agMtCwH2B0f/NJO67FJFbn+RGsxG7MfvVO4z2Ejy+IOQJEOkIRTKxvwtRlUiJBgiQfdmUClPzd7j6Og8fGMumWFSI=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "RUgGeY9N6zWP9AfU3gLz8oiZaoyH5fvKCULX6/HuqDvSa2Y06hayCo7JLoCLDuLVxMvg44DobR7z6j1Ur7v85Wqv5kPTAAIiGNKEnt90Hpqn9f2RzrTToH6fnQC7ZJ9+e5N72p57fqIjZHlEnFk7o3XuEqpivOKZiSCEwo4KDS8=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "E9V2lyhaDyGWFnCKROi3kcPr8QG2AfCYSSa9tyj8mRFUmjnNyghpUW5gPDCy6nACaUnPOxvB0trJUD+irvvYD+7jr+VDnxCeHwe2ZE/ize0vvJFvtLSIAGGUA2aXTU5CohNvNnJs1wYSIWYVrWkaU0yyA8H73kKzsAcAY1+KSnM=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "JMui6+GXCll9KJ+G0n3XMv5Sdz0PUQY6hDMlrygCdtFiNgPWfOTko/Q88RVHFJXCw7NHxyae6G+IPzvve2AQOEP7TdrivACM3C7sqchTWKEnGV1DbZ9r0f2EZjQ7VPM90mnmxG2uDPyrXTKUyVvTTH/SlYW+Zt5NO5TNf6KH2GY=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "VIP9zszWW0M9IvkCeMaNrgd37kfDI/fKOfSCeK40XvcTYyFuNlSdYhaLzxxK9UHcpD5nQR3UPUMym15FQZb6XvDb3ru5f4/BmeCmMdn3J79izPIZAH5JvyY7o6AjqnW/1SjbIn/0sCVuw815hublKifT6A/kxT21y1KxgUtKAhM=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "KE1l25Ld+OvGwxDcww7PUPXWhHszt55YZfSA2jG0x5MCwkQvxkVvUIb3b/fxXH73FJ6stKO7WR47ihnZXzjOv7si/AnxwS/j4r2yHC5bTPz01NqMHbNZ0eAIzyiAl3Lo41njLn/QdopFORE88S+G5OUgCaA0MfmRyncOrC+Qy6E=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "NP9G1fQikdVJNqxxsLetyAEEIgiZ0AkOWSulSW3Azrz3koW7YLoDcucP/dj7oBtRNmpQ2YD5J7JLY4Ty0BdxVt5nekBVTgrp9kuChqDKAJALnU1CtpWQIDRzeX7uoEytnjdo2No35v0EaFdy7h6i7c2ipMMB04eSz67X2MsD7Ro=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "B3ZgVLml8rkRPyYFbIjZ2ZL4+4/qkGzoHrlOCofM569XLzkoImKSYJ4viCFCRJxMBBg/hxBRLM3sSvOlCXAXdICHegyeJ6glS6bD3lzd5LWXIeGTywLd66tR263D5gFjR1Z8HIPBeZdSlDdLDHTFVa3uclyhIy6zHq/OxN/LMPw="
          ]
        ),
        "RSA Keys": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "Dwu3Aq+tmYoXh2k9RzP30jU0Q9BgzLHVsJfiuGIi34BG5wqBr5Zow8FS+6IGuTdeS5jXBi5EAY7VbmqfW2/L5oMNQ+C+SYqgaVDBXe9a6xT5f7irgkpm0wa/logz3ybEiH7eqs3VfZgwV688PYUr++aHqrti72gd/nmLWLaHvIw=",
            "algid:encrypt:RSA:PKCS1": "HY9udxFzq4HnQsThVd+WvJjveDONZ7IYZCBAD7IFDT5o1fTNrGFKtFXfk2P76ha1tz5P2mKHVkDjaPDd1M6x+RvmX9QMMfrYb3sbu5J+/K1+vZ8bSwYgO1ou/IW0T0KhZ7lkuCjZ2GIm+F5YNjlE0CXox5a+DhINF5RJeqD79W8="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "ItiEkbOcx9MPot85FYOFGyxLA/dyb4Dpf4sv/rFBeCaxSJKIN5JSMMQ5DKy2KKVlQY+Xp99TgInXPu05KalKck3LWjLggdR0b0t0XvEfep8rLzlHkFoaQaVK4y/JDdwVYUoZQ2GYUGCBB1TS0UCfXt1H6HIjy/R/7zVcPpNEanA=",
            "algid:sign:RSA:digest-PKCS1v15": "LSy4h1tf7CtIZt3YusIwYMgciuRdmsMXZfi3TMwS07xMJWiGH3MAqLjSpoxJxn43hnzqXmIfvUOc6ps1hwoBF2zJKVP6VQUiup01T3uQiH6gjg1kkIzrsAmUhwGHMRkgpjvQgb4PcqUXFV6j5B00rUlMZq5IrJxeFIwdsNep7TE=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "I1+a/1zhnmBWOVkoHeRzKb5a/J6xJN3NhnZLduUStMgS/Nm0SV7kEgalYJbVGMIh/kXDQ8BY5lXuWrfOjjisgmSOo5NxRfOBcXxwpmRKstGi7/lDAs1LryCBWajv2hyPSEAky3nih4+8xEhUrjAoWd4shSd7FonUAU027d/AaHI=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "T8JXiB0JlDUC3K8f7NF/h4t9lpc+QPFUUf2AW1nk/bMb1dbquLe2O8AD8Ylfu39g+ebA3W4w/2hn+tkQuVQGMFkZbhrKUUdx/FVVZJveIYigTHjSavM4zJfkdCyiu45SOaY+x7D1WeJHsTbYLSc29qfVZaac9LYCHan4oShnIBY=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "F1rCz2wqbs2JCBEAr4J6xyX5d/xeXaGbL8G00dpn5Zz7i0a7n7avBdTHTdnvCtxaRa2bQtxSsQ1KsOZT3BrVJCKrtcVYIf6t4OKP9tpjh2BwT/AA5Urvw2DDDqMtlwZdBEJxGYLumbnHxUWrKfBzSHMTK2vbwJ19IY769eLfvCA=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "LPRFTu1T5BxGUp3gLbsR70sANSnY67f6vhGvRIU23KE7dUVlHWkm0rTeZNif+LvNWL1suxBHI6fJPLkHfLRd/CJlBOIOzOvvifu4kEX3VIySybp4/fEdBXlJnpVzTdVzHh2hifkWme+derDBJRcXGVO6IcHpJl0xhXxDaTUfMes=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "FQToDphnuXKEDLtEJU0CSf7DgCivkzJLbNnmxI+jVajklROaM+h/+oQcDPDohDbjZ6fsici/rByLrkjgCAcHYTJ1cRzsGG/QIbXGLwjebl5nBD3NiC50Yu800idYmX3BhMEaYhB7Ce6xukJ82/DmCIq2fdyV/usvUJFU7pnRziA=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "UQ73vHah5CXieEVXBmg1SdcVOfO+nj8VyLH8m0b30JCFry9MztxJot5BZZHNGzMbvDHoNRA8ekMgj6bRwrHpr/VwuypJ4IbM8n5C3rWdJSoTfBBPWZeywJkgeo0LzTVTlxjBsCHJQiIBsfIwinQMGARfV/yJMo0Xfk4C32avkP4=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "KU2uKP0Y21I6xQZrIOmSvZZJE/YlU1sNis/y0szbqbF6T9gFSlnrT7RIuzfm26uWMH+d9jCuq6wRRMoNolEhLJqUPzq2xuR5OwSm++U6o+d9OW1AqWjkwBqVYeZKa6WmmXKAo4Y+sLPR2iH7oqUTU1Jfzkn/3u16nTYK7WkLJUQ=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "F8Sdbd9MXz/nigx+honEk/anKLyuafO0H2+fNmkG9Rb3V9cyh/Iqyo4kN7YGXWYHpzH/JSHiUNOFOlVxsA8vQNqFt+V08z4XSaHsFMmN9gjJBDyMTwMibSxqzJPwqV6cWjzVYj/78RdOt22z7Gst5Vrc0sJIob7Lvz9Q5UteAcs=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "B44iwunbuMkEubxni5MM+T40O9/QoY16ykiWIUW5efwpa9WGbEWBVTb10Se4J0qVh0w6J+FG+xt2qaB7DDr2IInbrB5SIKpIngZtNqqE0n0AaD675N9d4nTonf5wWVXvooKOWJf4zaX4qtAvZYKoZs9JiBVbmPXNLvs013/+QVw=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "PndOMnWTZ60cGTDbIwgfHtzl+6Nmhu2Ec7KPvRtPnV0UhI2Yoxa7dFLz6NQUMUkf0p1cDFEWYwAhdQrIzUROoTr3p9dCEoxf2eOFV4S3aEdFGDy2nh0WpyQ68PFizAgSTJpT6ePF8u/1d2npPpl2P0fcsdU3MlOwaUVyxkF3ngk="
          ]
        ),
        "CryptoSwift RSA Keys!": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "ALMTIQ68Jm/8xrjuQE/b0USTShPr1sCX51EVRyheG5gKr8HqZ3BUWADdpB3M5D33A0QCkKqp5NMs3qNvUaGspHTAUnV6BvWuX15kk45P/ibw22n64SP8Y2CU/tGCc6Rf9B5DJ7OsL5n7pZKAbF2sKlPx8VEyFbwXyUPT4cao6bY=",
            "algid:encrypt:RSA:PKCS1": "Tav12GnF3OKhnAkZgSa1Nso24C/+qwXlXuA8BcXybdWAyr9D7B5ACn/qfYyoDOvUQSnDF8xCPrUTsxaZ8HaKb0u+620QA57ueQdQLSK0MEFmwdOIQaPGKm3KwyIXx6APkeij+RA4yNjmzIgQgKQoQsmoBOa01mMr5teFnVO7c1s="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "EIu3l9qt9AyHoTSE5oHM4wICOrY5QrGJkLsbwewA0SfwRFEhmwgBD2tbQ0tK6o8Fe5omkPwoh8fOFCPInTD4r9D3bU3mFSFnaEGkDZAQnVL+0WpKUnMJggDBoBY7Fz7PwqTKVFGPw2ixfK4IoHB6t0qfz3Q0eTO5xzRRtj9XZ98=",
            "algid:sign:RSA:digest-PKCS1v15": "IRFLtTvPhnF/tC7gYCKrhmC0xz9gYRXsBnJtg7yRjv8mRYCDM+xugVDW2GBSRdQRssQBTcXg6mYV6oSR+nlqU4vkf37BVbHSrIfSGWFOZCqkGioMaswjtIEUR10ia9s5YDH5fVk3vsVXJw9s730jAYW8B1T8PIvMAj1Xkzr775U=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "DQtXIwKJHPnR7vG+y10hrnAt/C/g5lMoo7pX6Fqeick9mfGU4tCY4/COUdSUOOZYLacA2IhYAbgfNW1P5GRB3zELc3mveHwIVlovyY1FOhEwzbp+S6SRWP9dmBjGlswpmDvvQ7RUrykQabiPYnuqYdR1jhDbdWx4r25vF+fGhn4=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "VeWhPR0yNYwr9ARUgNEdB7nWtYE1ItUTPupPT/1GEkGD4JNTi0wZxcuIN/Day2QhbFxZ/jDR1L6ToX+mcfT2pcpxAIfJsJQmmj5ISvbrp4zr0Q/vnIwv75BqL2geMx34raQOD5If7HNEYJrHBmQFwq4aKih+e5ADdV0Re9hC7Ds=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "C6cOQd0Z5F20L+ZV+r6WdElB05WRBSqh+lFgR9yDt/kAR/5FRNaJ9ZG00+0NiVZRQ4fj4SV+SBrmPzBfk5TYJN8BQW1QPc1GFj798/aem7qYQySAv1Dd2v1CRhAg/nW+UbK3YfE/68P5MsaSX52dhJfV1+DHVufZytdmHlOgcao=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "URJmACamzelP7FmEIZ4nkymu/jF67VBByot5sscDVUGCQdwDntegCqBPrXJFb0bbT+55dmRCo9E402mMRTLEF4y+Gbf+yFpKiPxkHx8jGbs2CwrFUhlKCSOALV9gGz/QkgEm0vWyLNu7a0TL/fEipkHKURE4dcR0AZhj+1UCiYE=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "B0hA+iRuN8sVDLYPn2365eCuk5qv/TbfXhqwk4HKHWHDHDu4/f+lSX9AS3//ZfWiJQX1Kz8y6QJbSmafr1LgOxDDLS9VpI4uuLYPcW8HLf54euzHADF5Kh69VAUeEq4f+8yF2su9mut5x9561dRa8iG+5+rIIAJ48RLjAzzV2Lk=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "F1B6DPF65vdORuS1mTBRNUW7FkF0pA3iMaU/VTWRomKRG9ztomelprDptADWLbZY6DRMQXSHfZM2wXBLPZGSlF8K3HdDB2xEe5VzZtLyzmY3K118W7jXU2JQ7TUG78aCPFDi76/IOSQV7jwLmMy4/akYILnDVxStIydMzw7uZlA=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "E0SQoSKJj1AMlyz9oy5uETbNhnfVqIogvtugXOmD+KouX8KsHZpJBUj9+MSJb2vWuDjF5qGsSaDGHHkOIEZROCxHyStYIOCtofPMIftov/yXJXTFhNcouYgQk9DD8yzeFII0+rf73or7Q4C4SzlPXF3Ds9kut+7Ozw28o1iwT+A=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "Fe9Hbg5FhjN9subc+TRovHrq5DHncrZRkSswqy6rVNgoBKPuxQsbEP+QgHZqg3zgTA6mo6R+icMvDYcUQY8X5F0pcx/KqSTCU2n0Ec3VrxtngxXoe96ra04aEfwToIWybFslC8Bhr07fg24PlZEwFNCGm4cVEaQNQD+GeKEiiJs=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "S7GstJ9uVW5I1NIgMeF2n6JA+PpGLXFJmLTAqjpnyAK+et+YIRoRA/bYTftnXxMU0wsUansUXxXOs5nBrGf+rdtLLTgzIrt4uHsUB05Cl3sTBVt7p9tK8N2fxpw/4F6Syn9zvxfjBJzKdMYrZw3BtsRHzXO7SfqfayRA8oQfk3I="
          ]
        ),
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "",
            "algid:sign:RSA:digest-PKCS1v15": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "G5neBQbE/ctrRD7Yr2DIWDSxd39WJkKnym6dEkyFq6pQRsipNdGTCmwnjXXRXcWM6XUJG4htvaEnz+5W8rZzZ3fiMuZgRxlA5FpbRoEwvnArYovxgQFiazgRi0CGu1nUpbfgwkuSTBxERWUc+l4jImcWeqY0YdFEXDcADqp1gmI=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "JlmRNo9gevd5XxX8FsnZKSjHeZNxIkPHzKnSMBhFjm15Y6QBtcStIkAjg0wbmcxqX5NX9DAE29t9+4dluK6HXvi87TBBrsrXtMzm1EB247+9224eu2y6kghFuPW5lJFITIUdmxyKT/14zR29OIfEdCpnS9zjmZ2TdOXs7bZlJbg=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "Bn06v122hbYHG9Q8egUW7RGV4cDK7jf9EKJXe4ydpjhNs8pKLIhPhnS9ax9wG9IJWR+P8n7xwGxfFNdSmcrWIfSbbYat5/jaO5718voNC7+bq/N5g2mzzz4ugRAFXiDbFlA5pWBaAZTE+XwxH0pSg/5giC4RFi2qN28ihvWHyOY=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "NvxOxIy/szgB5p+CY02JqM6ZwJLvCTLYOpn4xkpBO/kxXG9NJX9AheD8T7mwEiMQw8dyQ200oZFkyUDFjBoHNZy8rXRf214INpryypjobte9oUCju70v3g6Z/AMkSetJqBi8hxVpm62op0Co2j91pxUYXvO/XVpvdB/6dY2akO8=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "K4vWQj11zTxyMsZG4XKYrMqdxYZ7XxRBNBREeYYlL5xGOnRdmW+m5ZPh0h+vRIa/8IEPoyd2fvCBOUtx1euNQfPD1YT1UzxEr5ua3cQdylCWa8ghfCaOeJuhhMUFAqhjHQfK1NBtEH0bAvvw1XcxLRbTwupdPJjAFGUfmMjfMZw="
          ]
        )
      ]
    )

    static let RSA_1024 = Fixture(
      keySize: 1024,
      publicDER: """
      MIGJAoGBANafJnOmd7j9o05NFzmoOaPJ5tvKMOybyNQuTdElOI0UeUu9FFAKBJD1ClT1WMuyDzIEZMF3TJwohNnkY7q8tnuTHdO/f3Il3b/1bt4QGavVwnrLbalaJgFmnvaLqTs8dYu3nhcUZhWI+eKjTZxjUg1LrGJVbGZtbjTGPvKcvjOfAgMBAAE=
      """,
      privateDER: """
      MIICXAIBAAKBgQDWnyZzpne4/aNOTRc5qDmjyebbyjDsm8jULk3RJTiNFHlLvRRQCgSQ9QpU9VjLsg8yBGTBd0ycKITZ5GO6vLZ7kx3Tv39yJd2/9W7eEBmr1cJ6y22pWiYBZp72i6k7PHWLt54XFGYViPnio02cY1INS6xiVWxmbW40xj7ynL4znwIDAQABAoGAGexnTJjS5TldvFt7bq9vJuWASRQHDM1UWKyvIZAJYKEUdZ2FEpXjL08pzFFGRHRheX0mXmf2jPYn9dmsYiXhNJsiUH3hV1trsccv4tHG3Ctvq3xJ3BY7K0IGPhGNEAlqTLOqM3QeU55PDUenR8C8Vx4Ooc/lm+YRlZ3w79yX06ECQQD+tDVHmJ6655sipCsJMgOKu9o6Qj4v9FwgJf8InUFLbOqZKAvfAUANBiX8FOKZ/DENAFnU2sQUfB+emoLNEzYNAkEA17a6iGZ2YnRb1jsL+MAj4qOS2z+WG9v2WCVl/ZPATAa/+Np0TUSAu+XorUiG0Zx+pClitmaQgaVBBcwXaPexWwJAOU4gQqiC5fhf/g5DpID9LQSQ19S5mx52b8E8vRpsa2To72aELTthxsxgVXP5e72y54LxsyM5RIacspl+3lb5LQJAQEQjXKHSIVDzT2b2ER0FU+9RwFo4WYJ16RrzQNH1F3FnXjePMLn49IHxiTazW92Y6UWfMCJsaQOX1KdSTiaFQwJBANra8gEZ/e3gN39+Cu4eFyFm8afBd4ffLnpdKiK1yPebsLbTv66pwwCAchv6uyIHihyD6Kyq7XZvhaLMo7xwfck=
      """,
      messages: [
        "": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "algid:sign:RSA:digest-PKCS1v15": "yAeKf1vJjQ/1uVxOZB7sCPs5cbN5CTfXkhqFZeFJgahjBgmb+hs0GmIdRjmlgTWAI6rH1Ew56SkiJgkzL/7RbqWvUuqPsyPz97NeDbXXSI+NTy/7W0KaInF3YdR3GSNAIMHy8qFLiCeXNFY+6ixuwFeHCOQrTijlBqtZB2g3+e0=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "dsQr0HbJ5rl/fPLmVPLgyTqk58T0mU7C2gyrt7qni+AFsvdLNY0gIyLKC9hV22ChfFb9FHDSZ0TAnfJV4F+OklAYaGYhAtYNHcdohGN5NkA0P7MN88AoU3TWculwIFdtmSgewZZxED9aaddo9bbUreecaPvzfrJkdpC3qQY+3QQ=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "GMGv/t14qzu7Hl9JuCDCPwJIs9NGSI3ObVHucfT1VD6nvfl01oSmUx5Z8YFG4xh+eTfX1yFwuqo8h8Q56v0Mesy7h0ZBR4KbvITir5umbnxOdVx4CSUG4GBgfd5n+xzC8mhMkfFbzgZa+dDe85XQAfAIY0OBwRb1SMkRV529TWM=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "mbsLcVYBBPlvcpSxdOpgoxla4N1bvN9LYuFvsKiNV2vFZQkv9aFeGDTwesz0Wh6FTzObuu63veZfCAKS+WYkEXBmoAJ+ZqAmYhBDEtuFPUyP7X0xK6ZRL8x1CB5qEN93k1eYRe6c4lNwTK1wxMIr7ocfBlIwUjANK2ZLlvInDMQ=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "RxSKRd/lot+Ba889hCuTwjBUt81jiGmAf+0MFttzum/fBcyhy419n++mzPzVG1CIZtcBS5sXdd1gqJNlve+E/GG0f1/vuLWuursM7+IqWntukWk+v6zmmZq2S+skuKsYZJfDTkOpzfYyyARqWWL9fweut3nwPRSjOvl5q+kgZwI=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "h1n6982vnm9JwiLFOsLLlBmnEw6RmlR8l+XjQPUyUaTwBaXf6jpAORfNWarWcTR1ZG4DQVvfN2lFyP9mkMwczXkV7kKl3kDMxqZ6DrFL7GLmDKh/xRvglNhK/DxfOV+6PmMhzHLa01Mz424B0IX1uE+nN+XknGwPAQ+qIKKOJqc=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "A30eJ8+4ldu7KRjdWy6hvaXaP3HqaR7vq+/k+wm38PbjAI3YkXZQniOm+q6JVkYSfy7EqpnMvU5xiC5gkYSser579mE90ZwJd2nNO34DzEZYm/rAZaEYB/EeyIDH0l8mrAy5BTG93HSa8EbX1hvpJ6X/LfalwJWI5/eoxFczrYg=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "JQ48KbGEzM57dvsBF4QLJ9hP+U9fJPZTSonnls55viRTuWToupY93vGfcZPRL0LoS97Twfxt+Ax13k8Inu9kJJyjPinYE3qgdifUTlTUtZJmSfKUD8L+/B+fVbeJ33znSxepBOu3zevOSVIuDjXlIRrhs52oGtK6/7N7D12pXsQ=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "ZlSnyMd7IuUE3+9GrnxhCZvUC6xaWimK8TCRh941xq+Ae6Ofv3bNc8p9IZBn+mM68Q9TX7PMjniHTK7CIoXvLWQx4e+nOPZXB+m9NX63yKxmXtC/yMRo2F+FG/ywYU6J0TLuOov58ULqoIIroUDd+aZZqPnIC0qI8i6/E/DiExw=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "yFltWqqP+amkWRgsc0IMvDYC8uLiM6E1UydMdwtnuMidWZxBSBu9M96YcGRKTog1jcWNcTQb0Ly8uyDHLQO/sCBSR2H1vGKd4wl1n6xlBYKQZOI0b1VQ8c1JKHUpSkquVDTOHPhdpzTMD9P1F3AcGEF82BCSwxdNDv4Asag2JnI=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Zv6PL+K65f4MCWdq6uVpfiUh8U02aqoq8uUPSFJiwE+a9SEGRa6FC+Vk7dthMVi8r55JCvXLbMAzd97kw7OXlS6cs42hi2tzoUtewflbdTQyWj5M9ruD/fQtdi6bSXXHbbZEnSwkSfhuGT5DT7ysKc/GAnrIkP8Z+Spzp+CUXew="
          ]
        ),
        "👋": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "JpNi0ZtVYGFOqzMm0jQm5xLct3JDlizrFOoaOlbBOsLogq3NvkwTS6eiqI39ldbFomTkQeQ5DUXGGQacajzgdi/jPpEs/17poRI5v8xwYytDzsLrF/vjRfdPSbTTsO7WEsFHGcUUrUKt+1jtM0vLBc8aCkkElkIs8TdmddG6jrI=",
            "algid:encrypt:RSA:PKCS1": "ALOEqjLmjgezAhWo1EsKY0c4rczVDeANjrLp3KAMBiXMkbgV2B3nXttY4qtb/B5nYa2iK1G6XJ+72Yi/9lSJoIaOUZ2JfmhxNGnagXzW9d+NAnt2VIxlUMdInve4gH0P+bKUXtJ4Y8yIx5S0cDgDEaNJA8pGYnFFu/2+ZVfg12w="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "N8EyiZfzRGF2Jh9hFCaeo1y8wGH8L7YB8hscLL1vMwU12hMYH4+uJ6po+hwHDjsZj/nELO+faTX5i0iZIaAWhjAxvW8XEKr3aY5+lySYnt/NlTVwlooMi4pCiKW/VgN0jecf7iumUATC2z2VFkZ4CoL3i8aJx2KtPCHcSGJRxWs=",
            "algid:sign:RSA:digest-PKCS1v15": "AWWAt/oKiEUA/NkHDb2fw2EN+NOYNXlxa6lh7oUfREJTOLHBLCORBFo5f/BjTcDdJDYJBw2Uw4mWBWphBoLgmD06DsjmXpn8WxMIBKkT10qJNJAooPxDf3YG8e3PBirEh90N/zRdIhPNsbWfHVMrU8DHzTBwk2cOYgcPu2Id56A=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "Baf6LsSUSMFs0FdIQXPe2rRRch9FGsOtZ9WSfzq9g5NMjCAkObQGCtlMMVRw5L8qEoz3UvKJ1OJ02TTkpk27VTuS74RL2GzyeF9GfvQSlVmHW8gDOUB+0+kPiU2ZT/cwG9l4MTWkvU593cc7J9LXZho/fWhHffP9TGdnCtIZXRw=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "nL1mwFUbINKqYdKejLf/f3JhTfr4FPouVHDOXfN6CyKkQQg8DOE1ACERQEGIDmYyetSNKEEgqWSwN+u46Wr7SXHacLcCsEtQrNrisdwZmv7BCsMGzjXti91JHBLqZHTY66v4Ht16w0VxmFcBmEW+2AlaK5jTh/YS3npiSQ9NX1E=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "Jb2v8DU0T+4Qp+PF4V4T404asAiR9s1XrBDehLXTrZas5TjRY5hgkc77A/a+lSxhRhCDA9Tc+Nw0ACMJW2PAYtDuNzEjxv7WkOhTJ+OLu/eWFIo6/WFRnPRu9a0uZzHEP8T9EPrhasoh3R5wQPtxlB2uBn5bUHhYEn+qN1Y0sRM=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "mxy9mxRXZeDHZa2TLMtHMt3WWhEyCHBhzPDILFr4AJ9X1RooP8WLocn/E2S2LQwYLYpW30ZOaXZY49Zd4dp+1mll9DppXcJkDWymXqdRj/T29SaJTDAIcGDfP+wnLjoOSlXGXs5NvTIJkgxeL44lSPoAvJV4vhNpeJGyp9GU1Ek=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "iR7KaI3RtGeNN1sSRmVxcCGb2ElZMh1dq+pmjg8igTicGpDQ//toLeyGQTdydJzsPFdYBG3SY9AIdaTOiZK6btPP8cL+tq4aRQVMy3aP53puahdqgi+ODvK+O8WQxSLwg+pDACMUCkIQJQA1nWoQ1JIIVq3ExRFsP9H7i2770QM=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "fuBRRx3U3JViImQMfKv1dDNoKJPtXqw6TN/44d7g6kWqwyoXe6XFjpy0P4tP28YAYJzCa3mLMfXTP42+B0tYXZA8bsWifXK2BsWATMiLRCikkyftg371eh5M/+Fw4oMPf+YdbeZmLgOUkdBR3avOjWBC7AfjgOKdBqkT6kVURpc=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "0qI2qFArOlA6uRmNF3uguPdmXhIBqhxZWzdUeXAwBseQLBPdl7rbsrh/AgwXFsbpvp3F4K1l1y8tON1TCUXAcYrP0NnCYKYk3hUuzykqWhhAX0g76+X63mPg4S34YQZfdW8EjhqoE7oubD3OslrwPdBR8JlwAau9f6CwbK7YkbI=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "noHkDUs5ZO14CLy95DEkOYQG32YmaruzMIZgBYgwv3vi2LmYmvCuOt1DoSFRb+nV/uIUrjqgAZFav2LBpwSuoHsB4sCSPWWIQicaln/EJx1+LUXpF+gG0KZVOkJNbvUTi3QqcXuW01TZZmw8MydKN/QTlBWlYhM+sm+1w0gYwyQ=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "Su85Fjt06dIRdIEpufLFEBDVumsQ8EuWyLlH/qEnHyYFfQP/Q5TylxgBCc2a+nvuX74EsvUyT65zIYrHn48zKKdLz49CClGqJlMRIjZbvyrAT3+ksK6dD+tjy2fEgtRDDcwLICowmF/UuT4K42GcYGLXNkZju8Yulh4EJJL/mi4=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "hSgRsvhQeZJzf9ggO3YAokfrY8VsL0q4OcZN6msqKXZE6u0Q1BMACc3P/BM3SOSOEYrYLr+uedpntEvXPtiBis4R5VvamMQF1tzs3QMPCCcbnwMPtuJoT44pz44NYdHfAyI1KFgZeEwcOevJW/DrUFkQG8syR6ew8mE2sEJl9ws="
          ]
        ),
        "RSA Keys": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "A3vPcAHp9sIZyBSoSJ9e+5gF1I1owZtPn/T7qYlvkEu7jCELW/e4IlLrHh8oYZtaw/+NJ4O03CoAM5ve6iXzJlCWvoaEBeAVhnJZNEwArmKk1Ap5R0ZKty8RiE/V+3hhKqSnz4yxgvkQpjZN+xNKWSUba6D5n7GkrVykdzHY0sQ=",
            "algid:encrypt:RSA:PKCS1": "ottU4RoCisIoZ1zSjM0Wy3Xk9HIzFBiFzEcNPUqcEgd0FY7KYDnnquXmANqj/a2cAgVFqZLWrYgehvOm3fpW0qdNHFDAKMQEyCu0qp2ovYbkAmAYYs0klBsNRIQS6QICIJ3sXgCi05O/0Eh48k/+fa0VDqrBkAlBhLQvxvZF0j4="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "WenkBunlIy7kQ9BxuS/fG36eHLME16vGTuuF8ZMiO3RXnJgjS0dnMlDSBAcGYxWqDq1cZU+BmYUjz7Kzk/WwS9+DimrFYGyQjYfDLylHVZ3HN1fJd7SMgmG0LbonqqKBLm6YSls2HC2Y2kApDnfomc/owevOEswGaKYybI1ItK0=",
            "algid:sign:RSA:digest-PKCS1v15": "APEjD2A4ULLM8pf4QkifrhmW3WmrwWtfbybmCSdPlu9NQsWt8i4MbzSqF752iDhafRQHZJ3HRh1COFnmBGmt/OHbJ14AMRgiL0MAPF5nwDfZGhkqBt/DsD1K8i7vuSZCS4sLLn5SvcvdSYdwyz+cJTRkis5wKTdwbENF+pKKSgQ=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "x7WcrpJivdUX0MeQn5btGtWzqvg7vKhh0aqr0AhXTm/6R8jUsvy57nKrWYT3oZhRaZYQiM4iSOrhRvgXzmd/3gFQZtMCK7p1CAh6Mebv/WKwaQXCZauL0V4nKea1X1rxsU5hqlio9kfKEk/z8wYUCyDyAckPpUHSMGXiVFV+Z7o=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "iIUH2m4d6RThcOVrP+CXItTL6ZZYd3L2DamMCkLDnwCRruP9c9wsidK5FTI1+fLofftuBe1OV7GjMyiSMBV/ourcF/QrzbOINLKmF1M9STnlnCAdUKZS2W6erc9xyxYillvFivy22MnjN2vWeaRndM2fcJwklaiEeZZsOWFlANs=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "WhESRms3ivNwlXOzrIc2PhdyTywdbJ8QB7O75jxr3lcydi3UaYMyig5nif/InPCmyhlaU6k/BuXt6kGuqjmYMcCECIKrnlTcLE2ob/RYcOcmbNvyvT08t/8M0P/Ee//EsxehfhW9ZLzLUeuDodHUwYncXTzaxnyeoi5yMDp4404=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "obD02BmCEEKFxEoxFOuUgGkNQlUEAUYNQb0/p3/yYgLJBgpCt6QRt7jTEOrifsqSj7dbxb4N1UQzGjAnfVDong9WhB6qHaiV3LLczbnTb1CLDWnSIDRTgH1OmrUqJHuTcxG6c7lCtrfIUvFoB2u584mk0l5n7Qm0wzSFjmC0fxA=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "hUPfDfsRD3R0YzK+bXmvdas/iJkA2oPY7k0ohUZestI+wi76bOFpnJME/U75LyrHeU+2PXMZuzOne+HOy5xfwG1qXoCAa45uCUkO9/1hcJJ9p7iO7zPMDbcD8q8SHQnAWw9oqOWKWNppJSyZBr1ElvIy9ZZ91XEiWRwzAUPvWco=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "db/I881O2pZ2ZilPLrbFvBvRNVT5rMgDJ+gIkFLXJJX8o1YxKsEGcCOGMN2yOsF3cIsepJaPK8/7O+IVtsZIlkFO+7PFLU+QN8A9xQh/RAR8jVSxZEmlP/qPPJ+W+hv8HUA4WZ0Azb5VLchkO+z9UFNLxeD4qsm9a7wcLH/pzFU=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "IvnbMwj56jret+mw/IS/LMkw4PySyx0pcTmzxLIdob6o1tq9oi0IVWgprZ2AI3QbjPN4Q8wLuDRr/Vx1GAZ5Ut4O3UhxNQAmbgpheL/0180Otl1GE3lhru0Z2kOv9Brdf4Ro7Bxq6bPuZHnlHI21WTOlHis1dKPo7LGnBm/YW34=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "pw7oXUjREq688eClmI/SyiHwYpq7jwbN/3j+zVlF2xqtHkEbz+goCR0v9t5h3zjnYPPh5KtIRbNxm4a+LN/XG5i6hcGrslck1lukqolwhixt3e8spEzek2QgTqfcbdE8W22A3iv8zd6ofeTaY7BMZ0BfKlUVCYQfLFbRO+hDzkA=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "eOLJQCMSJbpwdRJxw3wFQdPD+Zrg/5T+PcDScLmtdOsGwXod01oEhdsADvpEotm1PiGazaTea8V6o3Fi1C9JF3roykzFp5T8oo7vBZ1RtajKc7RTUpvK2RcbhvgTz28jV6R9MJVJSaqF/XlZTrVbXgCGZ1pppArb2Gq42NhlyYA=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "QExyIGSV2qN4+TJikbVzOlnKbz88NQTmp4/oE+kJzS6XNhWAYwEz1I5av782lesQnnofuUixEigX7MKbtB2//Mzl4TMxojNfYheo3F1e8fm8qfpOtH2/RYyrxJx6yTkRj5/tlcSwjZHs2shgmeh4vc974kq2LkDvzDprw2f5e7o="
          ]
        ),
        "CryptoSwift RSA Keys!": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "iN/hoQzpwUzgEEVTgQX9CB8pjv77pRvcHlh3GwLhTdHJZ5DNFOsigroxJxT75ms9Y+s6q/ogRdv1F/yEsetQ+51NdO+IaWs8cN4kPAOlTYZqwc6xdsqvxvKfDhu7E8tLuofkQDIIUeoXnDDOV1zBCzCs7/TdJ7aVZCh++QQoWlE=",
            "algid:encrypt:RSA:PKCS1": "sTfXJoFBif4MGfcg3AjzPxFfM00B+gj4un9XmNw9AeVQbsUgx9/GayhkvNa1tgKW+u47jQcY16ZhyceTxBF2Aoqh4D4gVoqPcenEIxsnAYQeek7c/cp0hDk3SPNZ/+eSxeJuAV5/DgIttT35+TKmzcwNdSndCgm6dY+A976NQ78="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "IWL54w92rMgBR8HGWEv73JYBuGUkSmnA8TCN4HKFRZUpA5U2BeDSp8Ip89C7oIYACQ60INGXaUWeUi+NSXurgKJEWfUGesfzzfhyTOoHxOopdNyNEdRLsl5HjV4HMPcfuGuwOQ2BNbMWd0owTTKiKQRBZ6ktQ2JMRSQcw0uU9G0=",
            "algid:sign:RSA:digest-PKCS1v15": "EBB/AcC+I4SGvkDQDPRYgRY/P8bWdcAOaoCE+0lLXDH8omLd1sQOiRbRwedWpoM2QDnqEwbNcSbHXnRgDw3UIB5P/DURizip4oRKPm//vsGZLCQAzPYTvjaM7GqJ5/mvTXOl63XRa2deYRWneA0kM76Dr9wlyvhiAfbnGmwF/pQ=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "OwaWORrWAby4M5p01gDLHCkgX+uMFbVKLaSqq7g3yc460SoNUOS12uLXLr4+c8j3H8IZAolASn/ntgDM6q9LaDEUT3QJA4ARDLNLPbCtzkM7y5ErEo5/b6Q25O+mzFIWoyh6O473s96teTaZ7FMwCOpcH1hO19BiX3Uay+JbFrw=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "hgde5P3kvsn5+OcPgMf6mZEOOMAtOTxl0pDonCRXVXMrBIjZkOkSyeonO7va+cmblHA4wa7Pak4dbm28vVMH2qKuVD0OQHY/3bvxef0plSrW+U2rfH+HJLhj1u0ix/rwG0D7WiLq0tyHmNZq5fCL9V568Bff6QiZobgb2PgiQ6w=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "h/BWo23Un5vGlwRHZg10E/P0hVrO25jd1tSftyaWW4j4bPafA3gnFvCRGNqN/Hs3R09uEJZrqHnnDf5/B/MHfgFx7x4gmJ+KmHmzVQt/+ZGs3Gv7y1IZXsE0PmhIcN0znjODu3LTHR3NrY8mxml/ZIbTw/rUcD2O7GjyjJsceX0=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "B3CEn6LZlIqrvGTPOVEqGuB2Exn+9iGMIn+e2r2MvuhkJot9hoT6UBne3jWDhZT35TxssTelD+z5hyWemqGulaiBwccgKSfIVlqL0kGhyF45DQ/f3wRHa7gqPdGRIOHPMj1LzmqDeoCXc0Lhrn8vmQPC4IG+oYJFDUSpBs3S8T4=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "NaceD2P26yV5uN31I+hKl7dlIh+JmgpAL08EWxFkIfTkfZN0kr4753AOsN+fjz1SQngGy4sxXJJIEBwrpK3YMRIIVPWAlO0fX/ArZzaSLkwDqR8Rau2NTvpUDj5hzZD72EaJscMMvt4Y1LY0VubZ9jYmFjzLoOVxs5k6YgtHZII=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "G2O/fR7XumApE3hQcZifpeQeCs4pmAXceu9bKN2FKEGj7q7KWShSUnLyRqVO7N9ZDFn65uq6zyEwR69hpg9eKsCQlZ50tnl9eYuDgmAshQvu8HyIatD5vPSwRRN1bjKr8nSQ1UVurgkNkcLw5VljhOW33slzD/f3tfUCfbXGp5o=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "SESOLgXnybYNZtoQj5onqdNQbN9ZqTh/i4FrFdAkVgRK6yt6x4Lg6kSMIH5/oMBFLs7XbTmnkKMkOrmXPCGT9jJvaD7axtZCeXuBx2GFhMfaGd3IfH/4ZSo+4r65BmcmnhYnlqB6/ZFY4Zyczqh5eVDe1moPm44uN/evUWQV41A=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "F8y4UQPGMioJIUrxAjYIV9OYMBJlKb5e8EQXHmPT5JauX3ejkkqyjyQr7Q6H0ZkBnnG0VSrqHx2m/3MdGzXDWFcgnLRnrv+i0trppUPSMYnt1LcW5uBjsg4vm4BLW+Jdp4uzIK1JdInfeWmBOZwa7QwrhK2qWHHG7eeYgdnH8c4=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Xc2GvDotWv1ld5uVNGHCL7sHxv/VTdcxOGpG7xbYNyrFm7rnZ/cC/+RngcJpXUZEVl+kuafBt3peXP8GmVT2iWyFqhCRoIaHQjordWQb+kfwCuaMoOddsizm5Pj2Krk4XLJ6vkIAYKRmLVrhRPvAObDewMLP5A5MhdpHQUGAzHU="
          ]
        ),
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "",
            "algid:sign:RSA:digest-PKCS1v15": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "sQ0YsWQGbYJXwbx+0BlturgU8TJEyYlTbnJo0D5gcVnov8XG0ptDVM2wCXqhVM646nH0HiH1eOOjXZa25uRD8P1WwkT4AFsZxmMOm8TOn+h5H/pas7V+kG6qz5JAaQwrgaFnejCtcawDgSInN+aRdnNsHp+aK04Z112mHaNR5OM=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "kXESCymon7IJ3YGpBiMwVW6J+l875YMPtW7me4aGvZrrRvRHjAPQDcqMMKPM6JKOb8cBkUM2FhC4uda9J8X0QZku/PupFjBy42A171HU6W9K4e5MWDh6w5FDTg2kyO1VhcLgtqGjPxx2q57+UokggHdXNgETDboEKLhiTkLwVZI=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "yhxz2RERdhE/GB8hAr+Ttca6YVKBOPV7AjsQSGRaMTjDXsw4DZDYqjHAJM5xI34yPmXzfafZ+jd5vzkRBkMRHhzlqlCyZ3EbMbykIBmCGu/xJI1Ppapoh7LlCUnC5Q23hUg+WSfNcpaaIPyqmwuuM9vk0UrkH9GWLbjQFg/PalM=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "cShFP8ZmbN+VACN/yGRzlFPEVLcPuoGO/CIRvHBQrg1h1kEhyp4JJmFENtKpPWQEWNInrU4zeONa9TXxGnq4NcDf5bTvwcCAbxf8vRl4swlWp7HGYmkgNbEAbR4/TFUOvZ9LN/PrFP2xWr5BSCkyTw8R9jRTHeZFa97nGq72GA4=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "nKKmZx9ESVArtJeZXLS0bPVyLeW01hN3i9jXZkv+DLDPUkn6wKA15U9bGV0LEzRhfGQ9yYj2DnVpVBaviStx/JxYL+r2H4qKJwyzaqE0rB3pZiqkxMrzCleNNrx8mxRfdoVyXpFXQLd1jLOnDz7FDFn0m3ChCJSzEN3ujQ+ysos="
          ]
        )
      ]
    )

    /// Non standard key length
    static let RSA_1056 = Fixture(
      keySize: 1056,
      publicDER: """
      MIGNAoGFAKWx6RJnFWkMlZnnGQcFm3qe1pcIEdKY74OW/9K7VGF/dVw+CKfPqGHC4L60a30vTqnhpOP6TA+vW0EZ8Jfybe9ARPmbbHknW2beLGHo/vXj/+/Ln/3o35JfExEwIhtS6Go1gAnGBmjBCbIpJ/zgDcoVyFB0qUz/qSGyCLwG7vTXYSuaGQIDAQAB
      """,
      privateDER: """
      MIICbgIBAAKBhQClsekSZxVpDJWZ5xkHBZt6ntaXCBHSmO+Dlv/Su1Rhf3VcPginz6hhwuC+tGt9L06p4aTj+kwPr1tBGfCX8m3vQET5m2x5J1tm3ixh6P714//vy5/96N+SXxMRMCIbUuhqNYAJxgZowQmyKSf84A3KFchQdKlM/6khsgi8Bu7012ErmhkCAwEAAQKBhCEyNanUMTvso4REAoWfn/i/HesAWOHCdin89J/5m/w0lwS2APHt7qQ3cOOELgzUj4QFiw2JtfdmgHfYhJVMoq3OSDDbVYm5ubWkCltl++DT8R5L2dxp5sWELQVAZi6Dy7137yhPKt1RU2ArnOlOGpIM76aG8ONcsc19hPW4Dr+bnLoCoQJDAM4E9j++YPEaShNFrK1mJ3VS01M4Ei0lsxfZ3NBo2PcyB+pihhSQSqOAwsXEGamohdTecZAsWS2sTM+MNQ7IV/cSdQJDAM3kj3jeZv6aMuGQMGuDJmKWlp1v5F/nAfgPvYjMnUmHkiqS5VrG3L31Y4VGEf5a5idiwZPtnGsMHtQ+bmlYxLLslQJDALojt43eZ95PX3BMOnks3Cff3rnI5ntOHaNGH4FZyfaGiKpXvEcmG5ngw5pF1N36OnkbRkX6G9TtYTUAvAuQLhI45QJCfqeaJnVRkE9U+3LShmCQLVeLYV/icahOisVMB6ovG3tdS/k/Q59PTT91sBdRnFFYgWP7xr8FWMiE8nVRQFbN8W8dAkJ52r8vpPMhq7s+DVCmpLocL/A0WXsvlsdPnrE306pqFkyIs5V9M2+IQy1SDutqIWV2POInkcrT9UM2ubydJSTo/Mk=
      """,
      messages: [
        "": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "algid:sign:RSA:digest-PKCS1v15": "Ul+IsDd/9H1e6nB07lNFyAXz9WRm3+15s/PVwAMrWHUz/GGEu0FCfA2hXoet2nrYXMVxWCUu1jg2bijuL9KAj90A7EKzEK+dMK2GvMRWUJjvLqAPX3rxBwoYV5OV1ocwh/bVY0Qsp3+BvL+ehkTmYvLmuYoJCRrKL8y12pFbwEraIxKs",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "ZuSggaLg1NXJjJlEuMsyZKHSTXOQYLYRwem1g8MftBQuSDTDrSpGalAqAqtFOdhBGUew92XXAzSbrm1qUvTvDy+BjdgdAOaDFD8KIg4FofKz6gAnKNP+eX2PJgZ3mpP+3K4YyRCt7RAHVfCbFcyfh/Fazrv44jSvevOgxXA1LLAbvfvn",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "jQlax0NxM5VunnO5Gv+De5TrhCBHDSSrc86R2BNpCuWQRMXhxX4A/AAszsMHDNUvrImz0/aAvB/iONh8mAbc0DlZ2xRFx2biVVYt2Jk4bmaoAJUDHveLeu1rHKzSw+aClW+LcQU6eW9SQZVa6RKxVtEoag4utHGdD1gySAm7z9CLgvBN",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "farZtjPK/cCeKhiYbyJFQmMR0F2aVLv+hHOyoHD5yQDMDzYaVU89hNaD8kvvugLsvPgaj7AjQ94cvrFGe8WdIgZniKSzMlY9kBzDIkKYLD4rGZ5AH25/YcsIma/qGW205EGb0BmCSBA3C+DiBn6O1EgXbrYG+FbIFsCEriHQniu8+ayp",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "BzXjYK7NwQEp0EJaq6keOLBRQjTG5R0JW+2zDhzj8aDhlXDNwhrjLLm/52RiSzTx5SLRG6IXC/KEUPNeG1DcXFIX4hszXdYdZ7gMQJ6TRmefkQDln9qeP9o76BGT6ZQVEoaRqPcLJe8ndRRVFIeKtr8Ebx9FrmWdS21vd7pU1j8bxLM+",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "fLQXVzoJp2kPk7i7kXVw1FUGgM2qoCR0aPoQq6J54zUmS2ebpDkVveQNWUG+YDJfRlle/EwOZvx1JUeoijgtKzKonJE8fmKuvc0Mb/tTzr+qlX722GyPQZrop5XeKY2LjtOm9i/2EaL777FsSdeGuYLi9cRZ6I1a5vev2d9mOPT1KPFZ",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "QLHLGgW2uvKyW5EwfLErD3rnSLRusZzCnE6Zz+m9b6q029FzY/9kpHnhbWNE9NSOqSV74KUXJL26lS718dnCPl6QaNbiLSoYPNzDpf+u35xtMmO0mUXvQXyL/I1eBiuXy5V4RnrVJKsGZ1PxnjHwaLf0JYxZ15FmCJDLGVeFcqZeRPct",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "FQWd4tPg3zTk8dsq83UFgNcBQuWEjSALDp7v/kWPZBhCCs+pRpxhFwc52V4MfrfZfAAf8biPCY7yRA4EeBhaTogoUobBGJkK1NNxSDmv0Oosf3quqNVPxDBA4uIYXY8G4+MIT/9Pyd4Ii648abZoMW6mH6QL1wHY+x3lb0f3+k3GcHjj",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "Prc9aRCeqTNWSu3KAP92yTlTf7TjbAc3ZBCJxvlLmmcELxl6OHdEBHK2NsFvOybW3QlONdoZOcwnMugFppIyFHr6fKQ1afUpJ+GfxC33LWtgohx2W/gp0LDUxoDNSkJOboMk334RyqDsJMMgq3cUf2vVCMgyzTCEIRSkIk1ImaxPDwYy",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "T3qAgzZwHv2ks37o/RYxEhEREjga4UI81j8uqGJrrwhs9xlO+ZTAfhojMLtYDt55nt3FcUNW50z5ZwGlkLoUFY36WG9bvQobFAKccpzIwrWpJZcC64/XejAdn4kyHXPJ0WcXXE4Pw2MyIW2BXOi2rPQmYaxWtz89PhsBt72a0VmmFEFn",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "B+koY5fGvU1OdFkzqygjBJizY1j6sP40BZ8A+N+rsx/T5EK9yluQCrmdo288E8bhqlkSe27ptPqYEThB0+fhuRhmAhbKSZZtZ4jedgG4ZWNP3r94/pJ9M9Vg3y5N26karpV0FYaaIurCWCUP4D0RULMsOXimOwVIruLPyV8WJs1wZUHV"
          ]
        ),
        "👋": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "I/Bj1wmy3I4KJfYpmArvWFf6pFJUsWXqkWKnx5GDGuLByG+raNmP/GP/YCAvYLqxyeZtRVg8uDe4+VR0taIGV/KVb2G8HbOFMBGS4888IAxWY8ovRFFpRTropAxS+ed+0K5+RG1h40cHVw7E31lfsiKIA/hExpTTnIsjMNnN3oa+u/YR",
            "algid:encrypt:RSA:PKCS1": "OgMMS3psCcBCvaitf6dnrglx7w2rQSWAlgRJhzGNWXMdAt/YqVQ6x7RuI8d6y/pumsrLCkhVL28s1hp8lbZfkIp6c8bbMjpy7gMM3d72b8GOTiJU+OJxerMa1jGmO9tOX726V4vsjEu/Cq0ydqbzGMKde5QNoBCQLQrRkluPjRNvdcyy"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "Ba1OBm4L+q1rTme3HQzWP80FxiKhZ9GKC73hfNhZ37vm1MZ40yULXI4jV1iRX4Oheh/tXvyFg0NJT6OXsSDQeV5vvbu52QCvEu1O6AxGx2THXkNRCzd9enOIsmqZrpI93+iXteyG0oUDdlO6zMG4lAYOE0YfGJheXFqy36+CSmPNFscj",
            "algid:sign:RSA:digest-PKCS1v15": "ZxzNTDc/mUPChfyT5/ZQDmwTMj7MAvAexQiWUhxwJFJ892EOCWQTdDsi7zIYCSvRaZUlrLEHsjPWUr+zJd4fsCFWwLKTDBJjL6b4AAeCsgf+pwgAinTpwUTwlo68XYON6WGlx0QrPUiK2USpvenIkK3m1khNwNoFAJOn/YVlsIXvdwgL",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "TtD+8Izo4ezCAvEh/yddOMD9mvUSWgSmHiCCdtu+tMAVeofrADVcQqNjDjGPJw/dED9qVDTZGBTyJ9K+IuDmG8JPDBzjWVBi+s6Z4d/7gfqQFw2Iuvsx4CVzFK4IropGWo+6WnWZaTeLSKmGxAt6tV4vQ2C+DnoqYt3W4PW1F+mE883m",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "T39ye0Qjf5vTraEoVXJn04lR2M3e2TfDBMiXSfXAaiYwKfWr1wShVwDGnqYTDgWQujagSlAnKJhb/GsPDUl/IZpSCG971yeh5qIDnsqSbQrSm+DaXimKQKKPBgbCgC7kxKUsR5zmabzu1c4pOkKT2OQvHjokz5Sxox6CXak5Z19Ih8Qx",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "BljerZ9FCn+0Bo57yvKsDHuVPd8sLGOdRN4R85l69FJ6if+V+uGQI6rWHpURs3wRRNY0hGkcU2snfog7obIcrh6SsGeT0JQNEjDZINDJ6/5rjFrIJGxMhsFYpqQdAF3GHx7RJFdrf9O8j5cJ6umVpFJ3AwQxEbWTGWTtfAgyHZpv5CH7",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "OQoLeMUtktY+LjVxgSGSoU70uM2kJCz4PaMRIdNquNk6KvuCz6x7tikuOzno3WF4UAz0mOnl4b/exdI3X2j1oZCwwfCcaHq/5tL6mCxaLXZ6zlyvdkADt+lHp8MF3xz/lp7ahbn5g3gkAD+Y7dLqZSRgvRaaN4lXMQR176BAXs/wp1JR",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "LnocrE7uaCx7n+zRivY2y4vzWnzUHlr01krZXM8ONfbJ5+ZJx3m+uCD8GmUzIRabKz+E+c28wurEicXKhKE8qETGRIpqIa9sTbtO+76QA4Nb3W4STJclNt4RKK7BvuNxtoQsrdCqCuZYLx6OYyuAB3orjw5vXHOyfCMui/UGiyehmfj1",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "LxqCh4V7k8iBBpluqHtBx5MqQhNYK4wsOpiMiaqLFASfK7US/oH7yEoJvTmLw+d25++4DQIYm2VP9DWsg2nOPl38TwNPXvCrK4eIw5wh+bqFgKastgLcwyETOWYD3p+dOe9XkFGQjONsVazm4FEhE3N0mvm8Ypfn8uZ7ZQm9tA6uH9++",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "d4LnV/nlcvnbjCkhxQCWksR+moMP1knLdurLTICDsUK8HamiYUcs35H/ygVBKZXQWcaHjb3q9suJ2xCPYH2++Z0uzvvH/YOnl5JW4v85cGopK5IfiLPo3jfYIUnMqJl14JCOhZz+LFptVFKJcsj+Q3mr/fV2h1L2SVCl0E01C4kh0Rsk",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "QTeXkVdRLYZxW1V0fQ3UW9iJdtjXEMkUPVhG3UH1+CPeOixnjDgVEZS4+kqoNkywlZqOgFS4QO4MsHwT8FsyCkG5tcUj3VTd4yOptJ59ti+Gy+G5s85kwmB8vgCOFABihe1pNswgIlYK0Sk6jVqeKzARWyid5btr50T4XWeKk8OF1rQy",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "D2flaFYfEgCkkue4uFe5E1LtS7OMdrfaA6C9rnVXjB1gp25GzP7PAEanN7wCmePlmcVA3bAW/+EjT2KRuxJVsRkHl3jiKX0Y4icJnwvbnDEVxcVbuLF17WI0mmP40+/hwOZDD1wqpNjHdBbO2Jb4QloEf3BknE3ICz9HG+ZqG2qNLLXc",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Eku3C+NT3K/6ED/uhHyux2fc0CaYkY2mKZj2g1tBpRZ9WT3IW6CW2g6/LLtlklKj7bXmZCrwL1JZWJxXWu9SZO60WBM8Ppr6SoXKOcBu8hYqLnxdHPvfaix+ivoj/NK2BjbARkihEBwFwXZCjGNiskeKLg8h5yj/aY5qTNKyUJ7LyIJM"
          ]
        ),
        "RSA Keys": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "DG4EcbiXQclDJ0FCX/nbFIDPV+QXO7HD/ESi0G467On/xqWDBbrz22S5YTvukygeA3j79x4Aj5x5r6PhF216wAW2S3MIA+kAFbzFX9ywSKko7EWmX9oSjhLx6lgTWqjqGK2/zKANsbFNEtc2iMe4Ma5v1f+6CHUfO+zSoWWusIAoEiRL",
            "algid:encrypt:RSA:PKCS1": "dE3WKAme2QuETyEgwK1R1aK5we5ztjMuYjaNY03Zj9I7FmUtVaaMuhIkkmHg1bQm87xWYuc2ovcmfYUWBj3ox2gIy8p/jOHu54TdGEMjQoqi9OCR/ORkKIjJRhu9fploB8/U+8Oslb6p3tukLviT7XQsn3+wy9nj1iTVoRBISxBAa4AC"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "E5bpDIZqS92FTfuX6f/EpFBg2n24nOH1MLAHhyXtlJokjIDRhZWMtsyQg6zwXaoJ/fwzWlhjrpCWRtd1ewjIvzujfHrt6IZxvu6wMWl9c705YKBoOGyOW5xfVDc0gFyhmwtFPZ57tGSEYFTQxMS3mhTSmkPC02IHHKUMaxmKsKQBk0va",
            "algid:sign:RSA:digest-PKCS1v15": "ot1lTy8Vnuy2WERztw0fjtq9VD5JS7lYKHi+MZ6155KWThsxuZIIUDgQL3bTQ8I5xxhGOHHDJ0qLOYuSEQxlsaiZBGmelCKG4HDH8qFvvedTbf28fHl7In4GIVEhRv+YhSysHrIfdtZEPnxxOIFNuTK0QxcT4TKd24ZMaoUK0UOqJxym",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "YayK3BLOkcjWyXufRj0m2Bzi1FXRATdqhcNF1gna5jwRbbSE1QY4MWq4MLeLin5aRtCZohfk7MzZt8T/sIxUTwGKJoe2yb87CTIZEM0DSG7qtPS7qe1DFucVEMPwIUhKgLoI14RfpPkgNTow2CjcW/dl/0/gQmeAadF6px1vwd/1w3J8",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "YkV14UcPKH540y+Mj7Vkp6MJnBzK1sCnTyA99vKH0RqaYgqpFXKisZmojoeXPOzfXkd89z4N7bW4JdwUk+rQdYm2RTpvnXoi7QR0JqqkN+vQ3TP9QlQLMCa2MwsuclcFie+zOVhDc2DX+TX80YdClwarwOdmMAF2e0QnMf3A5yQEcACt",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "CaSMBIMr3GcrGTmlcag3nP3aSUnW2qoNIJC8L4DQXdBZvAwKKflNnsqnoRjFDFMCV7G83bOG77MuZTLLVelsbqjweEi0VNJ0IBvleeohFxTU9NVHoKIwjPZks78mY3CWlYtrtBpEqN1UHPirkCciAdFlZvIPWvxwxGz0yD/IbLoANknd",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "Hp9/oI/m2ONhl68WYKNVCBJbfgzr3TFdZpjYOBMfWmHY0+qluQRdtxM+QVMFH+ujEp98yvgGC4/V12wfyGJZCLLymMKxhsbUF1cbFHjkEOzUSAey3rZeK85znQuUKOgpvCcnZ52MdynLX2OW9lffYHCO/Q9J1ob7U8KM8Ly8Tv4gJcZB",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "QEEGtSus2wpRBtY/A4Z8TtPcxchcAHlI7ekPV7y0t+JICBvFXEsbKD3C8sE0n5p8bVqcCiPmPmUB4J5m6Hw4fAtt4GPngU6YnRCiF4nehYIN2V+vAEDY8kp8SVIlkF0TbFmZNC5mTL1T6pmaWKoAmiuCJQCyGfitiNrYkHqcLOky4Rx1",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "gn53c4z/u6DWdMpT2ieR9Osk6NSfVkizCq5FvEUexH3CDol6mjAMotaU8im07PoLqU+CeI8Cd4PrD0JU5N2jTV8mBAIy/mpR+eE/vbsB56EGS6hBepMdUMgG3Xd/Zjd54rzw4+tEYKqT2YOxWHI5FLeTh4vXOMnBAs5YSKtv9mepZEV6",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "n7m4+xtV/i7+2Xy/s+Lrn+FaVM8b2kEYlrMQ0aOOYCMncBuE3LAF03+xygE+3FsvanLbUOSHgfDx2drRHPJUbJ9DXyi16QN5E7whcoq7gpkzYDn8MuwID3pTtpoNX+4DAAyWY+5RAay+Lyn7OZ2zO7xul/uKC/x1o9mRb2J4VkeBz616",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "WM0nFMDu5HsCuRwNu90O6Y8AAr+6DzE5sHfEimgoRuncnJudG2Up7XO2PF6KqU+x2ieKWSJFdX0zlDKSqloADHuqwrOfY6gb0JycGwJQygwDFher5P2vIU1vXZLLkLLtqStN0iQO/GuFFx21J6U2g63G82TU+JUozs9dHIxBs7clQwmp",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "AkBqQ4+6ljxcuYbeEcTI3PbpeghLHZYFxr/OGoiQJq74xyaDfsUsVQ0dQ24774zzI2VlHcIEBvx9qiFNknthArq31UblCevEZTqFzIAHBzLbwQQwvw6LdWOyCqHBDP5Ltua/H7q4A8BqKdF0bW6hN4DXrQdGPQDkwIaj1IpmaQJT0yju",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Gx+M8TOc6smAFLDpm3CjZ57hiH3eiEWlqyhIaYFSRWtsjvO0l5J+sa0Oy1A7zQM7yQsfoFZ25oGUJs/cx8oXUI54KiepX65Z6iQCy7pBZXgy8TWCrRZO/xY5l5Pj8ipRHyMkgTup5wWXpfxmwuQNMW9RUNVeyx1NIl/JgJdEpaE8KAaV"
          ]
        ),
        "CryptoSwift RSA Keys!": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "f7+Czhp0Y3kg6XPfjFjGoueJ2xorPtO7OPspMPTBmg2AsVriozvz14FHXkjxo+kRnM6ZKz+iN/d/JoSHERY3AWQ9Z3uVTSVx535PxZYOmKgCvzmXylEhpl4NK5fQKV+jaGNCI6Cl4T4W41HRZUETBAiTSWhwpTU/MOr5Xe1XSl0Mp0rE",
            "algid:encrypt:RSA:PKCS1": "Fl/Ex3uU/lr3v6iD345HW7wodz7v4msF1nu/LLDH0vNADhHfc+vd4dxT3s7U/qSNQEIuwBeFG12KEpKWhJWfEzXYPK5zRvSIhIbeaAlIpsJb8O9Qa/kEs2Rc5LO9MVMETCnj5yDDlmeGqinV0lVC7E/mycVTug1Jr0ELfb0Df6lhMfql"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "m3psMTDc6xYFEbBuE6J7AWqEYGQIy3FwDvb/JNcSSuUiPR9w39nJRdlWeAUrS1qvxnb/ilMY5zoHNdK2j4DPt54KCthByJkZ7Xy9QsQvSgoVXJL9JusH6UAYJRIVQIpaPwrJnWwCpR6ttzGaPW2hBIO/6Df70xDCPSRJB9I1XbWF1VbL",
            "algid:sign:RSA:digest-PKCS1v15": "VyWICNXgSpWspn3GoClUw7lKyuS41t42R3msGUHsguneCsy8BHqX8ELgyGee/C1LQvNEGPn4NhvDRbopX712NzdAww8Xo/6vm7uNo8NIcKBZbP7gMrxU5S3gF04c7AT5vtmVCPfjOzw7f+WUjTcInYVDWk3tHbA17gMlSyDNXx0U6Xdx",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "eUEnBMwJeSLWdoJwTfvDwmpJTtnAZ7w248cndGIrFyF8950ZF0JUZz6scm4qCqsF78DEiOFveGQTNKqiuPIXw4FOWI/LqZq2vPRLp8uG5dVeeaUI91+cYzGRBIdcTdDebSMOPbMoNguC65y9bkow0broG2B64S0kkrNp4XB42rOx1NFt",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "gmKXCAqltCqh4N1BXOLsGPTgZRc3oCdPOFnExGdaUcBwA2fIWtT2pNEIYswQyWwUgBjOz09PU9hSGkHaWHzDq3gdSUfA/99rxlfDnIEA5JUHQ4FwCXEXVNXVFdPIUtJ5ODmz4uaIM9IK4WCACXTp3nNB0B5u1Vk+b6uJnvCUy0XSAktG",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "CkQP2tyiSj2reiwv9dDFoBEgTnXrEcUDpgstbKz8y07WWc0jnnAtbA561vmCTcnN+loKisDuBzB8sj2sH8bQrUAr/Z4SGopEtxzilDKWqcg7wRT8O32tNkzctWvSZHcRTY4orkjpTNRG1We63fVWzGtQskbQFgqYjRc9pAWVhBfuUTrX",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "b2I38N81BQ84NCpus6qGgY6lF5WI6Z6nX92hKl1nA6Vx1zceivvOYLhT6WV9aAO0uXwRMqxXbheHBQhSgQemo9cWLtqQ4YhZwDK8Iz3tMhtWkyJPqQlci9HLQkOcQ7DlAVm7xe6+a8Eo3Ny9TDRMFk2/KPCrVpdT6Ca7LXc0tl5v3RI4",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "jwXobxBq6bzyzALQLkR8CZ2zZv47CD0MnbuBqji+JBh3w/B0GjovRhFA5O8L+yQxqO9GmeGSZMvetjsqmkrN4TJyj4+bLw3OmhCu9zf/A3Bayk3kr0GizhTiUxm0pMVuILpOCa8SKh0urbnR93F9F1wSQmDEMmdLEFTjje9GduBkAvgD",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "k3Nuv0ggnUtLf3dLY8lNkig6JI28g5Ya/t6pJDmCJHfdAcdkITfX6pQjJ0/nbTucWH5v8uAjpBSxdCx0tJYv/UPqfAhCbmImstOegPIsfZQGaeB/JAHRDQ0dxsoyF6oEvpYClvQJfGzhulRfrMz3xYmajzoP/ZLB+9M6tmM5I502btya",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "TyskblKb4z9x81suow250RIoPvX5ZMsDGo0T9mzsaBmUTMnCFfx0GkOiuMEsgkv2pDdWgWknJGAyefdF0ctIF4+WTHnQy9kd4T53sO9lXUFJprvMvvjPJid29xDb1a2U3RtmQawcF8pzCtOUm2FxaEcj/koDsV0qscgW35JdFvkzkTDm",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "MR2T4A/3GgWLJYHDh9wEPbu//ZqDhqNQVxTu3EzbxF+HO2wYctTLb19AZehe7KT/NCNH5lcM7jeCY1MCxyl2Cy77OJh9J7voayw5qh+ugBBJt2CCcqomfUHEqEosR6vdywqdRkn00Y24krCsUUQaQoc7VqGYSElJqwUOgTPXsDRHe0Pu",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "f+EkoL3OoZHjoVh3gMx2y3x5LH8D5dwD9YoYWXwUiOjDjGWM4LFYI+ZKOy+omQtEcngWQEWKv19XROQMu3S3/T0JBfM9jPvM2HsXIA5EGSa9aR1sn/E8I1s8ItKuPPNA0MxG0NtfCYTWxUM/jgy2fuwaA0lhE2IW0WpbLnanW0MQFL1l"
          ]
        ),
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "",
            "algid:sign:RSA:digest-PKCS1v15": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "ZU2t9DVxdH3xyeayRkYOvij+PaAn+xZMoL1PTM/yf0pBdJqkEvPzg1JaSwMQP0sgCS4zfGtOQg2vRdDsl48uYASUUn5e0k1mqfNi8OFEFCIAGBreInHwNS8GwX7WjdRvhBgdkf8/SQUoo3RitIlRUSi1tuX2dxSeV27e2dfy/UDqt3yZ",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "TdOQeZdywNUJSlQUyO3gt2CZhk7exdYxW8ibHKTxAckSYrYpGSDLnzsgmLpqmu1KQgz8bbtWjv0aPEmf7s1HkHnBcwmG9yIMZ/0JlKDVNj4L/T7fvflMHjjjmSx9hwibVME7+2pEpH2M5T6CTZHHAHviyGWjnnv9AuP7/yxpG+NjY1YK",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "hc9zFYIijd4MdYEEULX+6aZ58VxrVcCCFLK5IKoDQp6doD7kS8Bp2VwqTdG4hdFrRP+TgS2882RGMc3loZfy/LAsG6cpY3JgtzPF/aHqO9EKxPjSAwLyWhqD+0ZsZIpwYf/tIuNIEJHO5zVr3C/NSIPLcrMXYjtmBsYJWb+3MdthLP2u",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "nZcy0p9J5Vo58lRfvXMg/7lLRCyQZlyStkPehWqdX+rJMOY5OyLw/IPpmZ/KAiHFvKgqIZpQt7KVHeNxDmyB5yquPshyyvrwP9ter3HdFVXgK52rZqmQMpIPM1tWhnmX/EUt/6yXQYVGerGXF1txHrZUS29VPsv7G1S7TaP/7KDmTC9V",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "JhFgheCKfpA1xcubGHRqUtC6Mjc7PyzWtmfrcc8ud1AHPYiCpMnlrGvpY5p7pDKaWmlK8S7Rznl2r4QFtmEWt1de0vN62VH5Nwi3kSi6q3ufvjpGqKcH1p12o3dMM4qbS8bbnm2bIP5DmSOKAIP9Acd1ixlgomioCBsS0mm6U6sbZlCf"
          ]
        )
      ]
    )

    static let RSA_2048 = Fixture(
      keySize: 2048,
      publicDER: """
      MIIBCgKCAQEA3HI7SZJ1iiQ0b/6ow546Se0IuxJOyAqK854X/uspeiIVUzhDlC0cvUEQJjmo+ZfitKoH94eV0RulbbCjNUV0x/1OKonKJ8anHQ5tgwfXu89EO/zAry7odLHYTvgBoJXcM7sofzPdFuwUYXj/G1CKO3EVvF4sTvjFvfq3huDdrlrRGuGip9mWTvcH7VMFOPbIhLWWgwMyBp9AHTisQCA0YtRdnSRv70dAcy97ys/vy4Hcf2yV5HlryFt4ewR7YD57CSUofxsH2lZt+1uvQ4OfyjKvwN7HgrGUGL7xIVxddeAK8BeZzVAyp0sroRwNYlvGGRijYyJUut+xnB16lnSafwIDAQAB
      """,
      privateDER: """
      MIIEpAIBAAKCAQEA3HI7SZJ1iiQ0b/6ow546Se0IuxJOyAqK854X/uspeiIVUzhDlC0cvUEQJjmo+ZfitKoH94eV0RulbbCjNUV0x/1OKonKJ8anHQ5tgwfXu89EO/zAry7odLHYTvgBoJXcM7sofzPdFuwUYXj/G1CKO3EVvF4sTvjFvfq3huDdrlrRGuGip9mWTvcH7VMFOPbIhLWWgwMyBp9AHTisQCA0YtRdnSRv70dAcy97ys/vy4Hcf2yV5HlryFt4ewR7YD57CSUofxsH2lZt+1uvQ4OfyjKvwN7HgrGUGL7xIVxddeAK8BeZzVAyp0sroRwNYlvGGRijYyJUut+xnB16lnSafwIDAQABAoIBAQC2Jo1mlWYZ5yCNCddZC/0N6JY2PUJreIqoEhGxyY5UJKWKRgtQ/JWqq4A0laBR3Hau4XAD0DyytC1VHYc+FU4RkfRsob4wb6zWDX3frzNLNFAlYQu1tQTOp8UcO0Dc9/cjp5omwSwGLLwKbngckcgmpaJYK1hhSJ3cBLZw9I036rm+EvVvkwOh6eSZYgs/5H+sANNOw4YvnSGYBIvrvzcu1XmBkJW1kcSg9OYnih4G5Ac6/etDCg7w5umE9IYq9b0GU8Zhlip22tsCi18ACCC3Fb5Ki6gokyyjLzxSes28QwAVUWC6WurbsFTRF0Lw8HC0MH6r2XOwWXX/7iliCCNBAoGBAPfHlR36CqIsXHmp1FX1tMYLt0OprKN7pKmY+QfZoGK6dxv2sbZxcAuNg6Se4J+r+QThay1Q2BjsoxcFHj6UQNoC8ZuesMB+WM+1o4s/UUKUKclj736qjgTbr2La5lJWn+BXohhICDDN9DdV1JJFHWniga2HgZcBWr908uD4BB7jAoGBAOPCgPURAbrkGY9/B3Sr1HLeplvaGZsylD4lXkuPoc4JRgifer7okdXYDIySFXv9L0ts0NtHUrm2l3dgp3FBQB2ewubS5GDwe4xbszeD4R/Vc3zOuWq15YLNvWBastsr4P33kW0K6wW2kYjEPpMD43jldhTszB9KV/LTwTqT4Wy1AoGAYtsC2FHhGjC+uF+UcrMz62vTMzCnyxXSbUO133bpMVqZmNOEtXhurn1IT05/6dRv5o2U+CBwBwmqS83j8i2t7g0MnfzjIfmGr2AVnsGlRv3b6hhv/cZIIRIQ2EzjZWhgIt5zsmJSuj4BOG6K/8yJXqxa9oPApSGKNiaPnEf3ROcCgYAFdpDpT/MerIIAcyeWoNiDuNt8sIqUsm3j37mXTmavLoHDiy/CjImS+4+xf3+MbdJImN+ZouhVFBAmCOd7S/lhvIEoUD6yJJKSF1EBL+Sigtg2Ui8YZCyRKqY0PXi00SSgcuPGHdDtXie3hB2MITe/mqFudw+eYIYjiPjFku6BUQKBgQCnj/UumWRvGq23MKiGMun+xFhf0t/EA20CODgEGhYvRHESGNUAq1+hFaP9GTOCI1XwlVD4oWnXfhPxsiSujycTuY6K99xph+vq0JHwkoebdrZy/usqt3kxAX7EjhjCWP1Cj57t+HgDJH0PtwQ+SjYNW2l/1sMekTENZwon1PAgQQ==
      """,
      messages: [
        "": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",
            "algid:sign:RSA:digest-PKCS1v15": "t0M+coAeAwM1hzg98tozm3v4+EAXx0n8urSdltNcuD/T5+oO1g9MULmoGAajRcmHxtUBLtcfmzt7UcKlyPp0Tnd6lqaNT3CllbWAROXc9pD/AQgICxHEZJmQdD6rHsEWCsmveWnmX5Ztj8w7XB93eEfFqfkDSTv9cMvSdS9f4tHnqBsupv47YQe0rQkd46NJUKaJ4wWWW5ug+Hbp7u5bPrQp707SIBejOYYxMIynbEMGWDn/UdEqcLPgGeozWm2KJ+77KLljvfwEHZvopuyx6kHHxa+kZHzrUOxjdKRr+Y1YGyyZrzT/G2z/CgYva/qeQkLdwprZcsNC7jCKndDVVA==",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "YS5QXgKmNGmOlzeDI2C4TO/Tu5uPnE/5m5EidIUS/IRcwmwQ03rFHle61SFSGJC9unwwGpMGEl9lNpVyBZm+4HzIyJM3GtyY7D2GNlcXFCKRlU8VDxjf0+LaDkv7unTRHNVtiozSs7lZuLYYq18cpvI8lgqvKqmLVSpujSwIkRm9kxDrJoGCR536/uxlA0+rOvVwgvcFEPCxekuR/Jqtqg9fZsH/l3BHkzzOOrtG8mjpupUpg0X4Q0lHJD7+oKvO+ApoKD8oiOufkXhyQZrYvqXB18QBN0DesPHgGQoH3vmMtjSZTWOsBkjafNC/Zfei8XEvhvr+7lY2iWlO/fMC4w==",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "hzmuMNK65BJaApJIE3NepVyXOzK0U2kfjtytpzQiPnCKeXY0XM6MXb84qsfphRedNVLzvspDCN1nwkgiOJKHYtwshCA195c25XRgeNcg9WI1NS3i9ej/r4XviRa9d059XKAneZigzQp/Pb+Q29bM7zTeYh9dG367XeFlYvxh0Bf00xXnY5vuSolTLI1yQMqYvVhnnn1nUPzeGIHlzaZ8xYSGaF4OPxx3IN4oKmxqYrvFQbh9FNf43Y6CnnyK+WkflaVdbhX+Ge+JxaQbrZKu/DisqzSSRpZisPk+9FEbqzOoW1wjZw6IrIp9OquFlIK36oVKp4+bL1h6SCIuurqqGg==",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "x2/m9kmMiHIa47adCIchcXRVQEYiXlT8AZr0yZkadhKm1A8SWWya28MkfR1qSNFvPtTqJYzhKOjrEXX5aWLdjTN7KSra8IyMeF8CNihjVXpvHChan8U5PCouuv3bL3Ss0xe9f6mkeDlgZrCztNoK3OliQZslKcz5wkUxZU/h/PuETnW+8VFxPWv7zCudYnn3X5t+V357XmZXFjLqnFvnh284KC0uBVOFeEhOh7YkLdDAQcn0LIse30B6FLdBBPldhqbIYjCIucIzT7Mb6a2+x6EQPXxNOc96x2eqFXHXXtNCcNwknNd6gKgZ0gV9NoeEDoWZqUqwy0RpbNBxqKHn3g==",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "rj41lPJ95R0pdTRr+e9m9/lFdktP1QZJ6taUY44ridX7YcgEPZn6ftnJIHgl66XSjImwZGzgFVB/y8Ekt1A+fFbImQzkn1zLUl29J0cg1qM2STqxutCV3JMDxjWgXes/yGKg8o1ZpSMjEeQ/4J0VMpbGPKeFVQL1N+MFGKqDk/odhV6rCi295zThTxWRc70mF6jcGEf/m/y9yWcDFTA5TVqR5n/W3xJaZCTnken2M69wuY7LdjI9Y9TZRa0PrVpMgq2ppH89pwFg80CVqNQwBLW15Lo9b0MMlZrwJY1d6pfhSFlZALRwRCMRLL/vROZ5qNf1lxCuomK8uqbnGdyOJA==",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "Df98neyN24goN+prLICyWpfMAh6uIxDLmw84u3E/SE3zJAlg0WIK12ZdeLVJ7ca5mcQEINUKD+vgSRNyW+wf2hgONCOghshCv1LfSaUxmcHBWCca8HAK9isC7i7pJoe6yn/BzN1vJNXDpkCjgyeVck7fVK1uqxqxVl6wbp6UxUmcYnLFC9VgsmMVw66F4d3L3IS+rLW1iJEuVg+TPBaABdtGkAhWbVdoU+7q8uZK5E4W7HOC9Cg7y/0SBEA83jEnGsMctGd3X9XwfXSQzpkcm3x7hQErZ0gAGORYok/3JDDVzbmsOpDTlaRpanJl6j3YGTF9pnyNiee3vJp3A4L92g==",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "WOYji4b2Qk/TaBodcBNUfAC2ZHuB9ziP8cjsSHT0QlOVEIyQ/EHvzVEEViTcdoliVrgQE95nAdfN9e/9YFPBnVHN/UO/yD54IFSqc1rr/0xABjdATAng3sMLh3oiNQ4tfxVNOLHlXzVD3DlROZIru+V5D6eRlFFMrye+PYXMbYZNnaZ4mktcEJvpJgTI/mZl09FBLSP+yz3sZqxvVDEMZ8CAvIztzbc6pWozDNRtDfi0yWnuSPcnCF1eJHCr6DTDmsOXV+i9EUrsXABX8zs2qcCfBp/+3Q7WwLRWr5Ql90q6qp6h5dtUGJlFe8kPt/rxP7AUnI7vSRIDcqDnFNtm3w==",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "of41mKNY5Elnz/Vmhx0t8vPi64slKBYQAOMTVOXEDa315i3pTAcqj2EomfjQKA/xET3kUqHrXRSdpn5/8k+w5l3sLetNHHkw7E6DjYALCmrJS9RiFZjlMlYtIleeRZ9bevs5OAZikzn/VIr0wj94nPwbZB46nfLJIHgH71lR+SuzgM11HNLq2XqP3PkUZ+leWxpAxZBAD+UVEiMH07AxbzGEAiLdYvqScukU9FPELGfnaLEytoLS6ANsVPOdBZ8uLcH8z+eO92cFIJhm1Tw4ap0a14TReI2EKVPnQmAj3eKhWD6zMDfuntKMfgcC9YmL73vBUopv3SBXGpmjc32r7A==",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "F3OeO7Dz9jes3ny8+lFGHEVnPgVORtjtdi6/VEU+tENT8rRzvSLmobrYHwWTQoxfnN40vx8YSGcLesZ4evsmkCIoXKGK7pdKFdTsyBZ27wgzv6DTNaQ83arGmkawo8tY6NuV7FFuwg3T7r3pK3uZFVp6rMhU+IMBnaHauqFqkRMV/E40hF9dXkkUiyd+RORbOoQfUnm+Aj+fJhm3I1X0oiGhGmEbvbWNlSL+gFii3jen8IY4zMdWRH0b2yjPH76dYfQp5ziD+riGVmtMDCYaeItxzespyLMoy76O6W3ln/GIJS7F+Ur58/W2KGaYFBBiO29XQig0nNCpduv1cFWreA==",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "DhZLYXU9TlyzK3Z/9VeBXlOsAU/M1s3p3HFMYEq2d3ATDbruODfgfH5+pCcWOmtx/10t8oVCWvK99lzva01C44zp8GfizDnvLaeeGDYdIafHMWFgv5daHfyhhC6j9fUYjTGxINHR17FKr9FNKS69KQZa8U89HgSuChXTqeKXE5rhTdwLo4LvJzywQQzFxB+BnUAW5lYhh6RwFxQ5bwWkB0Tw4wb2x35yXuPRRNZ7ZEqg7a+FVY+3MLJlpYGsUncJo61O/OUiL4+DaK6N0pLrhE1vlITu6xQQacJzsnVfHKKbwmcsCW/tEkKrkDEQRB+evEkfySnj7tKvrRCp8138aA==",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Wwn8yGygpyV3vmdNVrO7DalkBKCjmrf4qvJqpBeSkpsfyEM8/WzSkPPBq3opw/owwqBCZ5eMoJ/jLDmtSFx3x/UuPFSma8ApNeVdYPokhmIFKkjJpKssT2xDsEIRykxx4cS+I26V8/S7ckMrh0wbzVgf84898i77qTVdRvabX4bbc0i+7Zo48dtexGTMDB+Q+RNrp1eWe/ftF28TXl8+smv8OkKpItUTX80XU9Jz9oPtpCbLyvg2nQlcSnumjtN0ViybAo27gjqYUngTUbvvt/K470mBQjMgCE2UPIPd8imJrvzfzi42hi4vkqnr8B75ju31zvds4xClioSw0pqUkQ=="
          ]
        ),
        "👋": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "mGwY+MlCOee7LwmbzBf8mN30wGoqOORpMngparguNXQ/ZTC2NEvE569YsXBurltZuewBtDUu92j64qJQL5RZj1jf8unc7bmZV/t9wi8Pp7WNivGUELCTbIl59FinzUX9RNnVDzrbeWUCV+el8Dgi5QVO2Imi0IuogFGsuaKOhqRFWjEGShlog/rO2lzW52qOJqD+MLlkah+SGwmeDAtZn9msPRPsDg6vUwdL0WXpBegdb1weJxYrDhQZds2jOWsNMoneeYLsJ91Mvej6g1fwGIuuFqyR+Abwko4FDJr2GkpazuL5i1cKzeDxk7XNl7d5rtV8wuvr9n9SikLJWIA/jw==",
            "algid:encrypt:RSA:PKCS1": "vdsfQjDQEgDDknqlU5H2a1QSjFVqwBcI7TiN6yEuQfqv9IWsPkh/7stCQupoSsDj2Z05i4DjeN+Wz5AqXHh00FT10P3QCckidxWQjTCQYEyPjVwQz2fZgNhMeKnDnXKSdYw0I9CRzIG6nPcg9SGWBdvDM6T76kHLhvxndKOBcEWOgaJgYRV2J53CSFHqz5WdCAOAybtHS134YtyFxa32EcUI51hjfLdKePO3Zc6Itb7bYIsrjrNpbbjUXgzQaGP5D1cFU1j+m3IONsBKUXyq5UEmajiwNlGYcPaHbanack5rMaXgTTLSrxj42F4ixKwxU6zVYl78id5qZSZtLJSJAw=="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "CaOHcMXljUkF0T6+xqNBOMrzTqq9+7WpWkN1QkhOzN9Pn5+2m2y8NYFsdBOjeuWz4TmI8z0n+yDnl7psbTbn4KpXb0tm0HJTW0gcJS3bv2Cqw6+SQ3RTV6JzRBFvQAsZbwnUa0iikwLYlMHWKMFBT3NTIiOouPQN1RNBKm5wqGNFkUTnR/ILFE3hUVW2UdsySSAqvs7SLkWRYEi+WzZsmKv5h4ml5hMEX42I3cqmzkf8bsMQ+qT2sKjmt1bC+F0qbIyjsujDXAWuPnXNIT1AnDT7x+xPQ9dChdynHRqtUan+l8JDgk60oOghQkv1H1hv771yplvJP9J54NaABUBJ7A==",
            "algid:sign:RSA:digest-PKCS1v15": "fyIf96DhRzHOC7r3JF7heecK5ajv20Atm4MhvT7Ga+ndRbtKLxOTVM5Uek28rfXvxJ8faFfiTTse0Bl+ewsy2WovjulJSzHftWACJiCC+40aUOYgtRNH58OUC4qn2m4UwtRHm2NEMKNdnGRvwzXa57WiSulwzy/QXn4qrVAHnAQl1xHCSEcDUi0fEY+pnGNJQczA7JuL2qN3k5a+66t2KWRKFvnApP7NLVjVL4oHwyRqsLGa7y6Kk087Q+GwrzHNvF0hz7bzhjxjXqpdnexkKeN9u1itMAmIH/RxDnagMgw25o66ZF2L29fJn6zn0a6ZVZEqryKaMlbZ2vMja/ka8Q==",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "c2cnpPTRoCJcTEV9BXt5n569Pv6EhA5hiXoRxyJfprriRlTb74nWERz42DawK0n5zAwxGH+UTKDFU74iCT90ZFb7Q/uNR76hPuX6rj0g/H7JltW+V0ITHztNl9V6qeQpT1Dv3BEG7fIscpDXwl/BuyGVvb/xqw3ggMGxWCOlu3kRpWxDP3GsyLbpriw1rWxOuB7+CNXghfN0c1ajiJms/DEr4x7zn1hXybvfBElDQp6D9C21paIF+i9gGIhdajvbz6r9uGOOpEJVf20kG9EAjgpRTUhHAvbNd8G59Di0CS8H6GZRDj7Yth7pS0Nqxeb7p5uu32nOkewlZg+eGJ6hjg==",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "B1BqaavjnFBJWwVYWoK36yB6w/k4+VYfG+yjgcyiK8t9fNZY/LJNkvtd1eAZFbUltunuoDafqq0lpava4aWtjwXogzFcQddFTZvZ3UR5+mX4EmTJrLeqnRQf2NH5p0eWqLLMCSxlMlpk4MIxdOY0R6RMW2sfjRaYSr4WVpJPQjw2QlBoNOePs4w0wrRodR65hyFxu7fjoRtXV+Ju+ZdcTZAEEBjT0CohP/unf8czdwbNywvT+bm6DSbjzLeQ0HRKlK3nSM38HplKeob7+jGi8l6oAopAgf7VYdN66tk7mfrgNTzy/dIlCbZFyJ8MnLY8WME4+JSdNInQsqPJaKS6nw==",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "m/QSRdR5dPinzrJodgs3+CitudyEu+dMO4ehlORc0+GovBA8vQMcfAy3hGmLcR6fJUh+TnaJjS3Mc5cCcPGPuL3Uam/k7ZkOogO5c8p+J0bj93A+3u+0rk+GjONGfkkR2kgKtFa3anJFMR+XPWHghhGHKqNHwL2X7JvW3hRDSCOhC9gALJ5s/LDkkojxt2lr5I51UL3JQLceKlTs/zey96SK8vGcCASUTzsWhXE5RbTkUqWF/+lnbuRpd96VrsTVsiUNBdYufnPSxQAhG8whZqgxGmOEBdY6ff/Ly3W5K18vF+NfAnLJuvmsLD6xFKTqptiaWpgFEX8KiT2j3b2hWQ==",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "T8BHMHkPeA3cyH1/97XReTybYgHYDXxQ443epTi4j6xDXP50R6aNMuqruTu86SaTSSftEtRUp+jvVNFG/b8YZ+wChZxRagoypgiL58MS/WWh0TuIL6guMeu6+U8JlZ7l4XJATrZ1PkIQ5ZmBfAxb7ZfFdS0j9Uz+rlkQXZhWr+0j1IMb8GYdilspf+s7NBdxtG3jppXNmxv6UldKTz/gHy9xLfUyLxLNUms/KxBot8ckLCDK4/iUuZROm3AhHhtl6nkd5V/oRVFT2R36eLvsI/hyuJMH+jRo7j3SxdVdUX3dY7aMaiTgScp/ZvdPnMg6jeVFei98uV140sielQ9aXw==",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "L9Vfilde/EPKT0TLqC1HUQdM314IWsNFDEFQsX87NQsNckkoyvc5pmdGwiN8bnEhcEKtv1dRLguZ1QKNt+DPB/gSjyUFrTttbCdkimc0cMHZ299IWpMQ48ouq615RLQU8clXdF8DdxP2RrLDRwR1cQikICVYyWhvVPQWjegemUyyDGDru0arNwOv8SOVgTs9JDKSnyCistbMV2UAUOBiTcL7438XRAnxGnOxsWLzqAdhM7LiGARvYZph3gCF1Esf0DxSuAbZRvcPClAsWqUyoGq3b8eIgGrgXoRHpc5GL3qFtRTK3Qyp/rvGNS4x463J6rqHwiEcy5YUE2ZbG5bkBw==",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "fI1C2MQN/NXyAkBUpqkv7LdNAnbOp4npAmQXwSxk41yKNwCHTS/kIWGcOp5YQO4oW+J8pKpVULa1N/z5Qyu6cu7rJA80Bl1hrXKwSrKPGJUUPlpsqQjtKpMEIDrjJiEUuicVDxWXIeCSH+M1RJFnq34xe4qKde2CzJQXMHORUb8WPxboqLjRGXkVm7biZWiay8eDT5ye96FOBWwZ/OgvJ0TP5IrhUhvufZ1bHZbpIRYJucGBbBN2jCyvZa76StqnEYxYdde0DgJQp+S39xD54OJoooV5f6KzBq7MFdRaf6ITBi4DW9Dzo6ArannaESM28zLHkMbAS0LMjpunvKEdug==",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "qEkbcbuxvqAfofKwNZ5V3mxFQvkX5kSAezgMERDilvkY8+dX2NK3v1hzGEdKsSyUpGgtTcLLhXSeWpMHeXZpJp3gUpuLFoeO55eaQZM+08WOf7274wMRI8HfXezutt1MCE68FV4lXHXgnybvYP3D3Uo9RtKvtbI/IxmxNqqptMlWNLZpgyz81MRRKyqlNpjPBCAYfnC3VNa3bw4/tfmxToYBBD7u60QCRKCSivf+CJLtuW4w6l/NnoWIzxK7Uq5yHpr+AbZ6aMMMqoqFvgXm74GtiASgcIesv5VlliHFLsUEehvwxwAfiw7am6WMjV/fYEuptK9xigVD2YZiMCv2Cg==",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "fhvyoCHHpxdI1sqryomWcGh5li2RChQYrFo1aIprtCIKunX0okvEhx5UajK1zqmMW91sT+5lvES18cpIyCuLsnnqbwF9Mke1eW3Lg/stCMSYMCsXoZETyXzpVhQsEMCj3KXXGrnQ9ZfWp257V1BiBlQBfJjVUoehx4NdMhvt2SRFQZ4+WH7ZY1isZTiCjTiSgVnEx8vHXIJp2bTqargmOXPPsCaGOXqTjbrKJt244C6SOPp2pwQ96WBToRPEujWiGmXBweyBku/RPcoSWeu4Gpn0tHcEbtd23FRhF9nNIAKlKd49Yr59FGohWnNqyKXLvYFNu4O/cwc+SXXQMcrimA==",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "H0xtEUUQBdCIHpdZ25Iu6V/zuecYvpHxYQ02PC4PFI3cgW7t4TGaD40yWy2I4KQS2b8sLBsIYe65tpp4saUiwPtQxyKcqg7YhYYWOmdn9+OF1W98BID0B/4MhWZMeYDH1Xq1PR4eEPLJZe8qZYPkZyPIIpQkLoTxwoC8zfwceosStdqxZ/QjNTu7hJLnFXKCtkc4vtmVXCFY/OTaG5ZFk7Y/zk6CfvXcGky5/SnXqNOjvD39EHmYbWAX8bHxucntqpY1ZPAr+NReFUJUvF9UA78h29oc3uXYsGoSotJ3z5rQoXzHsKeDM8KLY531l7cXePFuC6Fg0oFG91isXHn3hA==",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "ddTr+cPSiJV0nMcjP3VlhXyUMIA4tgW9LHhYEZzvDFBVINKrL/eL9ht3UmfgcHg/HMEilJOlRsHpCF7VIHwOejvb7ekSnySWuTX+5KiRgY9z1NmibYwEF/alJLyIHzPoOSDHMcsBUadTh/9CTY8rQXmxsKaENFdd8XfBNWw0sSLackcgH1+pgg+2fx3xTbYwuFrcfJzIkKQpCDV9CMaNsh7BngHJ1qVADZESrxRqwuJ56L+aMMTag9SdPGjdHambJX/yZbjEtE5JcDGu21IUvrcF/0hnmnzRsmwiO/PK3m8Ek1surYr8Ohzssh50FLtASOEz6gXQQpMYO6z3He/dAA=="
          ]
        ),
        "RSA Keys": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "bbxatm6qJob0II7nkk9XxOJjtJ46vNx+sraHGOo6i0oUbi5+iZT1kyVRnm/RLir654RVkTFT04194uSN0iDnbfPJDhrwh9m1uHaH0XMAxWStRhCMYJSIuk5YGSupjuNvzcbngTK5O8uEWWiVNJi/UmYUEtIn73FN9h8NbvJkjN90o+Qyb4Dnp8cutZDNoz3NvVufvt28Y+w7FR+i186lZ6S2efzoeHK/h7DHPrs2IQg1UxUP9CM53IeUvG23CXZdC8M2N8gNIcwRk9b5RNY4QK/AX+qr1lc1D+VfhiTYiICzedKfoyNZFmYkiJZiFQ6hK/QsmNkUAzgr6Qe0T4oI8w==",
            "algid:encrypt:RSA:PKCS1": "RNk3JqS/irwF7LuAO4xNqAzPxzAksnzNsT5QioIGrMzThAhcvhArjHgJZMC4bBVrL66y1fYnNhogRNgvOWc5CUz+kfTQz7EbzgnEAgeDRSrB+MEHes2CTdGYoHNXLv4bSpY7y/bMZVX2ouhIvESYASdyJb+BaWRs5heOum1E5Je5hz34P7PlKiiLzoGRP0b3du7dbk3xWjId+g4kG5TRIa23tuirovz5nITWiAzNTef8TwcJuwYF6QRUn4Tyhx308VvqV3kKHTEU237TL7NUTY2shlv5F/hnA9u1KfvkTc9vfp7HZjTF/ufxNOZ/PTF8DO9OTbjGMNkGnag8bldPGA=="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "IwhvsO1TLzCORZi0n5Kebw2AOZybVYZHOC1wO8YiL2dYBHOcBIBTnmaeaHMn29cyfPB2POsoR7NYSZnpFK7Z4ikojQKOJANr/RoOPjJMHbF1QvuS0vzSbR11wC/qKAqqolfKzvVsML1Gacy++loAPiDN9ZknHDbTywU+1yeDM/8SwZlkO+kfwKgxjZEsffkbx2FMn95SJVNVqxGZKgXJexu4il8qvNzSyp94hkXzMyCSLS+DOxrLu1cwxesow/+clpw5kaBfmPFRr2dMN+ZJgHaK2ShaE30YpGVojWqUHKx5I9xogX9t9/ybEICziP3iA/tKybPA5AOnxbuGPvUZjw==",
            "algid:sign:RSA:digest-PKCS1v15": "IqXz73PgySx0TcBvqT7fnc1Db/v+mAza7pKXEaqb8GVvZXc+X1B7iQ0o9WJ1KQ4m/zq8iAmDsy9B64eOV48mytrEbvV+Z/8M14oGd/GbbjIsWxGF2ksS0deC1j6uBFdFiuYptBSecMOmh8VBDFEvkMSvHvUVbssn29T+wZIkx1XR3wMGYnyZ8kBqShFPGWoSP/BElv7ZKIWqBox5qVMFQJ5WdKTAtp8296gg0CSwmRVayFJQk6hYSd6yj9ON2X3QGgaIYXTgMrkl3A5jTTtydBawWKZkdgWcGX468Kc+XOJG2lNN41Vv80ylXtbYr4wHxx0q5MDp9EB2TfLmGxcbtQ==",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "J/1XWvnJjeKEojtDBX0nwFJNVh0ONp2GNta9HaaNBmzOxLDg1B6Ejz94NBwKQDWsZobRDU9YRJa7uv0QTucWvRW+30dKRk8B3FFLzofW8wjJ6aYPN4WH8pCHcVpFEgLXj+i0Ic+3ZwLXmxRdFUkR5xm6yw5H97HgRH42fu+Nx49z28ax7x6RTwpN8nTUxpJd0b1uQsxmMUcYut9l2+B5xuOqy68HdyRRed7O9BK3tKaXOiJ41tYN2VQPmpBrg8mgPEK3jXTw0PRZDXknt7tOR+RetkLoTw/vyJg68hO/BI/R2W8IkdiYJcSvJuflKIpixthAQSxXtC1bPwfzsnoHzw==",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "l2twE1EC+epUT1n2Q5Vh9BN7OicgBhJIojm5mN++L7RM9ffpj+y64s36WF36ga2LwDhr9cI36BKyaSAVffuEhOyQP41pmJD5/Kzkabgnn0mbHY3hxCbGbGVNt756rZVEn5cKE5flduJN6F7NemTa2QLitxZjpcbnK040LF6rETddCeLEy/VyLkhHsPMPrwNV7kMObtyMZZSy0iuSXvJa1EyfPS8MWAtPaHA7jMKCcrBYNgNyu83S/EcjZMI32CkIXR/9RleREF+sjs3Dqw4f5CdlKE6uOsABnxs4c4f1Fw0FyvWUUXABth19hjvSBK90dL1rPGJemTReqDy838SQ/A==",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "jvwFWBg7TITy16V2c42CWW87vPhatuCCskeYmkrMimB7pg+QX279cNYaHdjiFepdiOc965KrzzyJtWjq9yQByPkPA/ht28Wu3DVtGOyKFAMb3e9/nyCSbyyOdmww8Jl4fSBm1PxsRZCnXFXPSgEOZxQsIgmvNPq940mnnQx9Gmm/MPNlX1esgz8l0blfsKv6iqCRypTUcalFshfaoyyuy5BXzvtShJq/aTiT/UrmHFpCs7B58SfI8M2X2WInz2OW4Dwu/0solFb0UBRxeZzJFkGn80fejrDGjM8uSFYs83s7q4qDkfsG6mguoRH/QmVkk5EqUy7atiO9cbc8ua0g+g==",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "q/nfxJuf9aT6+fidZfw73k4h0h3Uy0aE1nnhKTQx8eFKbM4pAek38Xb96vCXWKroBbNkjETL1Wnhoe6pN+mnZIVzrL78V7jvztvt/kUJR2wpDjbtlJ6DqseesI8NtxQrKV8KHL3jze24wts9pgtXJZXuP701hQDybCwErEhg3FTBFlGHRc6ZPHQTAs58uc7AvX3x5+FVTpktZm3e0EcTC2o0zhbYymrn8qqU9+IdQEW/MWMDGvG/Nws/AtqTkCJroZ1tuNN8ZHq1hvZLkJfzyK0M6B4BCJvclBAmlthir2H0zb1mvzMJURBZwXvigiQlPmtiYJ+eZ2LU8dC79EFyyQ==",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "kWyisxyJcUa9GpXukWKWv7HY3oGbkOt5NrfiiaSVJAIK5qYVF1IWnTsd375mCOqmuUL2jyrYJRLatKzMPhdrmNdoWvOcyt4Dcr5rMtHviREAAfCc+saR7eRmW7YNl0q3LTZapnqrJ+TdM/dKN5G9YK5t8jtb+rvB5iQkHPxrUd1mjbqUoYZggMSHJ+Hw04cSsd1Eohy9ZLclyVqc885aLpkftN6pqX/pNtMTpBexE5TTtyyr44C9rwxpc8ldRNVSYHoKd/BWqouVPO54MMZNiA7yNnXC+Koyu+8AatWzbl1R5vlCWiC7FJYW6T80DFFLproAsWh7dNw2buBH5qozVA==",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "QxbPM8B4mgNeO3lCTvPZ27WQwf0oIY0qjmj8l8CAK9g5VkMqjKWuW18sEgwIcaBfQOsZTJhF88sDJ2bM0DKRsmyQzbN2ogct9ADiIUYTp0osazb1uufsy7pQC+Nm2Ui/uGvb8lyYKQ2Nsd9TfBRx8hKlO9uTvcaN9jAk5ZF1etUzfN4p3DbQletPXJVKQgWOWkXD8U4F9BTHVK7IFqZ2bLkeCGppJfG+I8iYqz9D0r4SoojXsd3QvNBu8DeWR/6rrCyic53ct1K+fnrRb4oQZvREG/76oaqRALAyOKxDBQLvzuGyoSVxWfcBRMTub+dNVnvGFPADj7WF5LAgWqtGLg==",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "23yJJ0u0uFGL7uj4NrQundvvktuFgbmi9A8s8dFmSeZB9hzp6FSQYd/CKFYWYX477UCM9IJx02knhQbkYyGmQf/Ei/QIPkdLxrKmfobpgzUez0HFrVEUe3I4jLuffdg2vAqk14WATfTbJXIX/3QTUDgVDnsCfFZEWAE2OG4GMFocTr56GesBSZp6V2WwQ2tWbsrGiv49ADKAb0vCWvTGBZiiG3j34d3tHKubkICJ3bcOWWerwXrwO+8PRSe34lDc4CbUngq0JeIDlb3fVEUuvUe1Lq51G/bj9YS+nIwFzaE1YJUxF8iCmVeFPo8pgMIOCqfYkQ8tWVC5t4R4jCdz1Q==",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "FmBav3noN6KHfADGmCo+PRNXKzLkRGTmH8iLwEAXxGLqhX31fbN1Hnl2+TgjJLaTWmDmHY16jrpPwtZHETva71cXmDGKKfsMXEtSyz5XS+DSZKHQsokS1/JNyOzIPdJvFORHoWzyc128MODvjBMWU23nTLmgw3cogYAm5/hc+527yg4Ydftr77zSXoXBbO3r1oyTv3qL7FwOui+RpfH+sQ6Y9aGM1EUWqIXkKTfu1SfrAXIiu1J6vdoTLy8XTQrPcIQFa15/KMCUEte9Jh7XHzdWwNncqWqiqHoSt375hrDopMej94/rbqrOtHXo0D+sbyJCpSDPRckMkGDFGkQ5QQ==",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "2hWqGdpkFGynqvRJqRu5LPUjb2/X0ZRIcfz7nww5n9N8hbqhXs1SVbz3DNaPKYVHJCGsKs+TNvgHIBWPbveTuR1w4mxHTpx3DUufngLZuwNBfm6gizjwC9QxzHin3n5lLJ1TCEZWJIv+vb+c/lcqXStjUHHWr6WQPtJ9z+3i+O2biW/Y6kNt4TeVXZ8X61RVSb4F3BurYVt9KCuULcMVOsOVbHgukUrBszm6TeUm0DmhEBr7kaZZeSTOSqFmdUhupB+J5zqIxBGlQGaCxXRMUr8YVktewiwmf4QU9oOU8/aok5hq0RsdNtqXcBOXHUtmOcBdzN4fZhuWN0K7uubcIg==",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "kJ+yZMsLHDOlNCxQVd3iFgkzX5CewVhhSUpBziZW8CmYEncLaDF1bWpOPGt3ItMtsgHD+rpODAMnmtm3ESFYjJPOho77nLavNPDTmpDZwpVe+guO0GAErAjz8NnNcExLTcSM2kLFBx0eY8N5iLqBosUvJP5R/3vClWN7swE9b/tNyvMIEz0BMOUrA6y1YfHZdqrehs3O0P3jnOlO+Cah2QDx3DkVVjXxy7pZSHzkVJ0X270q9fGcXGfYO4wLRe4asZ7R5d+hMBCLPewjEi0lZdhyYk++jFBXRpKkxTXLKWEl+j3mwKYP0RO20CIG7M+jYqaijMwsGkpQhoX7Bigk4A=="
          ]
        ),
        "CryptoSwift RSA Keys!": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AP0oc4v21hwhV2XRWA3bNYMZiADeggp/eOaLgeHnMq5iskk2V+VqT3tiA+ezRlH8Tu1IivAxD3xC8nPmqzK8knWa3MeDu9u6VgxxKgl6vzkqrKQ97Rly1+qcNSdMkwLFylS1sa3uhHLq38MrvSdk/eA1ieI32eOzvKcRxGjgKPx5FMgtKZ9pmDVlAjRSxk8JSfzX+HcdhjoDClzaq+pzUaSRnrMMuGncrEsZFn1A1ZbjYLXXKDPpyz94kQsmlpltq+FcB5Pqru2oNhGdrdKHuM921cW7oPJBwGtuOeqWx3JBmZ35NTJiWdWd0BEUAHnuxPZT7+eG5cg0NkugRImxbg==",
            "algid:encrypt:RSA:PKCS1": "LSPSLZbiMdve6f5y8JNoKCt+oXwmZBUN6hniDS6XwIDnVJ5uHxtFKuCOzJsnpuXmR02HesVWmOT2i9AT7DTgGX2FWcE9J6Li+Uf08YFjgUDVJ6DkvfZvD/Nm+AVULmu3DxjlNP+tjBOrKukGJP+NzLourAjfEls+H4hLVyaKCPCvsqZ14K+RCGHj60YE5Hx4vWXIpI2d0x7FR6C56RFaQp1xD4LCxGy/aRSBE02xEQVd5AmyJ77xmT9p+F12x9SNOf5VHdYNRT+8O59SMDV+zqWJJq5p/fjZKBsQKoEAoh1tJq9XlNqO/+EJNAF0okqHozXiaICI82E/lu8OOS7sgg=="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "w+O0E1zVIWerFfUawKJYak7WEkN6yhFa1uhplc+fLhjemZSIyzzd2mYoAhOl0qUHCCn3j0caqr0mny4wvkeXOSsJ3jH1XyANaiW/OAwmWGhSqUtldnW1PbR2sVnomkTR7LoVC2t126/P6bL8CcWj7knq1SJKjeQX02opRNQpYcWhYQT3/JfxMP7+Q7U33NA6MFGoZHkHNrt84/1jWtJV5gjA2Tbc8sM6Jgc2NjZiX16G9U2g9Idz+D10iWyrC1VHVjmzOEHeUGsBc706AGkrfo4B3GrdW//03YBzRYSZAzjFs0Wm0szKGmvWPItthZBDnjC92DYlatAZRprCNnkZuw==",
            "algid:sign:RSA:digest-PKCS1v15": "o/pbYAxH/4KEhBA1AtIGhm6/momDLNqQ+2PLTEP+9hx0VbS4lKpinEpoEdSM0RmAAN8IeycbsQjx1O2pSmDwyTY5PEBXJ65Q4rAYuI8Chn2RNu+2HRnBZbP8l4DAFKle3vka4wJ0zmLCk1MAuDgleKSL/mcFIHR6GNweOjGzq5rhf9pKDeBeoI6uljg/9N15Sl49gto/q5Hx0FtmuR9MlIfhdLW9nC9qR+8NXapgXrbPFLFttr1Lts3feynssnVAHNGsGFegt9/1BYhVgt1e9KBBpktibYBLbU82YkCMbgtSEK4WAkHmJWM9MHzHbzgpX7VafBRSF3CI7Q3Pbw9gjA==",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "PTiz3mSJmMWmlUfvcrCITrEfZPcDWip50wLLNs+ju6w54/m+dONfjz4Bd3P1RpmixwXi1n67xKFjXCkcxcMbph62ywAFLrPG+p6kBVrEHKj6Aqmcv2uao5QquETYW5YJUTGAf0T3v5bjGvRW/sn+BqHpEYdYzS6M36awApgsOXyVkz7GL+8EEaP65b87YCZSOWDSTqpUcg77fOogBIWmZsdw0V2v5Dg/MazfKiqD+l1Zvic8z00BjxLi4O9SN4OJ1ObnMvRA1iKtaP4HHvyErRYhIC6iS/SjJErnCTdMpnPHbQRJVJriZ8CKtJTsMBcuwOKlQ2N6UGqj+MwSydzoaw==",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "Kk+o0qh5GU7pOjL0NxaCxfqIlSQBhr7OjVzjLEbIOWz3Ue4yMzu4fO6Rp7V3CRIy5Xm6VSZHjdt0P443Cvmeuo28djXWPSimXMOZ2AFo4K/G9mM2T+8wXM+NYiRLSpgns8IPSoLmDUTDoCFm1JE6drLVgBwF0YdkQkGY6XPExeylIzrglQ0890fX8oULms2cD64D8nFijfIk9+L7UJwF3JUQ5jZ27rHOdoTLZymtwY2xxwURBZ+9SLO4gu0EGrZMoSLm0nc+9XSmMd63LekYj4zalUTrFZq6wIMPHMGdIG4fFLrznZijGbynsJwReYciX740u3vlhnx3nE6XjNulVg==",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "Y1ICzwp8xr6JVIFvmmbeBIucD19tzDwuj6QaYfxo3AVQY6zIpAHT3WUcL1fQRrfYhxHzXqcmi6J/d2J5LCisL6Hd2q5HkXTO6+N6yrjOuSwvwgNta1X7jvCaYC1qvRqdfO/0xAYVTzwUXHYvNFp5Bvvob/nwsL9EPrxG66hFfXURXwg4N7IPF0Oa+bDG0/+Jl221xsyrkkamByWOwNgWd4rbcrWUpTy0HxwzA78iPivAmb1Pa+xIsqt2ARETluDzsNLvqdEk2u5gdQamQKb2nG/BSQdHcjQx8U8dk/we6xelaOfLFVdWlWSExo+aWtDKgFyactUiRqSwN51ua5m8tw==",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "dHP6KJOoT7Ig7i9WVhpS4BhL1fzC8dCVY58dVAPqwBQVEu9d8dbTz0LBvewdD/xux3xY01tvKErEO43S9ZCWUCWWnYL7vOo6/PShBl8J6zu8yK2ngSMRERmY/feIpT/1V9g8vx/ATh/CYYwtE9pYyZR9N7OpJ592Zf3CrnGduSPO+fEtWY0KCJBOYUIb5jct8ZQ4YTqebk1aYX2DS3BFvpcY6K6gM2/VfAbAKFlDRU+oXbqFOZsSUy3SUdf6kdosEfX48D03fBPGrzh2ljj068hgMX3qg3MS1XvhD5tzs4FoxT0Xzvr8WzXrNoSdtGS/4LHlSoXserjimBWoW4HF2g==",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "sB77+E7wJZGvc2/cLrGP2v7c1b+RSe/TCpyiYEfskg284ysKPwxPHGUl3Dr4zjrgk5kRN9byJ/4+zMinXW3a+Ri1GKyGaa24gp6RRdHSHbK0dar/jdhKl7BEK0i/IeBKppD8CLaVXhmC3rnf1xq7SO3hYcPGtpAJr8RRufzvbM8QCaNxRGyzDQofGs9MKmL33iA72ldGSund0DS6Ds73iGgTPJDL6IkiHTN3awshIMa4pw2ZVLgElGZs3nlXF3R7ok+y2N7e4XsACLedES2Hhc6AlxFMfLJqRz0r/4rt12IRFXg11sq7NZt03G9866r8AqaByR90u8ve+F4s9JB8BQ==",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "J9yYPlaymi8DwpKp/4GOW+8k7BwS/+FqL3aUB5TwMCrWwCTw6KdSM/Iw0murykqWw3QW+ZsYeE65pmX2fw7EjZVDveZZrMAODMn+qas/mqkk2dXfzAmX8WYHZuGNa3nP+Zljd+FatrQbHI1C9pAJHW/lRsmhGS3KgPRFRdeJXbHQomJNJHKpyZCkFuY2MS4uCzUaGyIF481SV6W0msg0O22mos/cZ7RYD+Dra131yWOucvbOY0INHHj6iRvUn9H7i1jGMXxSACl/MKi34aLgSWKBWzj8A5jbZAtXD19BAURxIXT7X5sAiQYmOlx6Vy4Lxg/8gf8Pc2w4wl071CTCug==",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "HJqncQ3D3IsfN1GhntgDmGIx58VOD5sY+kF/FT21NDmzZ2sZ1Rji+LTIIRVI3n6pOVVTO7tw+p5hZOKwvL5nzU3qIL20zqD8VnBcMGJrEI71t0QAEgF/fWu0K6clX52AoQ9vS9dw0oKVQeS4MIlbxy85cw2yAxTLBseAzcNWhXmnQcWAU8lhPv+nAcvKkAjkiZfrn3oHMaBMMBn6A2g/HzGlYfOv6L8wtmLR3h4hLy3gxxyR/GOyn6QCKzIf6aygi6/WEz6V4LHDJelsHLZlQeT49xzasebh6hSIF9+2/WiaR7SBMGJqIhqtHLmCuYIyO6vPnh3D8BYmFstHA7/TWw==",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "RumM6BMqNnf2523vugTgajXZvaqvVTMfCAWWj2PxjytjHxihBb6D2hOcEKKEDDhlRr2g5mfrXFWe1GjANnad2Y814vDlUhFHFcXRezPWwIo8XSPSmmq9VfvcWQ3V3RCxmoFUI+twQJY36X68TgTMcvge0SRKQKfhHMTXDRwuyyWFLxmSuzjwAp8HcKPDUqZN3sChPc5DVDaC4+5TL0lBg/dPXHjS150An2hsUQgpdhd1LC+WMcjFnOsAwPZr9vGW9043RhaSkJwahyckhWUANIwfD2PRVAp7KjiQ9x6JQXZ708nCwRuaVx6uuJbdENOLIEtibtBYWtX+e8znH1Q4Gw==",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "sOG110ohuLu+UnUTXoEtzAWAgoZBZPzaGX2Ercp+niA8QP7jf7Z/Aus6lVrvvwQTsXPiFbw+CSdyEUc7s2miWcNuMjN+kDSEKPSLVJHv+E1XoIZycVAS80Uiswj7t2id4gzwXvvW6jiJqbN7B+pRXsnUjndqnwzoDcmB9Hte8fIdwvQKNpCbfXXXRuDWMme8x+aqv6QYdnTV3LU6+cgk8ks/M7vtzNVzaT6swK8ppcxcskaHEJmN5MoSM4nE7ay/g7QJ3v3A4hSWPnqQ92bcTbySR4khizidoCLYiLXt5oVOOn19fZz4TD9WeWOQ7HKUSWCZtb9AN0KsLsxFFh7nuQ=="
          ]
        ),
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "hGRauMzAod3Nd0EEtNZZ+xRo3PQI31KaK8xhDSu40NWaHp0DexelsuNmT7jQKL4ZycAKNcsdTPptxl5ej07YE5/kcBybwF64XNU2Q1mDYPPHjoEX/9Z6vihEtH82oInwg/j/7nnkW3P/CNPhV8d/LYyN2maGR/7Vjj5O859DLK20dlM1IzJ9yJXyP/5/00ziBl9MSkW56uslOhNRlLojkYtb1obt1VRhyM0U3G94shQo0kqMrz/8g7O9Tr1edpY/Hx1RLO96I5V8L2cbdHyw49vwCGqaXemb2xvdZspJGwUmAUhGboCMnWiNNytUB/HchWesdNurMw+55mvWGXa/tQ==",
            "algid:encrypt:RSA:PKCS1": "X+pNC+F/PtjzHu1coJlKSs3TGf4N4bZEpj5MT2jZxqGg8pngbFMAlQ5T5+TR29foIhx1yNX1F7rzJrLrUNYlti7MJbkQA+Qskcgn8UfkA6WXmXX5WrKAn3VeKvqYquuP4NH14Nffz6tHV7edwGLBaxbNDNFZdi81BudMyRzcp+NI4ZLJ3XJuPVWvZxiCCcBi2sW7sxlPjJuvLRmXilxJRV5DU/2t7/lmQcZQBd3FWWuBnPfknJcMdyvI0hS9TAmRYd0vjef5VJ470+1odOAhjFl77YgFiWQagL7TEmxVFKdvTFK90raXgRwUlGdUVFD3YxlpFIWeaXAtx1lLRd4srw=="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "JpndIhMqiJCi4V9KoWii4Sl7HRLU6XrVyPQO68YmFLXGsRkXg9eR5tAhjZUiAK3spWzqVvoQInK0aGQ2Qgkv9OG1H4buprg0XwHNEdA5MDwiLMJ1131ZG2WtNu/HTA5H5SPCfhhBOh5gBDKZ8Gup+80LrMKnZkyLg5HAHr1SY5aoNhFJDvT3rXDnbRX3Db1WkW05WeCBjKdstqfEnUGpJu1PneyfGapml1jS9QO4wqiO1TGradEbK7WpajToCROfSYd+zH4P/CtkjY6GL3DjeYHd8fPv9q7TAL2TteHaVpARkoyyYHqn5ZNqpOZVI9Bm84lp18V+81qfAAbOyZYITA==",
            "algid:sign:RSA:digest-PKCS1v15": "K5oEqdjid3PDag4Be5aIMZRPn5SPCtdVz014aNaNP6vm+BoKzy4HkhJ62uB2jj08Rc3g3dGQOCciZs8CpWcFRY2IsAtKbNYE6lMm9usAndPTzcxO56T7Mok/uNVfp1Y40TrF2TTG3Fn9j+qE+DuEqpc4mQI+8iLX54JN9b4LxPZEKO4NFNLMSuv3qvMT0aEx6J/bnpMg2Iwx9b4WgDTQwyGWuhs3hcrgJTrfMBa1wkP1Ld8dCF+rWn4jFcOBPooZj/9N4/0wThjvEULC5NxHrGTewHjWbvv7DdBgopwEVN0wcdor6Wvo6IQ4DIgkNHN7cgG6VSlLD0m+X8ghFGOMVQ==",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "MOilqXGEWJvTNTslUWQ4CVCBqZC/mPdc0UFI3NLA/E44zcjmY82u/k4ftpZR83L+HjxsxtMfKw7USm4MZUENh54up7tHp/8qU9QwRpL315UNEtJaB333kzxfAfa4Ypv927cM7NDbAdBjsbSzP1gQpflZ+tVTd8C7ZJs65lfFFS8ArjqzSnkPMnHxScvxc1OpbwH/3ro3L6Y0E8OUnZ6Uhlz90R2TwenMsXQF8h/IJd5z+o9NASEDzqeUzgXvU3GlwdsYIWdQAA79cPTO/5YtauJ1CPCtzeRDdeII8tgUJ0vzkNyZuyYLzVgqh3zmp2mz4u7rXCZEBnVhlHvQhSyzWA==",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "Ynzdvt+Z/i3Rn0snGaG2TN1hdppg6h9h54GwHj3ChcUWyiE4UbXK2bsUZf76AIZrT9MLuzmjTGNPea7qYegrxhdQ6AcF1Q+QrYcQzEDhyf9nAcdzc+I87soOMirDsy8w21JE+9UnryaIzWhGDdAlFHexvDemKPjgIIwbCYJbgxQuHaUIKaDiFL8T4OhPchC9x77pFVB7xYxe8+cXkhvV0Z8m3tdtgvQqUhtWlKodJJotrDRm7tqfnYTVJA+psUV3aHeXN2wJLZD8gPEa5jX7FBFFHQ4nx+qXZtoh1YI5eLm2kFrvZjs6YlWi/yM5/EAmI6gbT/WY8cQdGrKvn52fHg==",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "E1A3YD5LPZjpJef0Nt33gKAo3N90USLFNXbGbTUDzn9hX3g0/iJBnJGlOmagCdC5VR0EY6jzdeRvEJu7fT9jVNwOVXLd+j1r5cXpiG/YCtNKNB0TizIMrS29bBb1AlzLmjFll0yL+o54EDct8WQYnnK8p3iBRQDlnLsEIemljzuYH2z9C3s17Ir14NFugIHlaThjJtPWoPt1L3xMDzVlMN50CHovRKVLK2OuQFByX4i3PfAeBKCHY2vFfx1B/DGyZZmy6VxLRjIpmVyatsp2kUK4vACpYnIpH3A4X6SY0xBJ2+Ylz6TGgO8DGmHLRM/XTlClbPix7FJxQc9QQgtmuQ==",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "meCIcSgdL22FnKp5+zT+bjAFPjLH1fRBUfxTdgoU2Q1nLkQWN3aSLZ/881cjlHtvFRJA6PRRgrqruCc7NjYcBAQgQHqM5R83cV2urmi+zX8P6zctETMMtvABKIuAVuWqvcPRRBiYxxINBQOQh3e5WrwEVA1uA6vcfMfHJyC1WDITb1SCwcyCjkGd6Y11RDwMS4HtHy6+Yh84hN0Mp3wsbWXtJfC0+kHeNKs/thLxizoxZlnkqDwTAPEUoCKKbqfp0lx2n1svI/+nXbOlF+F+zdu3kKM77OrUMCx1KfZAtu6oUR6LzY3/zLHQB/t+npg2nfvsvgEHH3F+3QELMO+tZA==",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "U7MHoSi3DD6HiV3CwWgsRPakHdOU9J4UAcU2V5SQ04yr0LvKSy3MZ052G8aO4o8C8cfLTvrjOY2WPnoFpcx0wx0sEyDIQvu9iMzwcmlEwZ3Z69vvX80tbUeB97wXgeYV/Sk9DWUWX5g4k1yv1WiPatIyp17A+9Zvx5oXPSOcOkmsmxiDGh6a9u4fMTsc0u0FQGi+OPeaJ88gP0My0xeO21tQTExvcBcxZn6jFixS3c818uBBvLEoNToSNVdD4otnPOuu9Qx4oPv5vZ0LRw62IpA+LjbKz0YVYB2T2uI2DmGM9TWO0Jj0zyVtNk/l62fD5r/O5f/v1aRnT0agFa5e1Q=="
          ]
        )
      ]
    )

    static let RSA_3072 = Fixture(
      keySize: 3072,
      publicDER: """
      MIIBigKCAYEAuDSLJOL0aFe4tSmCeRaOnab5UMuZlY6rELI5CC4hbjChsxd3WN7F5sklqLBE5TtmAZqRCRzcIh2f8IgYqgY7xDbH2UpWixrnN623bl3IPM5JHEdRaQh51UoitJYvA6M4YBWgo9NwN3rRMpbLJ/5VJ3ICpZWQN7JuxquP+byJnkCkJEtnjgT4iTUrbtyj5JFAyM1wBGu5tS16h3fCebRWlZ/PSmdFyzkQAWkXFRkZ0vI5uO7Y+wP7cjcVYXjj6UF3nIacY9n5jmlrVvF9Po38jKMP5MY4FVudATla6TuBWlNf7QGyQiu+xu+/qyBSYG1IKmK6otsfMXkgFZZYA4SVARgtLYTDa4Rv4aVgNnkPYX+GzBsWXbv644G/782t46xOTGQiiNVPiUnyF+BZk5Sxj6AhWQA1aU8XeVFk9EjxYdueRoKN7cgrGluhCGuMs0YA40bI4j1EpUxR/Nz4vM+LyOC8nqyu0yG1InW4tu0mWVZFzwSccPK8YhdrPHzula7pAgMBAAE=
      """,
      privateDER: """
      MIIG5AIBAAKCAYEAuDSLJOL0aFe4tSmCeRaOnab5UMuZlY6rELI5CC4hbjChsxd3WN7F5sklqLBE5TtmAZqRCRzcIh2f8IgYqgY7xDbH2UpWixrnN623bl3IPM5JHEdRaQh51UoitJYvA6M4YBWgo9NwN3rRMpbLJ/5VJ3ICpZWQN7JuxquP+byJnkCkJEtnjgT4iTUrbtyj5JFAyM1wBGu5tS16h3fCebRWlZ/PSmdFyzkQAWkXFRkZ0vI5uO7Y+wP7cjcVYXjj6UF3nIacY9n5jmlrVvF9Po38jKMP5MY4FVudATla6TuBWlNf7QGyQiu+xu+/qyBSYG1IKmK6otsfMXkgFZZYA4SVARgtLYTDa4Rv4aVgNnkPYX+GzBsWXbv644G/782t46xOTGQiiNVPiUnyF+BZk5Sxj6AhWQA1aU8XeVFk9EjxYdueRoKN7cgrGluhCGuMs0YA40bI4j1EpUxR/Nz4vM+LyOC8nqyu0yG1InW4tu0mWVZFzwSccPK8YhdrPHzula7pAgMBAAECggGANIG9u/j5hBilLPa1G0EDzAqBfLdcgxYUywCSYzOLEfbI0Nz6hxmRPdTOaEQ+jz0cOY7OktNoKE1bftu8dBKszKR02QpomuRDTkq1Q791yWdfzbDCkvb4i4TDWciJhDbtZe4kSS6HCTl4EjyLkk3cBg9ok7yLTGUPUJAszRoh/Dsezr2zufbOxYWjaMl56jhBSDvPF2OBnxRkneLUS47NM39HPkUrzt7oIg7LppbuFoQ3UfC7ZunerdLnxE4KYT3ol5skBcNcfKd1UI8g+oaZfBJQ8v8J8xqSeYLPws50Pi1n4WkJ+4etVWmZWqtr1Cl+YcGg5/IsxINvuJXfz7YO4qtU/x6efRzG7uKPHFBrYFWonJiGJlxsW2RhvC3jwT6ZXit4i5fyqYZHwHe931nb/Hvp7iNyLFm9i4tI0x/yDl9RyHuFJ7M+tb2E/WX5cBOHY+XJ6eAnz+FJvECuYZZXoE/cC7BWsYKTldWPzOv9nwXIH3y/ilMRhWYugNPAhz+BAoHBAN9ZcRkHyVEmG/vnuqz9OYtt8QjfNmFRE3N9xBIuuZBZbTMj2wfEgJXruuKpJz8D1eR19R+0vj7PrULnS98IeHEbLB6bCj+NQFoTZGDMP8YrOfoGtrHkAy5YvYNuInRedn1kLsXm/XPn/pkBEAfoBiIE0TbDZ4YZ3U03msZrc/Ob3W5kqrrC35jSfbbmSv4ax/Xb/UnM8kKgj5S/Ekb0P3hS1DUSwBDNZLMsSRJML1+/Rf/KT2/z5/JDJEuNGsfCmQKBwQDTIi8MZShqDC4frlk7hnvYeAyn9xv8MrHzgbbpfgOR4MKEywGiLEAGy5p+NTgZmKl+8jPt6jIZWEcmFyZEf6OTXsH1vpNW3lANoJ6Rj2EoZTYVJNlgPu2HPhIGM/65AwMWlynV6uenVBfF3VmzeVEoIUZ8TqRsOCXG9KJBJkgo5yEBmAi7G3ZGkLTFdHHEHr7ctbdjE0qPYoujmWBL/tQ7u020BWtzo35EpwYsG2aCfCNMbVVOr/sBqzHPUWgwUNECgcEApwBuw4OB8S5ooDuN5olVPL8RCkw0kiGYRLPWJq5PS/LB5wo5XR598xuW2qIWWVTZ2wCkL3frBHYunCbsITFpNVFW9O+CgzBv3KpBVOuEB/4MVLouYucVxdLOqXZxRsfXGz0MiCeGfeMLCIa14OOJqmglsyf6wVeXlIQuM4zm31E9Ca01x32syM0i+N5LVqLZvyklw8f9oPoDQfp4hRteVe7BA4oomKerUxma7ZaPma0gfvlb2l7qoMe5XNB+JL2JAoHBALrcr01GHn21KAFMGpevT97naTQjZXZRG+QLcuq2Z8xtY1uKHHj+tvAMtUBsM6mbzq+XB1TTCOIbmmTg6jKH0Ss2G2427Epe2fUlqhHkFzZcVYBjK6yeJTWkPumUjSYLv2j4AsPccohKyfuKC8DnZ2egA7UzGRzamLy8ePo2OnlRDopNl7SZ+pU7r3Juu9265GuMvLEIOt4qdrIlpe+8qvPuszfX8CDZm4CBXtocqh5kZg1XWsAYyovQi3YUc6UHcQKBwGGfMrQyUEEk8oQx0OACjLXoyBlp0imKnSEuUDRBLH9ipoYdMb7NaZ191ZDd759lVEV6Xqnp3jHdasj1UPEBKsugi40Vv7X32MbRvC1Yb//M/u5Hnt3tlVNZo3OP6fNIx101da/4G67r/yREBxwt8OUeuswe3R8ONlkbBsfLIQ0qCRNlT6FyubpL2OWJRko4bXuTmMwRSBRycAAc58HHBU9Uqswr24U5kbpBLqc+N1blC1x2Q3vvoNO4N/b7KxiyLw==
      """,
      messages: [
        "": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "algid:sign:RSA:digest-PKCS1v15": "lsJaqJpCxmn4VBwdgxhpstYtKN0QtYiouBa3BinSmQRdoRKi3raNmiit5dbpaoJIay11ZZKp7A2Rl+bdD1TJX8OejCF8I4W2WXHTJI+Dri3DFt93Z6YXTodroJ63wjWFhb7J/36d9wAU4ofXeeA5xzH14yWwE4DUPsShlivORWlHO+JQRSu8qEUZPqe1SRS27aRV61cqGmr+dHeowmgSBZ9n3ZfNqP8vS+x+sLKJNrVXNAeYxaT0U1r9HLLAV5iovFKN6STAM3En9xyTFWCBvDsAjl3gV11KzzjwS6bvefXO898vyrqacpcQc3c7DFBYLKuuQOJVuPr9RJdjArJ/SOE3jUX6fIE9w58Jl8/o+KmdhHPgoeeHnD4I9N29P2Z2ZYVYaRcPMVTL7s45OCkcM6kSDJ50p56B1JVSCgMQaSbB0/l8/wwmdqaHDDDu/2RnTLaJSYPngzvr9CPbgdSwHp5rrFX8afrooU4kqzN6zqpweo4NcZJ4AVxyny5+6OuU",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "WeOW8oN5I/xdZcpyoC3ggZxXfcHHCS2zkgAX2Lf2vowwVrqlO+O32qObIbCsVNYSdGkYfgVpeNSoCEix4jbxj2KeDRIaY/HaJSyQaMLLBIWIAz2QEBTuldyNBrPstvnu9A1nC9gb7j3r22Wx8GV6Mn/BLijeV+CtK8R9gut58QY4vCx0CvJKk2k7vk+MU3j0zqT7PLiVxrqjLP2xowPer4kwwd134g9vTqo4v+5q1KhdTbDOCuPWthvZy1/NJeo+yqFB/FS6UL6mZWVNU0EhWUjpWyDzq7UqlOj0EepNwiph9Y0uE7gr5++MCNuJ6YKSls34CpAPu/WL2oqm4yjh8yzEAFSQ+3BdZRKIn49iF0q2J/Kw7+2AiYSlm3VKOP+/he50IvpLyKzooBmyP2Cvde/ZF9W7TMpvZoy17PI2JtiqPeFGvCCc5CpEjI1gk+afTCpwh2WoQfEC41uG0j68XiYOAOdqmAtuKy2FRH1tpk+85etJ4EwKHqtfGLw9w/CD",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "qcFTjJBxcs1/g2EM9zkSrcBINvuf0lFLhamCGA+YG4qQ3DSqPBOg69PGiIHD6tK3O1BDV4WHh5ysLaHXo8L4PJyQJBG9zAiCJEQdu9tp3Ug0bX4SfV++SFAYoD/j/ALHoZYptQneu304+sfxNyW/07m0nt9xT6py3gIuHiRQGU9TKz9LG0IGPP8C/riV6g4/60iWIqSJvBzfEaN4a9eICeY0hdQCzmxyiTegkNoaYoQep7f/hZO2OkDeR/xMfwxg8DBpL8JfwTJg9gLTBjR1UoWAUtWIIRJeneLe0jKM9nC6KCYUsB8Y87k10Cab6jCleDirB0oiIveoUFTu1obKZU1MUuAvAh/t0Ld4IuJmo09BSG63QF1m8iPl5oqvGpsVnt491Xvru+btjGMm2smVfnkNdFlZmm7pgydJy5hCn51cu4TMaIRMCUXQVRsGgQK8PDhPmVU2qsfyaGGncVn8QTNO6KPP7n5QXafoUAT9vH3BoaJU2a7NFS/uSKi+hmsJ",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "P4mjZeQUn0nydkLFi9ty2Ggzm5vBRT5zh/qCJ9l+BeARAnWC/Ff3HPWevvi8CllQxFZC5ZcI/horUJPYHSgu5zuDvYOvWEKz2uWjW3+BO6HdTTh6qrzgj5SzQM4pwziJcGFHvqGSmYoaC55sfHHEGgpF8P8tSqervGQdC46P2BqLfgEDOJsN6Q/gp7AqrbW4pVvMbE8nUXZvhizc0BfynLu2fte+iR97nVLXjsjjO1ZxQHT7Dzr147SMimK+suRw4gjQCAMM3oRs1ROSITw7DdySb5RIhsWBdxdfwuqvLb3+sp7ot8g4nDtfvOAaRPAUGX5mAglRVNsrkHqg+INV6W+sgD48oxno4UbWxkdw/AMeYDL77pBuKjHPBKjcspxfFsjZbs8ILbgIxiKEKcLtsqjd7TrskOe4ezCzZF7Mno9gIjmaugpnZIWcjoGRrvp3zBevDaYK8aVwH4f6abOnhYuR2asHpiURwEz2oo6HVXRQKW9IJwNmn6FOrdcx+nFn",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "BJp9R7mbh7IlBCtl5EsXnPGFdAFrshCWxuV5NXfIePId90Z3vIxrGCOjT+LKPczy2QnPpFx6QjxPAY4eNJ6R94zEe26MWtYN3g6JnClFSjk3sGW1YL6AzPGeLG/IzL1zWabU8Try0tgbA4qvz/hTZk6+cKwcXrAUNFX6fLifyI2rjGtXRAeZojDBXoouBQ9leiywvv91D0Vu7Er9ztD1vS0T1zMTV5IlG1oLWcyyl390F60/As/DWQupVQchb8UU/v/cQ/hm31qu0eDMy8ej+oxwBQq0upz0gH4Tia2IO92ZPgbWoTTwIS0cXGSqZBXjNx1vSp+5mZqqiLUUiW2ddJUViCNeWuHfFKWjAAIK/Eap/CR5sGU8vcBe7gvQ7fZCO7tZAIhfcPQN4Qmu6cydIIR7lteTMJ2vuPQsxFXIIPMR6TU+tb5whMD19Gdo5BCku5McyTP5PlSLFmHfLUdO8X47o2K/iCb6zMdltgbvqoGySipxf+AtC6xJsObIg9Ds",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "rw4nagBmC5MSPQx2HrRiNr9VFaqpaZWEgA5Vj4VjcxtklYFxfefjhR4l7cX68LFy1V88+Y9ekqa1jVBgov5P6PSgRt3SDA3s91Nym43cGxMST32FH7QPvFJk+pqxS8B4TpuFOZOGRsoe5J2ayUGc+LxBEmr2HxGt1ALJ/y3aGMWjjLKtuRMSKV7WWR59kLBOOArUllBBFE17vKUbmRll3UwiSMJoT9GvH/qR+YP4aaqJpj6050f1rDgJx3FAFkXregOK3aArTmaIcxQ6Uy17PlNZtPrXt7M6bVAkkf4h3QtYigbEk4qcoH667FqDuxgbgOE6H//ZR0FSdM50Uen5TJwsmTdDLfqSOGyWqbtNnm8UY+VYfIL6u9GTTjhaN9QG1lxhKw1L1zCbdQPpybM2N19C9OTP7YLnlyQmE6IAskzxkj6GMEGYjBG7HOTNwoFmdD528ugEb/h7C/BkRcssbd666jx8hLZjvl/9sqsHJu820t0JjsUOkhA8dZ3uGD43",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "SbbZ7sLt7h1caCfLKTcI79N1OgivGCOYpwBzrNa5mi2DNqBuSMQ5qwpHmtz2PgygvEyyw7LIR4ZbA8qH/ZBbQbNzJpl6W+Ur2U75w2kCpW+v1+gyKMH71GWvnewkyQ9KE7q3EdbzEsAWpYNKCM2idBlOcTRWWQ21aoGEdwqmv4djRgE89N5strIVR+YQKMto+pfRx5PhmcHhUqpVMFZnTDg4IL2/ZHw/IZexzb9KjSAVvL2TTdlqZCs7AAI6gndrLnsdVunc0aiq1gqApRKC4tI4HVlNG7PeZRMRN0qsfRHvjhNQgXohs6SzXAvsXjOYZG3w+6Z4bDBE75ICXV6x6GpFq9T9GCFivipAXY/eoentkFWat8Hj3pThYsdZ2tp5Qedkq2tUnJj71bFAoukif51y9tM1h841WtxpHn6q16+kwKl+Q1HETCaAx0HDaMsLPvvsSDw3rca3wv5Ha8B3kTuFPdIibtKWaNcEQdPSx95EZWpmJrJWmYYDjCbQOVJu",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "Q5MJLDAQ13EGWxiHzhFztVJaiE9KAWCtg/zhG1mReLH5PKR9lBWYZdWm5Jn7qHbsMJbyVm9iC5TYsG7jMSCii3UmdTh0vJhmUA0DBFriVENkgCXPJDoHMhvPlPSzA2bExu98eMgQ5261Hy64JHMIb6za8tVnD7q23GyTKwrIkBuO62TC9pbjE6Z9JPoxsAGAXj7NVXxtn9o27SW1BqlMEsvpD2OQ3CbUO8UNyG7qtt38Ke/GThYE27iWSlcWJ1CIMxHLYS376z5hm5ZbWLy9w57d2DHWVBrkTVtW6TCpPP3DZyLAtZkqOV5m3CCr/VMID4lmh0wp3Jfs6lxQdvDJ7gcuL0DOMvXHDSSZ/bG0KA2vxtDaHApIL+MiLh9A9/3jguaSkiZ0/ljOLuoniDEfaZOhjJHf+Ye0Rw3Zu6+EKoYe05jcK5vEB5awyB5rO18ynZ5nH2OwtfU3XD9JA+bvp6SN2vjeelIGBec0TCIX9L10+UJxEYijCIdYgi0NeoWF",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "Ad6cTE873TG7b+RhcSzHeHlw01T7GD+iY3XOGQ8wwijU1OALSNo2HmjEUEpTwq02PNJ0b430uVAFtSLkVTrvbdB6LvSPAzjJZWSE4g4QGxdE8cqVClwcY/zVm9QmyAu8iOKBS9thJeJYEXD3VYTgjH+gSWlRpNY9bMcQ32KbE8M8tltYX6kdy1ehb6meGK4wUBggU0tWj6M+zE6nIiKN4cfY7wjrJ0xKdVTcR+QlIjV3WZRZXhsVn7y3b0C737W5l3qLDjn3OGRwftFcmxfFIW62YuwoukaPxgWOms57Ogc5EE57vAUzk3mn7rWQGQd1OfEzzrkMfw6ksQ4Lwh34AXbxqOMlvNJGooksdRpqRJq1DUOlsHN9kb9s9U6Y6ZKIzTJ0Pldtf/XnWRErkmm/Q9rorJrF3CtbcNZQqP2O1xEwBZpR18yBtkRACfYFCHbNj45YOx1tfhQUabxeDnMeghfrAmpbGMov+aLGSOxWnTtLzGUGSIzlbQD4Y+VkeM3a",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "sLYZAtuSKWJAHe1CIOWbB8Qc28LWHq+i2o3egLhcUsZk5myFn8iHlQPpQ6uRN/cv9iDXr+5hAWn423JfjWjTariVEchrVCV+3P8Iv8R3UutGN0L5gbXX3VNgdgTbBJG9DozFyc2lkW+MIPxmprbVKHmFpXkMTWs3SCWlOuzYoRazR9LGrApqLxk7fm5UAn9Z26jACIx3HsiVYQpwZ4g7TiHcGlc++CvFR2chKbDpFVhpzQDuGf4/DeKh9MUFlvUa6YpAacpJKJObq7PoXw9JWpWVRoDshV9h/lV5rrS1nGAxv7bzeg97bFr5aegEQwrIJ810n4VXSX9/ESabQuaOwRMaVdsE0dYrS3Lw4BsvfP8xVzT3Rn0R6hJA1mZTqecas4IsCVALmyOYNgv1GKemBDby+XJQklHrCoqPwIQMDWbaDaVvSlRCUoOIXfD8paIzQwBb3mBqpFXhhqsfRlaWOS0Xyzl5Px/kRByzEDn4kKXOT61+ZmBGTIGpHvD175lX",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "mP+Rd2JeZkWaMg+L/xZDWGRIvfkoQcSyJzEbsjTx077qJX5qGVSlh1pMfr7TtDqGepL6Eph9BZnbHEvKeFYh82up1TjZ3kYQ814GTbbDbQKFt8su41nzhkLePNI8fXgmO5U0bEPnJF5+DQaouzkBebNn8mfaWNNApDjwfvSFP/JJyDWCifLMJmsaSPg2OuMY4vkLFIh6EEUAyhowdmEGVSi6QRVKcsrFXp/fTMzRENFGSEvkL6kVZ5TksPfmMCr0MdFoFmK1b1Gc8SdJAafk+5S+y+YoGE9hEg9Z9jfSzRvvfmIPo1JifX3NLyKR0sNCZ7WCpQnBwWhTj9BfTVwWLJH6lsXKLzfdBn9lmjwEsBYNOgXpKopAhM+Ve+m9DzRZtu8Yff8tbt351VIqpReDrIXrasgHgqLvXu7zcFEwZUmHjQUlCKZHI4RclJt8clMOK1Vi59JMs3SvEb0VHPSYmHN+leYYQ9CMdwpHQZCyQwgJ02XTgu1agwJk6n+NzPpR"
          ]
        ),
        "👋": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "Fy9PP5WgcEI3dDD4o/JLPszkb04L1DedaA3e4VpNFT02d8KxQOaAbhwmAT+reshqehAoTuIWo9B+LtMFA1DTvoj8ldCxYJzaO1zGMw1577wv99OfFFZFKNhvs5pC9amJe6c2721oKwT61v+KdMRJ7h79yTnIj+2YgLeNYVDyBjJyEByDcAIBpcgBIL3DXfPdAF1/EhZFz/Cu0wMzht/p7FoIajtczIf6t30/1wG5IcyaZ9hS3nlNueiswaYnqzfKleNwgLwBEZMTXSRsYC8SzYs9gPA+/JmNaSKzxSbCIFkhubQoaSVd/KxRBCt/zSPkdCj44WoTTXlyBDN/aEJnhEsu4Zq3RkCzxsdVflhyTY2sGIbxCGozGMDg5k6MDK0Ob4GteD9goRuCSOFAEzioDwXS2Y7bRpH5SSzcSq87RDjEJC+jBTttPEch6Ex317NqLFRD3eVAkZ9qG2Zbh5fBE2jCzbnPOJGed7bG5xeTLJ+VVNfDsXEoyUJHewlTGVWk",
            "algid:encrypt:RSA:PKCS1": "XYpdB+IsM6B9Qsv/0BKRfQM4ut2V36+M3OTkthKtNyKgKsO0EcDGbX36pm+JFkMSmW1uA06j+v09wdS4bX68m2Ndtn+cYvX5vJ7eEPg+erVYcKB6ecyBUUKMoWbR44uAtH3pzmfpnPMjJ4TnUrX7/OJ8hH/6WsdKQJdDeRWV+Xco0m1G6vHoMRw3RDHsZAhSINo7DbTZvovlyLHpjbrhVthv6RrF9J7svT6KGbtTlMlGo0YMml/NjfMKTyyjNwm5LwGqy9JTyMcbYXgfh7HraAhBvt6211p2aT0Mlex3YGw2lqnvEgNvm73buAQ5+fTH2NexGPtUS8w7Du1Qd4dnoDzruuB4Ds3scooICZoy73JAPQc8pI0VluVtofEnOcDQRj3WqvsdFB187zbL3xFICz5XOrwar3PNOMAj2JrtgrbHcngTZQEJmi5yR53TXY54EXoS09lPA6GrO1sptqXlrzxKYTqHZkN54I1v40O+G35h0YC5cdd4nDCDDgDcI96k"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "Q/h1sSTehYA/4fb8EQmhNC/39onLwBBCIKeFwGAWYQ7eIkOS5bfcgo77P49dM/MdwiB9zPKRkIst25sUvlFWj12dd4vIuPnOvru89LgWmYmOvsPHZIXLu3zN+4tcNHST/G0UfRhRQZAGKDhXXDDRFrGs5V3m0jEMoFVBFffTy/d9sDf90Fz/zKYp7NATBDRw5GooeFQfC9mT9fODWVWIWpm9gE7rxjw/sEYihTTAILUCDsAqtZU/rknc7RNsm3F4dQRe1ScM03Z3Xvt8WfMLmdAB2K5TS0T3V1VDXUeGK6NZ0BLmEr7q8OZhMbhZyv2hGHYyWpIENBsYqfRuKaDspV913GMoUkfl5HEcivOzRbPOwL0Fd9ZMZjC9GC8jIW9iTXSzgxOMRke32KaGtUY8jxO/6WpSJDQPOWbcEKxl+caLJFsTPNTQD8cIctl6ctU+ZodSC0aBddtGfCulC4KaLniOQEb20z+Mb/rOS/uiYSoPRl5nI8gKjiSEtc2OpAi9",
            "algid:sign:RSA:digest-PKCS1v15": "G160knrFaIQpVPiVZX7mPSWfTGruTjbjWYdpds7caXMvB5k5IiNNnrrEVdHJw1zC2qhNGEmOEp2wSRoQQSt6wfqruqkFH0OD3AW4UZ0hwFJozjMd6UpDlRsSRb6WJkxMpWuN4QcbCDu12qQDFmEVzp3vy0Fu1YeqG971CYI5kRkBSiTj2uvF2VhEXYGnkMySSObKMobfLCmr+XJpBqZ6YloTRlss3bU7ajMzXR2dx82L7xMDLHTEEbF2Ej8jWPpjP0tKt3deMp3ZrPoNACTNXZlQETPOi9zTCPbv2gD8YNqtCQQnF6xeA3HprWnAS6+IyfRyTnC3q0chWSQhkkGv+sdJjfct1C+u5QOP4IuZYhGVN8yD/FwqCXpTZpZBhZxWqKGl/S206DHibxixxQnhXRRztmDXPz/+Nm7fzDP7gM3kb1F3G+ShYjKbUyzxQhlsgFCSRGK3p2arBgiiegtO8EWz8YqdgftnEh54vPNKkPt/SzZHTmJWPTe/jNLOugWl",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "kHQEKVu4wSL/KU9px0pkuuRD84120O6+COZbrvYnRfrlbZiT9sMaVEUJHbYupEmAdH3eLdI+tXy5iJ1D71Lv8k032oJVyVIdjMin5wQhXhuQ2tRaa+E6V7eUV9+cnFpiTZN4PLloe9Tc+xLqFZUTeWrMU77G8sI6XQwsrKKf6FNiqJBClkluESLIs9yzBnO+onTjGnNOKX1QPT470eYLY66b+FrAuh2ny9axa6ob//7G4otiwRbEDgNpjjpWFAkuGPUc8eOIViLZVL/tigweXywDlDhey7uM6i66pvERl5Orpcu8nWhX34ZqHB6OLRv1XUudCU+JKmYSnrqybd752EcJ6/K0cL/jbY2do+jALFSNxBt9QYt1vgU9wMNiuDlNmWtYL7GqdcSiIibrwSPrrwA3yNPw4aHrgHKDr5wLO5kzOIpA5vXSP1v/AnGHWXHe8uxcTCD0nlAg4lNcy/rj5h5bLSqjilR6KyJ+JLT2evxiTjYw4eEZsYvocTBieTIV",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "dULCP38bTCAVtwptFuUwcCdBQOcU+wvYYPxD3/TC7CxLcdXZZQNkRU4FqPXYMRnbDpDLy0c0hv8tfVamset1BmyuEQS4Gn6FtV9VcIz1FrdTpoulez0iAsCN/DbXAsc8p4tM+Mbp9ftv5+A0pFMb5IhKJxQnztu8C2ZbR4xV/J5H6D38ulzLG4KnZl+CWmOp8GlVT6mOdYYXbBX4tMfdk+PDbV1+kYExfx0EW0J1rktqcdgOZlyeADiAnyVmb7wKRZ6xxyES35oxzJO2ZjdXDAt/ON7QxeoETf55xW1vbTEEQlcRaaReku4iD5+OdmagLWDgwwq4dpWhwXjAqKzKTcp6zwq7saKUKb9SF3I+rg3C0HmuZFtMC3cg5cA+HAQl0SJQ76yY1wO5ypkrwIIdWgTFjjYG7xTaDJA2xhZ1MEmVN5W5gCH9l5p9iZgXuQVFD2smfcozVL7pUMBR1AcEs5AwXMtVfRkxLbwMlSLtzZSqjW5hcX8d2bWZ7ALnyIC3",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "tM7TMQvhywDqO/spQT13VQA5fY1IseTkum6axludNUjmuuWfiRjR1ndjg9rHpdoHxjYQsXQQufIIkbkXzkRsDjkokzoYcHB/vNUs+8wYwaka5Elb2rDzd84PQGaLtbCAYCL/t7DNtC3p+JxZe/Qv7z9V9vcOnqXTmMAHWKUTyluKSQ9a2KHfnESpUEdB331otietaO0xAlU5bSiIfpvwoq6UHUQp9V2Y37sRQG2DX6ns4GW8SH2ZkSbqmg7diETYemth5gtgqLc+40dxF2OkAyxNRX6uncJ3/GccnSwvz/zG1pGB2DNgjuEPr9WgjPnJRRUzL9zBXgVmC3YFUTdNcCBo/Sn0s2qpHR6Ha7iPh2QzZH/KpWmNp/J4XFh+OetSHcT82gFkjpWe+ivHCLNaNnHETfzyu3mzT636X0JTnh9oswMGh6zo5VF6Cp0LevU16i8BAFG5maqsAn0BmxoWM7VH4NdE5QwrdQNFn8dq5l562TTZu7G5Nc0OMqRducbD",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "FMbx8I2yGvTZ+VQogpJ/ukXYmHPtCmLEtluLSiWYVsQtCnETQ2e5nBv/h7MXyKvKyhVkR2EJ6Xn2M1ahVXNI/rN9WsaUi+G8dgUc7R9aYMuvouvpQxya0Te+hsdxorYU408YvptMFQXdzp7XKKUq5X1Ra08yB5lLwMzGkE8wZBO/AV0CHR6by9yNl3MB2MnLq7iXiO6jpgLjVuQIImYBvlAXPSvyfE7uEMAZjreG8tj1jTjruloNVK0DAztnolllvhIaTEJO7oMBM/0H0RNZL9sNP/mXs8HUMAvhqEuwq8qLG2k6avRWgfGmPpK7Gm9TWxeP/F7B6gHf+DfzqJNRLHCRt8f0rjcD4RSZ4qu6Q+j+3Jv9KNN3r4Y73/VcL7DHKdsqEMdL67zsDIuSYQh6UCPVWQ8LxzBOP4V4aakEbYXzwSeMyEWMwHG9KaOUPjmfMDPz8Z/TfTI9rDcNWevRQ1InCFCjOKql0P+BtzwX/0GV/tZ5AraIJ3fLxrVdxkfw",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "GdRp4dJWKDD7A2KR2Wyl7t0Gi01LG4oKeGKfBBtrrjDg/YSoSec0mMbHHPtnKTqn9pg69T3HtBHQr+F+OEMCshXqUe6+409/YXc8VsC43yHoxSJh2Usz0GyOZuoTccxY76nSqlRLUvpgYqgFeUDOaIE4l3wAHRXgnmiGVBYKCEg/OVeQkDp9RnZhhjIrUAR0ECR2hzv0F0hzmia/ackfDNtYvegQz2IraygQQqs/DtBcNedGdIVD7v36Aw8Z8kA0NYJbnefECNDPaMbHwCB5RiFFpClmwGQ3UWw6BLE0cgU/1Mg+YWmspKx3GQHpmYqQGtfL+jKS7cPER2uCVKY3bxoIeqTs2230avFLBo/FqF1/lUVBReVQwvo8jvmXjZ8OAnSEqw0zARLiVHPrmzzOwVzAFbEakhIvq+UGgkivmEHRFHc5D/ZzP4ktuYlb4pHbyzkljAkgvtj7oAeNuUqY+RZSk/2uztI2gcKy4YkCRo3/BSbNETX1asw0g4uupAVf",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "qGI7kUhcQC834dEX4FwB0jjELngtdFVnE4Zq+MLmt8aQf5AS8qZKZUU6UYo8dDuDUkhYgO7qZVDiaQoNmYrFzqt8Bm7GUGV/H7UgGmqsR3QUEZnJgysedhCpy5SzlcnYn8y9eVzCQwE88V6tlhxeE1ExV/g7rfxbJp6WS3hNzEfzZ5quRdWTUAtyIdZkqtfYFIcJ4ydV9WWCpePv8PSOA0TioqttkkODLBxfvjsAs+qs3SHl/iy8BP99BV/6M7bPFTmG2kTNEsw8cpF6FNVKSBm84Sel50svp34zBoDuCC4KdDgzF/QVATxxaWT/Ck/QfFe55UKdmQLUylQL8CPIqs9h/5hBNSTnNi/MG3gB5qP01suPRecnKpHyjiht4ZsPspLvUxuGZpsm34THhklZzryTjwZklvq2jBgo4z1WlKeOP9eb4gkOHelJ9LlEgQWtAOdNfybYx1kGbDwxkn9O4M5GycVmJ1qSiULlHaqa9g6Lz1S3Jl5njoLy5b1WPMzU",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "jHqxfKpOIX/yKLQ3hrMN+ADPdLpkq0BOarl9Od6+8qjnj5oXvVGLJKGQflGSZIEsW/RDuT/ObOnq+mVbdDwI+k2aN733IztgoIE1SRcCfqOj1SAdUL1y4BTempaAQQRyhTs0bPhwNxnOVv50Iz9UaR20LTru6E3xYUQweSGtrADG8C3aR22DK/UKOkFjYLbu5k13zu2rjlVUeGeAh0i6INQSxig70iqcDAwxqxhr7bF/jzx9Kn9k/6L00ynefG66sLLMmU/rOFYe1qpNUnmpWWvZx8XW+qmm6QoONhQ/uyV2hjAcaQmiormjlyy9et3jctN8Je1E8EHAp7VDIagNjn+SD/60CQ489x4ACaNvHRlz9LhM3sg+N3Z2/fPc6CRhT25OV86a33EDdHEXH5kq8zEzL6r7N4s9eiuH9ZMv+5z6Ylmd7bvaPoasW96pYekTG1NWTZOI4vUW36G2lQmm1Qiiqft0NTD8BM4rLMJP6cBvoM2fuQ19vW0biFNUJ+qZ",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "cS+GgxL982yGQkRB6cm6fxvG1l9tI4egdoPhpCK0OJV/lvBi45uPLCT+pKc2mFB1xZ65gtyFvrtlh0LKMLFuwr0e/RarBvfReaPSieX+X1fNMjUQlgDSv+RDk4Stbb1OPavKACbaCqVMOF8aT5XzmLrOgD7a1QAIU1gI6ERTAiDSxxpHKtoQMIRrd2IDhyMe/kQMiQ99Urdoys1di/8DV4iGU/x7SRcHTqieKPpawVjCwIAHEXy2hsqkMIS4Pp5INb+uVn9nGz4lRRrrPDNsqyiI8FDz+8hcsrzf2J/pdcU4AzQrl46xk4eC6OFgBtPbDL2u01zDbr1NqW9q3+Q75n0N8cUynf6aR/Z+1cGwwvf3Vm16ImgCnTtNm5g6/5q8RxyXexqH5WP0VZzKqjiYpGULawQF6ZNDJYI8RphNqs8bgGnYF7EtiW2GtgjH/BUHe6tcd2viM1ZJJPZ4KlxWAi0j9xhsGw//1j4QdDzRgZFSpzdXL8rMBuupuv6fNnOn",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "AyV+6+irP/70kPO29NmIyvJskmkdwgSIF081gy2J3qQTSgBzeDaUA0EvLjtDMhcQtP6TBojO2MfNs9Q2WjZMDjUh14Ld/I3Noxjdb+YVaMhdYwoTbF/q+8bmaQDg3Zx1sijxuWpg2cH70wdtbowaK5Vd/GJsUe4SKYTWWvBGlH/nT2/+YaXl9To6z3n9pRrXshH3laADgL0TQS1Ial/V5cNMeNk1iEjoEqCUEayEQa9VmeMgAzLRsvlZuipb8T+hks19DttMactOPGW3UTOUyA/d6WYkQHVQ5ShaxNr3l1PT1Cvlki9JUkgOELXuumH54q1X0WokpDxhBWZBqHXW41M7zfvUm2Cy7Dm6r4Uy1hg9K3qaYozRIyDW3X1HrKT8JugMKPfllBwf1+nvnzdbmbBKY7wSDzCwCQ8OhEzrhYd6/WNaMCsnaopr2k/oy9GT51QO1Ae/NYYu+NT8HTmpOPud/N2cIRaOVOhKigCAbB+1EMgG1tk/AFLCXXzWBZAL",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Z+jf0xk0iwOCiddO5U+bM7/kZdOfRYYAWByPJ7w5y8mqvWwF5QQxDHjEU+7wuthPxCYrHWONH7PbmaX/AHGuMOiiJBnoGDezNv2Xovl060fiXBo0lUKzXA3AMVLtYbk/CYMIpBBz9o2Fv2NX8d72drSvpuqfbskTiRZ0zl5qXmYGJikNduGKoehacTPYnwrHyauZ4fclmMluAOR/8fmLFJWj2pclcgmxDkowN0tFwuY5JYbxURhsryHzkpPeOHWo8dUZcAw6cltjm6dHKsRZopVEJuZx0Nv72Ag4hNp6U5Zpjq7ACMqVnhzc5KjB5dFkAf6ht2emQtYIZq+KTvevHdKHvRRy8tfIDD15ZYnpvTcmhHQBI/t/9xFgz5qAo863l3U/4g0DK0AtosNzCx4CQ/Q+oZK9NHavXjleqyc4mgIu/vN+HGgJ0fe7K7FsCW279XT+5WkjgIUTUzDXIKZ4zI+YSGFHJTDnzej7MED5r3dQeYSQ82UpMWJB7N7Ppg+6"
          ]
        ),
        "RSA Keys": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "U72VdQr/mTJpQQGs7buxEnmTG00jJizTCOmLgPbKE86B+Li9+8unTkgN35QJBc3agtZBKb+/VgdzvDXoIvwrGPPKMW+7qX6U92gVxqaASKOcQOW39OBgpVRJMP/NyqWMGSRMT2ZjCofh55j42+1ll029LlqwnOiOv6oZNhQ6OzZKRxja0TfdH9h1MtdUUx/KWRuMDomJ0w8kwnjQ6ZiRh1D0bJ4Tqb/hftCbkF9dJz64ob15tNtlD0HHs9NkoH9QIrg63O+FYL2gna6R1VFI3osvTWk2qhOy/99o7yxUJlxa/Iq5MEa/XjUi/Vv3ZtR/F6LPS4LI1mfVX0wEiN4Eubrvdy9m+zSuSVwkmN3MiqXxvykcgQEI33wOrCpukM+1nexF5xbvJbhjk4f5BC23avwrwd71DSeka5ARS8vajKHoPmtFVa63I/YSpGNXWTzeckqqB1Imv58NgcOF0txCYDYcXO5nMIQ/t1+30JbhzYtZfdY1vLdV0KahVnUBsq92",
            "algid:encrypt:RSA:PKCS1": "NI29sa5hiL88OyGR/wywdDg0wdRc9ZAGRf/wgeBlV9utdrYd0+P4DV6Xz7IkECWRqb4b/Neb2B+5OWmAK8VdsugWnaG0ZWfCW9Ak5kULQlJZlKRgyKnzW6Mc2uzdw28pux7d87whMGtp/ZloH30onnnljlPu/LNXilZ72c3osnBMhYT8L3GENZuZgNN6mVZ5rJOqx16uP+v8M95sm8mONolAw6ZqZBeMbdsSOnJQVBriw0Rk+5MH7zKC4raum9uHUxvrQ/zhP1bSh+gUnxKsyfNrUjhAdEIZE+0gGOEzylj/xOaO+l9ObDDUbW+GNLN9D4Vge96p+iBGBPqXEZaLKtqTJ1ra3dO7Sw3d+wc4jPRv9OnzTz/agJBgxEdEdRFKH7/HeUtm8Ydfs3zBwISPQ918AkOwzsQYeYh5zkUwS4OMspGrm0xTt8flYBQmPVWp6CKs8OADL5sGJ9qVECxdAhtbpVzDSFn4aWWi6J5JBkNSdFwsHTg9lypiqVTReCbU"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "Rh/KvcbbFVG1rn/VohpSyc0QmmMmKYyrNQ9gCGWHJPS7rYKP8y0gCU+JlwsFznrz4XIzn1HuFTErqU8jIxccjTBD/t7//T8v+wQAxpnxVaLja0Od0d+txzFY6VpZkMJV0bs8wUThrLNUOdMfdlb0mZ8uceWYHCzTE5DO4rB5s08XAFWurBjDqn3uauwi0M+R7yNnXnm40bmZlWK/STmKyiYuKR43Jb6fnUykkqX8O2+85URKZkVAL9TzhUUQf5DJQv7gltVihASUiLH/cJrtpi4+oQ9+/Pesim5sTXbgkDl2/syIL+SlR8JNV5HLrpJYoIEhotP1U2ZUaFkiFGMQnR6yOQiVEgral/pjne/BgKWEa1bvfudWKLMcyvkCjw0WNC5qUMiULsdgUXbYh1ZwEUcB66HRWXBPHnYNbzoczdH+75jeCmqYew0EHV1dStD1tN1HdexnHTkoiM3v9x1qFcZnilI/RPTPETbFjf20z8703Za6hVgfrX4S3H8UObOh",
            "algid:sign:RSA:digest-PKCS1v15": "EebJUans+9JXnl6Vdp6iNFCQUMC49JDRV412nqec06hyoHZt4auo594M405X1ZtIGsCbFRuc/W+L1NL1oH8k/U2z7q3OrR5SkwFngLUfXlfBS6JLpoczSYwIR62hLxbdCEkJwxCpuw2HiAnu8aT2UUg4BFYZiQyXSx6ynO/cTDA0JOpTuK3heZ7EsrpRAQFss3yk19YL+vw8QoZ2C+f8qEzpeVm27dWAZ7IZ1Zre/upgGGWVNsZbms1H1k3Xsbt2WQYgwMrKM/fDU6s3/uxhfI7d5gJq0Koy+qEc8c99EsUKGUm9veBAq3sAWtwDaHYNICN9fEjH8/JuOEFn34X9de2BZD3dWsinKoyGcFjr35RXROYy0ToJmO0Vb4eDC6KLxsMbamm6dc7caeOgxw63ALtvLlsbE28Yo9bTFV8pqJfGWadiwGRvKyBbcUpu/qkLjyeDaTvvXNQxWKl6jxf2QsQinKBRVqSH+Y6AG8aJvTRfSD1TRYxOkEnDzhI4i+4X",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "DNhnp3Twvbt/6kqzIMgtmOTUywS229/aJfmlkhta6ZxgL5Zh++5eXw0IK+PA38P+OiToFYD363UoPx0zbzd2kM5Nt0jGKw4bnvhLEuc7QPpwjcg+bGqQmmUcjpi2zI2sYTk8rMljmPrjNGdG8KLpEebpDO2Yqr+bhqWdPhCDIF0FAZNcH86SWo5vsbl2FiT16mD0YFQC241mexKJAS6YZPYpagYq/Sftf7AX5mB0tpBIE7Ga0bwROJZ00Nt7p3b897DYhDNL7XjrJGFSUkIkIHLgGlDyAv0O7QlqX8v+snU935wTCglzp0z1ppC+0avyOeSN32zVqSI5BLmp2GYeuanmH4pEz0n9+ymqDnCRNpAugNprrymM5lWi4UVF1xk7mxPiMUT2yi1PpT0AixsMnzRtd2uyUlls410TzKLO8W564OpxSKohfyonAmC37fbIBEEeEHbpU2QMbxDD9N1t6bOrBfISe4QprI3wBk8m2N4Pn9DUet5390HBR/MSbuNq",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "buQOIoJ0Bxro3D4UxrGId+iviipNKznLg09Nyv2vXJoDBC66IXBYI5nJ9g8Hfa7sC+Ou0ZYAmvupkLij66Q0umA5+kP0sRp0xLRJloUsqzqD8Xvqxm/na+XOPDpdygy8LXC5aXE1Qt5MGXXgkVvRMFhOYI6UFj19OpFmidKFX4+MznwgUiVz/k6f+7GQ3xY5jO9WqVSdD6Q3ISY3uM4xDDsUKaYojNTp+Z/3f3TgnqodxeBbA92cWkmmYqTzIZcKMpTSNM+fWYMDoIZvHx+r5jZ2uoXc0YKxr39bBW2SEe6WQF6pQDXLMUzn9hyb0EoOR75FWLYIV4DD+/zw5fYvEE88Fww73LYcXUQuqyMwXheOzJ5hQg5Q7W6OfcObT41zyqCaJujIGLX5Mnme/2kFa22HkvxZTb8dGJRUEoZ0ycIOkl14N9hdUdGhLeO9BrMsDdohL+LbR394JYYbSl2INE5Gl+hqr1j8gnr2fah+UEZ7Sy6uinRt7cX78bsLhe6K",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "izRlGRLjnjDPsYmLSfNXzLf+eGKcmw47NcAWlIhit31jyt28klhiOfkMM7thCQJfXsj6UBEEvxKopamuTaatUC3w+9qSVOG1bWXHJ52yCEpmfLueN4Z01ClnLIdm3kRmaYDA3ZRTXM11XSclLpZC07LXT5Bl+M54PxXf7JqmXeNCkmof6AVHop1bD3btLjsApfF7bG3Whsqvfzio69qctrb2MnA5x/yaMQS4CdLYedNNl52RF3oP6TdvlwTEi9O7Nb7XnGt76npFyr85cTwwZ7SsfkWROxLWNo1B4NbzApDieT/XRIH9wmksFvdTq0md5XGk5naBXOHCbKamzC37ehu08EgyHbt9tiHoYvc2p2fuySEWbuhflWBLelzZHD9F7CazjiSPbz7yBbNStv41/FoPFpziGFJgWYZ/0dpdSQ9nhPDmfFlRje2Sd25C3C3tYKO/m2qXF+Bhd6ywbjiHV+cZAxxdKfs0aLAiXOP4zdaVQJUD00At/V6nS3Z7bymR",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "Lz7cURi86Mk5brrH79zk7Wcfaz0CF0cJplzW68hMYPJVMaj3IMj81d3ZxHQxbvZzvKEjH4vgCxF1hCU+kXMT2BU3EeEgXLWRa0Ewwje9QB/Xt3h/vxIX+VzrI0F8xybbmJTXADqanybq53PKmovvt2kxYGkNx/F7Lxu8LVP9ofTpwY5imv3Qy6ZM6fm585ywXb8qZBlUHb/6j+EQk8iQ082amgvxDm8FFhX4hdu1YdHD4bCxgYNYDUNgVP2eMHoZqV5eSVWpNr5DApXt5Raom2OP/ElLJ3yNOgCw1UE1P8VQg/xfP/0jBdBI4iSylz7KNjx3lQUVZd+Yl8HqJy37fkXvvvpbJyLBp7RHxhpAfWqRYvUjtQm/6Y34myiEN9BWOqjw3Qb/jvwPsD+AWGSdfFHeS50p58gZZ4/9CYL8MafDJITTymyHLJcZ7aiXuv1/2+gJ/QqNVWBMI7bJRcV9vbEimsO9nXsp9GGmEXut7i891G7PJ+ggLwxq0s21MVpT",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "mLdJ7aqJiI5wDOp9kQA22x04uL5uTaaaWLlMybn7zPt1nzyL8xBfNndIk4/dRATgfdF3PxuUqEeZOVQ9txrFG70jkWqNnTYjzkOm1jGtyEYo9ld/huWdUgwYy1AfyPuLANxQM1EdhO/LITESTzq/JBPWPl9kLJVHJz+xqMnweL/5Anq7C5576B1hfWago5NNpB1LLCWHI/KTJ0Toy4eh7jnTeNk01B5ag52Rk/gHP7UZiuBiGHQN3n5/uSG1RwmmryNzFNpQm6W7As5RG/3ke27jbIYfZBs5/a/uXDAze7jZoj1hF565pDo8UFKdWOflteAG8c7GxWSyooLQLanz3uV5UcaINWfOyXZ++sEAtQWJPQ4dIRDRvea65bWIowt8so2t5nTvHSwSNs09wSgtYgtsylxbTsRP2qN1v+q53RsMzeMfk2UffEsL0v7jeE3JC0HsK4vfYEEpj8W1pwHwjZ4lrVAi9GucQ2BxF3TpD+opuEUgwQfOzbF1P9wSChQk",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "NcZ/8UO+hgqa8ZLK6SBpIfh/XoxoaXn+3rNGzZwhPLYhKjkDyaIZc8aUXdCrCL2BJZOMEvZSL/QDtq01Zit+3ksEDlo7QA6tavdDWYjKdZRk9s0HHXMlW+m1dqsIt/wXZByTiOAm3NgIoppkuhW1jMqiq0EcQzmuXEdLwJ7OaOaLhPv2J+vC0b9y1TwuXQ/eSVCQRAugkFqButpgCXOg5eVeCjqgVJfJMYZTSCTUqdQ/jdscw9TzdszPzOCjy2RMx8z7XQhh+0TJy7cFThAfLJAgA0ePNaxt66zGJl762FfZb30I5K02frX6fDBsAtjTv+U2Wdd5A17ifzAJ7nfhiXb8UJqzPq4Wtz7ftQxoYsyW1JXsgdTxyPJcdQeGGPQ4FT5SKmt8gOuGN2WywtdAurwC+qxVzZU5QDsD7CojcZgdSQ9pEz5DXkfb2TISikYyQ9StGaEDg+ajJ7U5laXD+L+JnSoWa18t5DJMS3MJk+RIXJZuoPsQJmbKLuZ65zmb",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "O6OOybN73B3uO0rOP0UqAq4yePd6mczA6KvG2RaitN4hjBM2CPXcJFt25tdBx8lE8rHb496uveZ3eiNFG4yG9T/szBnUdneN787Z0b4TBJBFMOekkwn3VXtrJANzqPLPtLqI/Ev32E5p3v35AEICx8iNk34/xzHXvUO5l4dRervCyljZnRIu8yBu5XhYKQR6vVAI7Yq4c7rwu/xF/EhJteQqJ6jD3FTgE4ByEVZuKTkTlUPJw+mZymhGnHhNwkHNEkBQ97vWKINNAWhfH4cnaa/645mWuBug5vziUWwBbfHY16wsM4hZHtg5KkmUvn0dV68xs2T8mcD0jwf+VD1LX2rSS20nzg321ZDwUPmgUq9VkD1f9C8L43a4xqJ7uqamFLAbAj0w9uIyGZQrwyUroThhogdkY5czMVxO8oaDItWDChajFoESHNrP7tIQUwTZIiXHqyQGAfhwnDcB4PFxdz0GSCI5RDqoYytXi2/mZtBHx8S3nLWPENjh4m9ZDytK",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "QSrniQVuYs+rYvcDpAgmBlyOO0G08hxyJtdk5rmexBhE5wEZUd1zLwsnHWskLz9Zjie0HC/GyuIPgjRPyEoySD8dLrtFjrjtWKq8S0+lTjA1uSw58RdNAATx0KteCxyjpNFXXKs/NP65qHuQNMDob+CAjuXuMysJOpa5Uy23fKHOjLWfR4ioMvntAKfHQp7m3e3pvHq1uTmHstcdrJuPEP22snML+E1W+6Vo57n0DQidCUQ3hmGByvWTr98YYsam6TP2Hn7qTxOnN+ocGVVFAH8ViAnURdpz5dVgWX+keetPh071tfXUQd5fYmjg7IITOzMNl81DrvJmPDSEmVmI9XiiHk1l+JI/bkJOUZmSANoH6UcascUUAtjkHv4a0YwjmwYbIbv0QADs3shvSzFveBrIdmbwbedRTXz0+VXjFuq+pIbXN9oHWowl3JVn/ikIJgHAMP90zttlAE0pJ2bnhN7DcvEfDYnXpG9cK8TrbwQqBfAerTMESc8lQl0aSH/K",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "b3Y1cyHjXr6zRaTqlnn4xlsKo8pCs4i2I9bWs0TtkzcHeYVk9vsC5Nf9Oa6YRnK1ezW+0cXrdLXB4Se9w2a0c3+j/eWBxcIo2n3P7QGOnOE0U/euNaHSyNOjNkb+ZmcI0NR0+p07p9AetaBpiEB1Bd4Xh2P4wHDaWvkc2hfq21snYTnWgwNc0XasgJSdka43UyX3whmellwNZ+LPpv4MgJ9b0W76tC3dpzZ28Axq6xa6bvek7sP3AfGrr+9J8V+0zrVaUvAgSnLr3nDISuf0iGfh0cntJSE9SLvuWmiOVtEVbcHfIdXtq9cC1z0eWzXfOz6Njt7p6N6H6F/JR7PJH6i2XjTyTwdtraMPwOtQp5QHTIXJoswjLSqcJZ0mSt/4CYNqNkQf/3/p3nAVsF21Kik6V4jonhIDJd/Jqy4+gVmzE9x4K2ayiMTKgyL7Hu68MXRicFlLtd83uVBBik52fudwejVmuary8+zA4Doep3foh0W3ZakIJnOR2USPBGI9",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Sj6+dUKsbxxreBjyRMHbxhlP1l/jKIipN9YWBQoxDQJtdkdtGxlYIjB180gunc8wSCWDR2bIXHYT+ch1JM/SDSRuAsGKWeZ6WlsAcubecuUjiKq1s0PAeuKDVgN8f1MRQye1sQh2M4t3sSlM9Kq2Dfzj92yYjf4XEtDBE2NFM1O+RpvGLDQMtomdOfc74R4hMovG7wrNCKmyhJMSRH/mtVsDV8UTiebi09t747SyehXHUzL78vhLEwzkmmpv05B5/FBRuFiwzuoI0J/a/S/L39NatrvHD8shk/jkyYtLKqxFOV4bc/ELU7r4zo9BOFNk7n70BIPv7bf1RYIr+4QF0x1W8y8TG5bQo4h1mD0PmBwL6ppb0WCI/JwBrQaYhyANao+AQNPGKtzT44WpTXKmq/EDwXv+fm54gR7qewqC/WkcqT2fCgYLkfmZZYNkQfikrEEeLCTIn44CeTROSn+KnOBK6E5vnyJqEJVC7Gw+f3OJBjN6mWQuhAoSA12oOsel"
          ]
        ),
        "CryptoSwift RSA Keys!": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "djrMGfalEl01C9fedRjSvlwhRLkcMbgS/uRXdGlnwnBmnlQGCNUx+bBzBKHxkm0lNW5/YWzI5n9xXn3uwGWunwid5/gRvED4aA8khW3Uuxx99v6zfR7h6+oIT1FDNX0zVJNVBA0tC4gFl29uqqCVh8LUHlR8/TkYtl3nGH/niX2JmW2trwmfpfx6cc7AxxAgPaipA9tJiKhQP09Oo6w3iIuoM5691gidhtFi3IVXOrJrS6xG0N8ow8vnycQ24cOPgX8QOC0YjjKg0P3TznNcsqOoSA/3iU4/zapkjXTl6WIUrHGfRktDhnLD4eILCfiwZeDKeZxVol+JCC2Qlpd8qtNJqzS04dt3O0ltmk0aeBeITYHzBP60hzdoQyMUnngXmn1Xu89ASCx+LAji+aTaXGuxq0dpFqSRI5f/W6iJ9Q470xDN1BQdcyFNVRpBx9xq3FCanCaZu4hnTWxU61tqgNUVYnGwNxTWOj2PbYY/p4Tg626W6MANWuzZ8IDMwAnu",
            "algid:encrypt:RSA:PKCS1": "lmD+QCJjs713PHDvjAPmUP4XrlZTo11qe3l4UCcT4AbjVW8bfHv0X+MFG9obw195bw/3KCkugyod1CTJaIvsrj4Brop4jYtdg/cGl6im29Z4tpZ7N+u9nKPnagAqhTAo7XXguH9/WJFwNbfJqrZ1FgUPJ746L+NGylKtBhYmxkliD2vrJu8kOjEC6Mdi/p5Rr+wWZxWG2KnWbv0bVyhA5HxgP4HhGXu4ZRLmz1ChFQzTh5SENRAzlKUqXc/Ml2pYtqtkbt9DbTDY906lJGQR/VMc28JYNF56Hz5RKma9n3RkH6w336G+T/7mJeit2+K1DpVnjCX2un0hSNPcQ1ZxWoLXTuGpln1yWi4MPWyJKGMZUX4JEcMQvcPWoqjITC8PE77SR5mN6ygzYJOviiu8ltKCjz77D1oWSvH9MjkvSVVJ19oT/VbpiXBGmVR+q9fgUHZ04X00grLq50gXlhDzHXGPWBibgpWfXYSOQFZISBb5W45P1gn11m44G69lpst9"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "fGd2UWsA86DOlsOaiqhZMjubf6N/MPEqhjil/s00JkynPCYvqp/46J/6P9UAZQYhye6sBYL5JQJSxlqND1Z1yIMPNAxo27jNQzmI9T5sstk4L6wH3wnjrTwW5qRnLGzVVVpLEOLEJG5oR7vbF7DWXjub8OhPXa/8V5ILfMDgNVu34XzxpvC1Mk37Os6FpV3Z7ytZLzb6WNbtQAbXy+UA27xa2LsKQj+VnuB+/cpwPJnZvs0PT5iB3qd/eW4CjlOCIKJMJMuFQf7fvqOiIxaJmwKLAaGRNndLTvhKo54sW3suCqO8Tfk7i0/tS8Dcn1ojR3KQQK4OhUwqrmxROrY0K5yLrOb0UyB7IiFIXih0fT06MpkPlYW2gYtgkwQ/l6S3cEVN/TNNa2WEqgCREaboD0J/o06vfFcNsYwQLv9UxFc6CnRyF88/J4ySyYU6MPO30hoc+p6nw+8xLrz1mMJElPzn+sRL+LWMv3NFx8AF8gjeALsqk3PBYBSj1a37qnHS",
            "algid:sign:RSA:digest-PKCS1v15": "RgoqDStvydecqvnTuwlNKfAwb9WWKjEyRVyNVjkiNRDbrOWqCVod2u7a0e7Areb0ZeF42+bcTWF4bHhO2cnLubVKDxXpYGjh06voyCMy4ZU3mn/VAI8h4XkmrcH+2SJBXMNraUlDkuGt/TUdttce7Qofma3Ax3r8+EqQcGNrLtJwUxLrC6sbZdbqyKUhA7j1WswpqLzDa/75IlMNM9qrKevM3SlYtxk3vz5ohr8FP0ltFkVBt9o8JVH9TaCO/djsDNp7weN77Hp+/VeyKny4uZnoFWtMdIDDPEyOle6uSZLopNOFsGCod4jaIFt+Swj12unsaX4NsYlg48K4oVFEyFdzUhHKYCcQli22l4kQpn6GHhI7BPAL5nCvPf58S+DDv927yqYkY+vn1KH22iN6ns+1IcPWNaRvz2K/mg8kl7ZNu0r8tpxic5GE0MAt14Fz444La/Ebq+9ZsxxpLOdo0yLReN2NWQacqb+mzsghw+BYZxWB/sByAaNA7EpbmWVY",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "fkedPCGJiL9pI8DHi2d99qUyCLT+nh2cSD/BxNXIQgoRyt18Qh6630MxeaXuVUt9HJ1hSyfvVITTRVk3lLGnrWutx0Ot6Rzk7skCqfAJ4b2eu0SYuuY3+xD61y2qlXsDbqM9EM5XOVu8cYrw5O3iGJwbTcV9RPTgFxZly4L92c8oX889LG3FphCV3YueIqbUDcuO0YUF5T4MAKQs80/NPeRDW1pd+OsMmm2f6IHo8gz6yaUzfnN1cFuuOl8aufQ8V/RESI8l1DDG6iuGqzV+/IDOkFQtZTs8D2HYmxR1p/MS7j5iU5y9JaC99lBxWigI/E1DHC55TUvUEp7F332o/dDo5+1kd6FGDaHS1LMYZvqM+Qhyxc3r2YCdfQHnXKBzGrfTDS+VZYo+eHSMEUbNpkwpRSUBBr0arXqKrnBS1ebORgQXLsTOp5TeMXsFQx0Oh2ixA4xBUat4Qcsdy3MSLLJka96WChZWbjAkChAhBUZhOZAIEiUc3wvGAjLVooUr",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "OzqP3cKyuni28jdKlamaWq3TYDBnAZR9lfe1HGyZaH5AaVnJIFtmLz226qWRoeQlkJcqPRFaUR7YdUCR5nbeu2+LYXGTZnDQTe1F0p3a+6m8WWWV1MFcMkuWrx9Tmst5sXyNW4PfPTQrUA5+q3nNVyWA3kDddYHTOUIOk41D8qRfiP5kQcNbDPitBlIzfu45U36iY3GV9uUpSAUqPuODnq73fCR81no7lm1vvIA2XS2YfPpbxYlRxwzDc4cfnLY5o+wIqbgrVWsZrkCgqDkWtpA1UxJpHUtGpGLO8R05OVuJA1oArovPhoC36THnw26zX3I+PL8WB+z/IkH5uqCrY30UEKCiEu4vBxpCDyX4XOuoJvBEU7DI5Vj35xMsqlguBkOfLAYoTSAgkG8sBas9jy7AX4Wuv1lEf7EQGucPRNxhUhFXds23i6h1uwN+UHHjqmvvqU/KAjk6AuOL4oJL8fAhhVSSuDeJGBJqijydgeW1DVMqB8fbBIO0FxUNSg3p",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "m5WaMZ/Kr8C0xDHPN0MuzCaizELNA2HrbX8cQzpxoxR/9cO88DpmXiGYhmcieExyDhbWo4WdYWayTbUw0HImVe2red/tsR6mjaA+GkRxL+h4Tz4p/0uG/4CBoAq3zWaLqBy6oUf5Sgdb8V9+2GIAhKV+9mTT8+y/gr+fqKLbufxb4S6oZCUKDETFJTFTJ7zu19a+iOwqkNPW58cJWrzWaIRZohZG/TLV0G6pf0dR0tiXb7XSVS0L5trtTgPNfwVURPOajZkB630xH0KE31JHWT8R6FKFXRv6FSXrhEJiDHMIML2jRbJAy2cmrO8T+vLVLY0h4Mx1PlhNMtpKDyYIYbtoZn2NVLccGYymmeeEYdjeVxvmfIsf6bWHz959tkchsCemPCy2teFE3Fvfi0al3qHkz9g1atgBEfLBuGtu8dEQuouI0+WFs40a55F0kx5O3SEUFYXboi3vzIcT8Lm32s7tUKiBSx78TuuA+3AanWmujMFo0XjIfVjqxJRUx2xJ",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "g56hHzxSpmVODiCkkktaRW6poDqjo6f8MNK0hOysM9OLKxoKMEeWIFu05opnGPHb3ISgPgPtXLBJOcUObBS9GUqH+m5E2qd5Aa5ZHv/B8pa2EiGiCZf2omvuXP54nnJusDprM+utmhDQRep5G3uZ1q1/WYtSRzTtFhYhwWX8gTkr7dOM+fdtAWWCty2+kvuCt7LxlBLOvpq77RiU0A0cntFXOc3DzOSzZimX/p1KUFkEL7uDBq2JOVxwZy3WbJXVjHhZcuuNHH/AybQaJTLIrdm3/86GyKfXCCU1r1qzdcnEgzD60TOA+M3Uds9SwdIKJAxpbSb/7pa34lq3lKpd1YcmPQxuiNB38Uv5wOqxMigDf+HdWgbnR4171erpQ/YG7rSCQSB7/Jeh7lIQ2OkUe83zDbeOleX2LWIgB1gjBVMDgJqh77x0LtJGmtxwHmGK/Nr3MSE01VFAA87KlDSHQwk8Nc4wnn8rXo37hkHdbWY4sjF8kjkkMwuZ6lhqYsMf",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "iVPY77wYQ+WiaWd8CMMxKJIhEu3nzlAGq/EFcon+hs3vIV3d1K9nASF9cUnuTFHsP6h2wN+UiigTCVKtsZtd4ZQm5QMrRznVk0w4UR+I0XtqZUpj4xXIMynwe6r7GmRBrRT8yID+aHAShV3meFlJD2pP9K9wbF07wPTlXzbyTspPduF0pkvlflT8e7Q713BL+hmPsUGOb/60JKvHt5UucnvcvHbelOUmx1ToNLpWEG0CkKIwxmzhTKJqLWL/wXR0vc7RCk/XuVl9lbsvI17lt1UHX15aj19Uc4ud0q25l55tsLjtvLyZXM8D4zonnZYkWiz0ZBdLRrKBvLkGo+ag8MXGqUMUwSMsLGKvVHLvpZCQWn6RMFlWv+SnsZ9KihzfXuiBam+COdIE7BdVM2kZK6FemjW1KWaETxdWJ/iMpUawdRIiW38udv37JdK1sMW7bC8Zqvqrkx4GhkZRtu+ZH1J0BpRsUepEn7cPeabZn2BGpElVBkukKsuIoBSdmJxq",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "od+mpd5UTymDudy/K3hkH66NQeC8xyLR7MtE+YbdHh+LtzcelnDl8sBhE4P8UAcJaeQsBlRpG6T1XOsJtI0etSu6fTYddl09AGIBE1ITPyrMv4CYft+tRfhHGmCSw/maahmgVUk+63lcNY0P2+3UtIdlvi0cQOacFsYfcnBmPpfnIN+qb5SmPM1J0y3xPIHfTuyvR1cewWMF+VXsSxeSKz+repWCI5AIvFia/3jCPbaS+9n8s0VWG62XVeiOt+0ekPiEaqMxkdysV3N8kZ/Yg4jFjZpcqBVPcT2sctmw4LB9VjCdX+96tcKWxqPnJcBk81XYzqDerEE7KVMA72jz9Svg4o/SkCQLbZY6/utwkqiaTegOpd4blbHq98U9gUiB6h5k//3XnIEksrq9adJnuAJzK0jeGbiY0H/atSq8ulgTRuUxILYLFD6MHENc6CaAjFvP8M5MRnYFglvaBWXhpfYdYt/uqSzb9wh9Mr/e1R8g2K/l0t+MdGUlVCL7PeXh",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "nt51Mi1IfDB2TDxso0duAQFkzwr8CrwJj5VmRAROTRwCNX3Ime2igfBeByBu8CWmzDFoOyBOWAMe7lzFVKzMFOyCbLNg/OFImem8Kyw9zN4BmB5yfchmRzcJr8CPykDQXgVdnj7cvVpdZitCP94z+xmV/AYcBfJvB2tooIWYsikQ2XsIm6zh5OBBZvV188sTzs9z/m33agmraM9H1EWG0PZZA8K0+sXUYOIEWD2uBZ5FX/6LP5c0k+RcF3jTiPs2WvhNnxmfv9DXlRSTJpZeXMxojDlboHsGqgsmT2k1geP0ecx8zqkOsbKvqQnTrsvuvesuAkF35TGAAIOx2ev3HY+mVemg6CnOZGGAEIHJNVSndJzyQrP2NlgaDG4nediZbPtwHXE2587gA+AoU2jrVLAzrinZCA3sjxdwUBUbysw5a0+XQwsgaa3hBxgJpRzdWRxD6I/o1MZ5IBfUxq7NsSIiQQ3MJzLx4HJqIBVV5fpRiNepbV0nh2AUalEzjrpZ",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "p4NIF2DG8qRwwf5tdFO2mZVaCaRXm508P1c94V7xoTfJPnsrpkaPvkkRATnDmM5VmvzoYkhqgXeSNkVS+GR8QisJsPPswlYABeMK3mkNBxWPbjxKVVMxWcYbZnOHUMUrkHC4yAQTXFZGwf4DwTsjilGeh5iB/wKsV70D0pu8IN26FEJMp6icyiH/A7GLhtLYTceNhsLSl3UiyZzJfLrETkvg8xJSCHMw6VBH3rxiryusTI8OwMFyYDME33iYK831EYoCj75I6AqwBEyKBQTra7pa1TEHY4139YLGjhNbtSH9roLNncES8Cz1Kz1/rJiKre97skYCebJfAZ8PyjSp5At6Fxc0ITQ/9ugwVPUba6KXoNTdTHv8jjPIISXYY+jSdEgCik9cSK6Kiqino5TcPaHu6muWyw2MWKcD5lCtZKf9iDam2BuABzYgB80d9RLGBaaCe7DTCcCG/rvjs5IOc9zerw9vSHXX+tpe3S1ZHpnZgKs+CtY8koVaSKlLuBHd",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "Pb6TidSTmUWcDiie+BRaWQg03LBHiQD2NdtZcxnC6S4MIp4tjVOWLjGzpQVbo3NiYN/EuzAEf8rCqtf3GZIeJ8eOt8t3prOipUWj6UZ0fjLFr/EOQW8Jo8oQdvmgpj61dmiGYDE4YpAHdVIffwTln28kyFSNpMKc/wFnHDJtJpj5/UvlQC6ywAKUdyq2Uj4llXUwLToAOj4VTuqPxJuPlbqmgFDg/s9niixwk/PDpxVVUPvflKnAsh2LWEQXjUcwX8stx99wBT0VnStaOlF9wDOP9LRp4OhEFOhNagZgRn19tRrV4YPqSlPoOZPT68AdF1sVieGXkWlV8ue/giRYuYeYRNCTGDsPUtC4sU8D+CTBaOPP6ch67Q9kU0/iFbYqlqWMktoBFpFfd2CxktMwZBVMl69TXMNK0F0BWmgR2YUip27ieME4ez0vbodTl7MBcvpawkruP869lbRDepN1g9ltbGKm6Fn1R4BWVQREtXgp5KSbYX/JsU+2Y6qrRdlO"
          ]
        ),
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "OnZNqQXZb4KQ11TR8XY1pFMzOCBPjGEolZwQ6zpmJSTlT1XQOo4u8rf5lIYEE/qVpMyZVhIHQvHHa1wacXEde+Ni0VmIBOnfFyJdEtHQZbv1FT1KyU4SRWCyNI8g6zO4N1p0ldS1gT5pOYlrjF9VPNBpAyYS+wHbBsNlvOsWeY3r1FOtfF7Iw2V9mMQ+Q655r+sdgBYoB+nf7zRra+JwEhlOU+cGrV1WVhugHxvoIfzItIWzMWY9UCtpQ1IvFvDydjHzA3e9WAiwKIIA2dHtzErd1bAzKnkjZ2zq8ZbH+AiEwMxx7VrJBrrfCQHto2O56UmRPZubuDZHQsn5nW4vDTozo0oiSSY2x1j5ccAxcx8che0VF39OFPSUOyYiAcRJbjs+SL95XpzjMaTQBhi/3nQQIZ9tt6WYo56nyueCIv1pGoSjdqC1OuBpf2wlBitXy2y/7V4qfIYixscMlQtpIP2ijAWowHQf4swtFJzWz2nSbkc7AVlfun/S9Za8Q/CX",
            "algid:encrypt:RSA:PKCS1": "gob1OHvXp4NbhFCz/YjCGVk3Q9EDkjouMNHU/cIA9dggiWOUUVfFBdUrVmw+xT83kcwoLghHSQhB9G9SOvP5dzPHGa9436ydRUU8ccyfR4xsu/ML1utXMGtkx++ptOAGLjo0lvDWnKEy4PgTgro73R/dQFBbNOoALMFc8QTp0jdmsRRRsAzt1gP0coPHYuEHjce7LHrtRNjjoicdjw///wp96mJyv3jTN2Ey8i+6Ujdd+JUoS4kwzabA3Mh2SI3AvMvnWXXyTFtZFdqwJcEGLA6ImYPtMnTuWTa43tJ3A/qsDF/9Oclnj0ajvsAH1O65UbhQurzEEA/PWJHI80xjwsA5BwFtxi6JzA/A8BcIiKKetv8KhZJUF3Fqusdx+oaz8mcqOoIIn5hq7HEqIaaKiRvA2decAQeZ2jlfoaiTpbaU4i73pl8hF9ryqEpr6U4tvf6S3FaUh0PRZqhAUNeDYQJB5hn1RnJ0pF0sulI4Vu4BM27orRvUGyL9D6gtPVdG"
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "BtSjq0EDo+UnmKU3nC1sgzbE/0oMM5xziS+CPxuzRVNPzJj7qkB07hUoUNTEZveiqS5oY/h0Dnlu3TbOretwwQTPSSS28u1z9OL+h/D/0j08g18J1K0PymysbLMDYfhdDioDL6VoOcBEsiAQhQPMrJQ4QbQBpoz5K31irM4OCZhb3Pwm+aXBvrOT2J7obp7BLOCHngYCXvGBGut9q/CX5Ni4/ORt8vTx+yzyX7m+tloIimyKt52+YM8aRlS1DbldRgRXvXr98ypmjXzxrh6vgLIDgS+Lj3qobUeWZOxZIGQw/gJKwOMjkWyTpvn6i5Wyud16kup+xL/comDTTzr2d80puzFVMIDE6ft9OzU3hdAXD7uPr7v7Hv1BCDr4u99pcuMixuoskcNFNy4K4JPbOVRNiVGVUl6rqvyHsB4rOEDp20LKb8qmwKj+3jnP/tsJ6jyQ5oSxKcAfcLe547mo5W8AsNNk8ATdF8sw7U5PuXEdJgCnfsdrdwjQIJmI1LPe",
            "algid:sign:RSA:digest-PKCS1v15": "Dy8wdbDuteUxtxdYDnczmZOuLXhgmyk6pKueK/rE3St2aJU67ENYk9oXqSvX3HowbaCYxrBBnsSIqYSPo+bWmLwtDNs8/Jmlc8gHJt3vpXQ9+mSezHpK7RpvLW9E06CrA4M5U+41BeReDn2ZWZNXHOXVtjCf9earKypqhu1x7uJgtO4+S/7g+vOekJnHWo1SQ+mdx7EegtHbqP8o6zFBCR3bIchWTqMqx+oVTwoFq97VS1BZ3DGDi0aaTtiM7kTcycCY61EhFp54UZdSl2PdizYuW4l5iMcIBnbukgEFz5bOIn1OCDXKKIE8eR5zGa8tLrYWxkldamzRYWCbvtj9MxoU+rUa0oPabINVFtJKb1d/yca0mLZfZ4zNAOLI4pXcjMXbiwWCL1NiOrIPcVOWL5T6fDaSW0kaRLAKn9U2yzuzTjGu069E1+IHyt1i0M6EyY483tilrfOgd/f/TRF4azHshozpPM8kVdRZN27wBYXmtdJnAOoAMQtjJJCgqBSk",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "V/CYYLSo4c0EK1Swqu5L9PU4JEOAcA3XkiwHEhm4NcDj5WTgaV9XkhXzWSyo+wJQiL9m9EBJsE34V7cqtNNxzHMyjnYw6IIPOUzYy+oTFXXODjIhgC8OfqUNLrnBl0z+NQX0QJyxiU9c5cY6U3C+hDJEqfqylE3puc7EPZDsxBts4wrl3qFAzCyCgxkdla/kWQtuh0f61eVZOSN7YNceFijxe90ttHBworGItngL6dEr4OjJ5HBAuashlX5gXhEF1JAZOSGiffKdWEsN3U4RdIsVoRA+LHjJdxdme3GW+doMICcTkV5o9SB3yiiattGhVIAeFn36jvErYTD9dXMJb0CBwxlln3DmIY66lVLLDWq6ICyup/Po5NJWXVi9JvtW9pSISRR+uyqYGGw2WdegdGn1WlP82WYeO0fQT7A38dHGuVkAlArSPbIubKvwdJRcLjTobork1iBwU7WwOIcsmePsiWqdoKXsZ5oGoe1emNxq092zBnj09uMnovihGxXD",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "fSb9Bk+9FhQ1AO5PX1IaDpJ9jjQhZa3MVOr3xC5sm1vV+nUZCpultdJBFweFKGjhQfdac5WkxMraXJD74weZv8PVuDTR0TINbc2Th+b8MGmcvJDT9r1M7l74ObTQtEAjAVygZwnio2TL/jb35OAYIOtv9Pmb8LxdwtgCvcl7Nov51bEx1v1HRIw4vp0MyxgIy1wuEQPc41O81WuUYWyv1KuIFSU1UkGJ2RQcO2b+5i9kYeFlqrFRs9iQsrM8AuDSKoqUYmwRtCdVBOVU8eKKSeL2ZIVVU2xfeCBzlwW6ptMvRUPeFu6PCMEZG/EN3BLVLbRoLOClejCUupD9Afjp7r8a2KFG3qFk8srptMZ+4UzzMoG4kp0zzoIjc4gcZ1BKCh7KCrP0IWFoWgXp0sjPjnP0D+nnpOG5+ptXrdyFzZolN6R0gfpQ40Aq8GZwt4TJYWbab2YiTGggpxuoYfIkikzUOGxR5qPjV71TLoDIyI4ojdBTCXF+SN6bb4PTvasP",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "TC3n6BcED9Xbva5SwEM54CFzMgeTFZ+e6cdLT5GOfLpA0PY3NLiLYxIePd6GeupZdld/GYLCZipORcbBcaCQc+mnmoe76xSlMnffrvdSrSpqyS9ns/FIz0n6S9eO2VCzta03TwnX2VBcMXn3hxXi5IpinzQFKKRpRKN4m6gegzFOMSWaBNgjBlxTNg/FE8Z8MHZ0eBtUgDd1l5UqqtwSjovKhW5poI1esMLpug+FibXyX6oUm13l7aFdjyHAQCF8gCCvt3fyrY9zMFapp0qifQOEs83brhLCGu3LTUsEFczfcysCkAITjiIYb6oFgo1mWzFj5KV6RWddCIBAQ0k0f8R9Ypc9qegzr6WHhOvPhcPnDQPLOeLi8Iv/aMgQKdWy6ctddtu7pAUPQmf4WJYV5IBsACFcbuveNybL2CL1YtC7fcI3FpPRdxYkJVcC+QZ2RT4VyqvohmnJ7kvOXsvQVbaSuHl1Qmcw87MnmF2EPHC6DxGdqfqopCp6A7AJeWQ+",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "Vs2S9PnPOFsCbiKLMSBesuMt7R3GJr4p0PUgRcOUKKv45d6KD7Dp4/GcUxgnchCBvW4SpSgRB1J4gcXhnkY06oarqwq6nQ3LfNdyns8eJJW0mrYSf1W1WZkMOo3nADhmeztqZ9/dsgWI65x/cjEaFkcc4JYbFGpqYLv7l6wEsfeOMvqOqHcIRR3vm7msgSAMMUg2Vbs3LnSeQmPKW481wYdIvRUuKzsZGKL7MEotoGM22Ix1jaLqvWrSIrsrHlqu/PatCBPKIgaQz8FOZgMbCjgxHp+7aND/1TsskPhi7RYf6m6LcAVgdr3vaIsy1qXyfyVNTpAoXBqHiUwlob145H11bCV9dlhKlPAQ35NNyAyEdIXAQc+rFaksvaVJdPj0hr+VBIaAOTkG+AHXlnuynbXFGyGtX+smHbMqS2fHhnWrLetRsxCX4ePnQvSvyN6x4wz68kaBMVfq/wwxgcZu4Pwm6rtQhTChaX/UaFKlelIS8O4NMQ1R+CUBJWMWAJpu",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "QclLn+13g81mpsWw48n44i4mQiT4lxQaIe4R+8wyL6ftHPIZM3xkjMRL9Ij/sSlCg+pynGyf9TOBLaV7qM+gZUqA1DKLlVvwsLgSrrssKmDOE0oPEJJ9wWDNwrTWa1o42my17FMXL/+CvOA+3xw09D5bCliI1bI+SoZSHzaES/W+lgsGlMS60xMzGmiN949xhBBIFfZjvddCSuTKiXPw9ObWYz+FgQjxPnsUHZRMJCSOSYgp7bgI9q9VaoO4AOMBJCrH0rnP362B3edSNtFQ2Hm3bAnyZlVGvDUoEM9r0GQ39L03ifrDu7bdIC96C05KQNE7z/8e+Wh4pz2Ly6KY4DoSiiHC0D5+gJ2wAFb/QfQJhaZc9SbS4Trc87deyaYx1CQ/wjW96gsFXQTvoUahi1tdbBaSPqqxz8DaP9/crj2ekdR3hzxSMy0aa1/QR+Y/3Ip6G306toc38mJXLtGy6CaMm8FO23y2JykaDPyA6FQD9+toozdPQv3DEzT+0K3r"
          ]
        )
      ]
    )

    static let RSA_4096 = Fixture(
      keySize: 4096,
      publicDER: """
      MIICCgKCAgEAyp6KFBHi8Tz29tMOICHD/fIiuDNCnx/oM39rUcWJ3vnqWSjjBUuZT4vUSap6TVogk1qJczJE4ykpy58VGM5GXaTgLOJkzVBEPOq+WV5n/9KwteUf0EX9oS4rCs5Vz4IbTfG7IrZH9UlmnMcK9Qm+ndJyLWd5kZ30zWFdLS8b7NOKF4SJxZ1UayGM/IXAkUuT3rCn//0qfctH6Kc8ORC/EaQeKe6T43tklMDi4WPQqc+FmV7XkX7IqtAVxcgoE0ii9XUSEru8PdtpUqDAbgbtyOOLPdg7o+M0J/J2nj9vsVJSJGHiRY4LToVeSTeM12L4AEm7yzpjOhHWyR4UU9VyIxYzrkNmjmC+M9f/110wst2tMwZnZlxaLBrXAt4g/UWULMDHxQ4hsQmCwrfupf87NfoTrElgohw2BvB+SvkyfPz0HBeJjDxu2xAmRtPj0jxcwwTKLQXD35ndk++z6PHghnYnwwqyGSPnS8/BdjryaHq5dbIq1GYO2n61aZ6Rv/JBKQa/5i8jhUC840/AgBIGcwdLZlbyvXRkVPXGEQsvHJZXn+uZZByRJgVazI6811Af0alIR/8hQ7CZOn63cfNQYpzU10r+Pi/4ep7QIf3h4pBNPOvd2tqO7PNBwAKXO4+XNdAlrIBXzNuObRhfb4B33ZACN6Pu17cVyomf5tYO9BECAwEAAQ==
      """,
      privateDER: """
      MIIJKgIBAAKCAgEAyp6KFBHi8Tz29tMOICHD/fIiuDNCnx/oM39rUcWJ3vnqWSjjBUuZT4vUSap6TVogk1qJczJE4ykpy58VGM5GXaTgLOJkzVBEPOq+WV5n/9KwteUf0EX9oS4rCs5Vz4IbTfG7IrZH9UlmnMcK9Qm+ndJyLWd5kZ30zWFdLS8b7NOKF4SJxZ1UayGM/IXAkUuT3rCn//0qfctH6Kc8ORC/EaQeKe6T43tklMDi4WPQqc+FmV7XkX7IqtAVxcgoE0ii9XUSEru8PdtpUqDAbgbtyOOLPdg7o+M0J/J2nj9vsVJSJGHiRY4LToVeSTeM12L4AEm7yzpjOhHWyR4UU9VyIxYzrkNmjmC+M9f/110wst2tMwZnZlxaLBrXAt4g/UWULMDHxQ4hsQmCwrfupf87NfoTrElgohw2BvB+SvkyfPz0HBeJjDxu2xAmRtPj0jxcwwTKLQXD35ndk++z6PHghnYnwwqyGSPnS8/BdjryaHq5dbIq1GYO2n61aZ6Rv/JBKQa/5i8jhUC840/AgBIGcwdLZlbyvXRkVPXGEQsvHJZXn+uZZByRJgVazI6811Af0alIR/8hQ7CZOn63cfNQYpzU10r+Pi/4ep7QIf3h4pBNPOvd2tqO7PNBwAKXO4+XNdAlrIBXzNuObRhfb4B33ZACN6Pu17cVyomf5tYO9BECAwEAAQKCAgEAs8GfQlrz+Y1alHN9zqfmFz9f6gcgDcfi2v0qGuujezxA2kTZ03LUWqv09D3YLxPMXq4tzxND5jw4pjtGHjGyX5XMhEV9pGCXiWvA38xPe7hRqa3SYZYWg45QBVA09Nm6m5XfrdYFVOl/rYswf1/bymxPe1SXl8aIzkSYw2NN5PdvRZoCGF2R7VFgoQ+QXdatIx2ajhLuRZe4/gCP/xiKSn5NfGn6rhBklUvifI9vKZfAMObhXGUcZd4h0svWMfV5DUaFeDUxtbcYY4PV9EcVYentODrD/outU9tZvN8OmkQsN7bXZVm1Uj4j/dTYkKVu2+KORqhQK85zvQ2AfzeX/1A6FYa724J8vRzSY51iTKtoyF0N0X3lFkfF2lHWo8uNYsG/Jj0fNFnGWhg+nuOkf4a1DeBMQABmLi5n861wSDCya8zwZbTnXlR7F02hNbqh11eryGgA12PPt1bgfIqDR10nEDd4pRpzTx2+QXiAFntkOMPHQnGluzY8EMBzldv1hpqYTU3NvDq/Jfe/lGrmBp2i/C+SqLvjjOs9G9y/o7CpKMr8XMs8atHNBM9yMJgHDGVcBMNkdGFavtj0e4TqZmHcPO1qX+l5j1xWYo1nUIHFU46qWva0UjO1ZcZCV7o85Db0+vMdADtVm/cPXTiEnYAuw5mS8e4GAbNZnMFuWrkCggEBAO7sq1g35KDJXpfM+hPVRhbj2Sa3nYPEA6sTIy4fxCrlzWrOJ5+8Kq2AyS6jd7BlQFPSaCV4Uzd/yM9ANeF4v2a0vAOgQv51GAPuplhOduguE+egrWlicU5+qEw99XeDi3Gl9lCqVmDs99VzB+1GaT/ULnn6JTIQzRkCGTB4CV/tgD0hVHoS5UtyQRpnpVx3ICGVkl/JgKAsTHUJuLK8bbnLTi64xzDXScWPkaq/f9xNIXmj9HjEJHeszwnfIfmP4USm7KGHrklwx9mWlItnfo1Z7PBTOXGlItNHh4pkDbXbYlzqDQXba7yAfL7JFDiZH0sl/NtO9dOQ7qFBOCZHqWcCggEBANkZopF+4Ei2fzWCp2UI68c/Mb7UoGa2mTztZxBdajtxc3GeGlEuPjCQgnnoCaN0oVXRcdZsNBpE81r05SfFMufA4iMFg+/1U7j8Oy8QyyzEuuPErY2HM9rQ6xBCjYj24k5VunOqlyq/CfngrQ+FV8/quntIfrIMxbCgE9VihSC0kTIZU1wy4VB7DgjDoG3HrPwEhzowV7zfcyhyRdO5yi9vfaKc3EFpgU7zIuIgjEUgT72eoNOmHbnmgpCT/j/f7aGKJcK/kSkSG5bIb2knMRTc1WcZRaw6ys2HQptV3/ntAXHWFwLUbMdtJxgVDnLcoTShLWflkRARpqbUYh0Xc8cCggEBANfsk72aZcjZs99EpA0ghcNSD4HqFzRqBVaqaPTaSJLsNAT+Ytj9WSSMa0T2/sgv+T7HvM+AOtTBa13CDe/DDFdppzEvuNv2Psnu9+5+mv+iBOMkVxQSn4vs83RT2m80NuVys3SbPI1EG4aP+u344E2LGKWr58mjXXfoaZNgKDjFj0uvv4TDZu4UR7nxSYSTNDqlzi87ED+xSTfMnVsK568tiW64F2yQZF9jLKY/gvI50rL39Yze1oZBaqrlOPMtkMxWfyxMTrqYbkS6zWxfEAP27ScUT6nhL+P5lQkA+1MK/Y4zB6nvbyJgjFxvpRKxb5KetjIM3iVhqgeZxYDy6qkCggEAEINzqy+EbeN7z50tkHDaRmCXLxXLUaTICSthsIv6faUGi/jjtZMX5efIFO/Cc+12LCnvR8kZOXpPLHb+S0Ujtx8j1FgiDgmSIbsF4XGckr4wHQ0jymUjW5ySlL0LOQTWd/DrasrqDrVTU+90Gn8hC86l+qSsBm0USHgUqiGBUNiLRs1IWvX/z3hcu+vtcwxCKzVI9/MfaV1xy/zNNOqn523Kl6jo1Azrag7yc1LYeJWZmynKv+6dyjsvaUHokAE/eQ8iCis6Jm6bLJ/4YX46rISTsvDoLM6YCIQmW9xvWfpeJsOLIor37z9tPtazL6d6l58+7e03WIqPK5dyExZqlwKCAQEAoQpI5xrM76TOvkqt8y908xOm0V5Qy0L6rDcNw7+dAgzDuUb0xCPkHcjl/0XOWaE60vOFVb51/6dwrwF2LFwnv5CexzMPkzMU0odqXv4o7JtnhZ6hBa5rLjgbJQtlqxoXQNCzTo2avvZ2RZLrIRh58fZQsSiAn79RJhvYoJsR/+ulWgIxMBLgil7+kY9oGNMCGjZbCIICtUpe6kmw8x9zzc7CwaSI2J6rE8i+vt5M3gXTI6zW3I+iYGfZO/HiT/F3aAxltLd3PZiYtcUrFsxlBzLsdeJtJKqzEkCa2uyYQuEwCKrv6m1cWTxSiNrv5Lmz7cKS3e8tm38J5R6vOtQ7bQ==
      """,
      messages: [
        "": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "algid:encrypt:RSA:PKCS1": ""
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
            "algid:sign:RSA:digest-PKCS1v15": "io1hfWK5emPka90cbjukVgqd9BtIQzfCOX6+bCyQz/xQY4soEhq8ScbpLqY2SdLMHXGSyShpP8Itbb5fDjboCG9o6vMiipwndJtcR7s7owonFu2U8JJGjpcHIc1icOc+kJ+mWW0OjJj8wzx0mWv1ZJ8hHQ6AcNmzBlRjJdvvWRwZ0vJRh7sUEoOH8xXL0jmEi7JdbNcE9OvEN9ZueCVbkwN8WzezQAzzlWOYRG2zTB3JbjEUAODDK6QWMEYFm7L955dDA34vuzpLm6swZTLOlwHSvHG99G/m6twOou7kT4qxm/N1p5uyN+1AQovVGTCZc7d46q4dU09N6JkRZ2oZRIkHhKXa9f72sKyKQT4DF+Kuzg/bkfVf8Q6q3a8qFAEBcQ9rqCb/1Hgw+M/B/XfFgPC74a0lgz9BdUNkZcQZyxCJrrUUAnbC+0+RlBXdwZw436hng3utiZgh3Y25QN9buidxfkOSGagPPwfDm+Q4PUi1vC4LnDuSY/RRZc4kqMXWDRKOyfxY5bZcup2ay3I6b/3KSI0RBXCWWk+du8w49WkAf8FTqazHilAcf/GM1lWanRr0rxEx3BoWRnX63dZJkQnIWrO0IvVPGHM6Kb73jM0pImgTPIg33J23/zO0jEx19vMjcE3AB0xLM2o9Yz+Yp9EguWjLoPp8IDe9jGSBYqo=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "kRgxpE3HYDZpGvahoh/pGgmCFyQ86nl5Fc+tsBmDv/iouaCQh8t+PyDVoxgIFtWvSuWLWBKqWNoxR8HHMFBwcC1RbztJ7/YQZLS2yxb/Y33YwOfSXcuk7Ep2Qhk02qvOxBkXbNGaNT//UR0Kq6vAsD5e75NhEGUjGlLugUrnqEdj2aRZkcjSE0m84CSz1lin1rEHW60Wn5qDfoIDIAxEE3Tu74HLjcHyd7bjiHPWAscqyoGgVXi/KXTvew0ooyscMX2+WG5w1lXgKeNtAGa/bb7CkT31VI9DPwDpvsopfQDXhLSIMC5W1oQmgzZbPnUWi4guYF/z9A44LNXqpZQzhcupU+6MA7k8cq5sCy8i8C4017mruFqMZ/Jo7qRjb37t5zN3aylVzogoDpXfn3GE1ExEK7fOy0kRaNL1iVTPqJSWl+kJLFrRE3NvRGTlogfSBPL4uyREYv0P+jrpyEFSGRaycA4vSvXo3nWmCWWFpboE/6+Y1PE/0y2ha0L6+kH29cRJA7lDO+LNaCBq962ZlbAjlpr5W4pMMIBGB5O4tQ8nUOK3vAiIaf5OGRkPo/t55gKyjpgf+ZMUK7HbQx09rTENf33nGsF0F/HE5vz5kQ0ifUA+Ublu9l5Pu/WHvhf3lduotMr6D2MNByuoisf5cPu0FtgaH8CseTQCJHqT+YI=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "DB+dCwjY+P7gbYbs1AtU5T7y86oo85UUk1Gz6In0WIPIAr3Ua7IvtWXh/SfhXPynK4YMeg6mcl1ecGfrCJnTHiAYK3qhg4tTQqs/BbNueXLyHFgm6C8pXOrIFu5dodkEYa0lNPMSe6Au41vsq2cXfJ22Mp7MkND5gMDAdJZVx09LF3T7bbEtGyOudAToJuJoCk0qXlfVRSWQRs7HStJwtjROThWYsetG91kQZpnDptk/LMxkC1owyI2QjttAzKZ0jVPpTdhL5SdZzOMnBKP/bouC2MB0D1/xf1j5RYNjR/s3iHtiNR+CpGvho09+CrXIeo08jfKgNld7b70PHoBdc2wU/2TXTZbo1qSa3R3Ra9NKzfAjkfX+BK6JrJlhP4B2ujSuwSFHD89XFPmmL8hjy8qY9P512pkqW00RqL+w0FN2WyivIw2bazw7P1GEprSewTyWtycUrid3A3heXKw3lsyX9UyWaYk5ZTpe8Zl4Zr5LZviD8419hjdZU+Am9I5iIKhmN5+IxwH/bB/d2HlpWiG1NVtmxE1juxcgVsAH4gqoB+TgGt88wOyzzZnzkqF6XAsPszcKvlAotRaYYQNZr6RZ8uIkJu8JNpkGSh0iUm6A38Sm/Mr8NEr25aS5/P3keu8I56Sus4m75avWVvS1LEB2feoQeOSHc0mvE9QWKxo=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "bc8za0TQIN3p9wCaHgQp0L3XtwB43fgxdYyYWt7XLWKJE3uYwP5RFEN3MHC7WLUfbN2q03n3dxz3RCtHYyQeQwRJNv8VOIZfnof7wkn/CCP06Fbc/F6BBdgVSEF5ZuvfLSSt3kdQM+pdjKI0nK56OTiXDJfEvpV94+AGIlD09DWDmCPGmEW/rF4gfJUI7TlQdgUue4OcYssUOZSMXH41Hy1dzUKq4aqHD1ZfGSWXcMNmslyzpiucoq4ot9WfcEZat8KNUPbwTeHX4stcEpinmo8sxOJi/wm3uY2DDOPXrJJtgG/hgOU8NvX0hawbSmgEuuOvDLKNW5x08UPWFXpDEKgMls3Oesq2Jxvm8GvJsJVchv4F50vKc0E4Q/4c+Vmi59bLIZ1PmD4J2/wkDJDfq4UrUZjPigMvGJIFiUWT0CCcdBCXZbT4HAhq/SBgd1XtYtjVbeppkf2IuC+4es0w8Cj2/XIV9QSz9iEsaQQwUh75c+vFP4ZScBGwIoEbKfhas3BivixmmUuZawYx8BsSUlEzhGNCf6xDGzsNZpKAIoVvyXq/WZ3YzIoOskQcyPhZ+39A6oEilbQ7AoDh9JnCp1B0H90jCsblfmG9Aex0uz0BEc6wxL3dp5+SOOEtZ4La6U5qd+nvcwb/Nm0jZXWxIXTfO9pxrI+0i6EBjUxwif0=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "qTNv7KL5swdsK+1SJnwBOrkz47yEQFBZ4ksTfbEczDkmi6gz4Cdkq86+dbkVaypPjqbqQ9YxarEkgiSYNypzDWE0oJwp9VjrwvIOgDY+QsUlMJbMKF5XBx83f8GzfthidsDnZ3wpff7dMJyzLII5MrcsqH543Avv2WB7VDVhc62T/QkVtlfiqexVEl5SZH1g98oQNfooUGAQH88RBuf564TJnZWDklyIeuryKMW0RrtWIajN4hNh7HH5jxEBM8TFhcbkY4iQ9GeasvWWnnUgNPV8OKFowZryDHhVRFStlFkhnJAXIlEpteo4VGb/CxWHo516+hnWbixicnIv1qd4vwdPTSBBDDHK5w0OhTYaNP0jHjgs2Tkr6dRxv+F481pvxYT3hcj69Fh5bFa4DO8XxtFvbhNhP6/AMfWcZ4fxYn4XiToFmvMYa7Q3JP5A4UTeOEBeEL3LWgP//wAn4qmlj2dH5jUYZjSk+CNZeMuyXrxKklbaKP3Bjd6RYeAm0Rgp1in1MgUMd1ScQ1ic3SPjv1tdTfj2MVmJDvXCJKJ2t2oQerCo8nY/rhN95Y67OihL8LkAq4Jz2DRDgCm+TTo3x9g1WcBsO6D/m9dBihLLnfdkZFWhc1UBLda4mkqEs828B7q1QlFe7Z4EJV3KVgEkS4Zd19hmvnFeZ1H6+G2mkfc=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "Vrv+Iy0EgV/MwSzu1iMODl/SQ6ORy26sCwQNuG/4Zeub5pD9STOwRuZGpXC2IM7HutAHkJDWApfpTDkd4sH9HgwWmwWdNTHz2P+UY7GhjrWsAUBz5BtisvT0dRMNIhN+NCgTtMK1wHhSqYki8FP6ZgHcS9XfMS6aqoNbKqYDVfbcKblSzXkY/002JnXFJibD+TnPSzOsY9khh71zwDSFr/93V//p16uGVS23OVBLyK8gCVQsZ7fAJNVntXByqaRAEo9QeLfQisjJUfSgvAYgvEAtcJ1i1ncsfXGLlL12OFaAFJGxtNVXDywDDKLKxMAUPl1QI0BSmS/MkBDzabiOTciZhh8mer++5OkT/OtoXSI+dROhI1F6bsCS3jWPeFMehJ8iOJESOHqKiNAE1rxxVI48q2UsggyBU+Qu0fDiV9FMz7QIw2afyIAG9XDp6/sapjSBoKyUy4t2IRl+HlTpnV4x/SdIcnNbZck4nQqGsCgF7Z0Lx5Q8Ye5fMmAVBI0iHFucAr5D9FK6/V2SHKwENDOc7nq8z29xqHdXG5NqeZqQAd+KT7Imnr0CicKc8C12Ysu3eFKs6LoSPjKJZqWUMZxTJ+lMsfxCqrgNzRbJ8n1fZAGvtQrI8fsGZ8hqvI7Jcg5fFNOa2wNr2EcbvtI6pIjyXxu/uJixdUUxq5/cGro=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "vjT2h52Ib4dOMBIaXsFxgfWCD14BA7XuaasMsvAeVXtpGFWbdIc7juHcSG22nzRUvSFpJyEFwzkSIoBfyVf6smJ14k2Ns+iOMAM5g/gHzAE5lpCoX+1vxQhutxFr0/VYKy9Y51u5Qp0DBnBHQn08f6zJWeULbvN7CW6PiEfCi9HFXGlPWI1jS4YbM/N7C1JqGA2kLS9JCHjdGKoMXrsvKaqurBhiQGa9mD7zs6g8EumSZcnXldVy+BRClFzidCsCZihZu3RDleEhW0jZDCmj7tvhJcleUL2FfqatI2QghgdOkJEzv3oaUqbRwI6f8klb6Lz/US8ucSl77t9xBhwOROA9W9gB732mpADUQrv9KO1BXJwJ64YKouRA4JwAGGRd4rfuvsxR6JXVvd7SdccW/tsLxQurpsmFUBrO1jIt85kImnYpSCdlzXNduLinx9psYVK+b369CP5CYnWYveMhSQRV3A5XoiyvEuW6iKYHicYnteKoN01OVscvR5iQVBpmYaZzO4QrEAAHTT40BH4Ai8pFmt/1lOYpHSzMfajIGcxw/f5pmip2KvhjJ/U7mr5uc7R46JjAFRz7DJZvvp3sQS0QhZ0TlF4TpqUVboM7jludKc6K4oUbB9vlpgPOTJKBDU3m/cwD3vluIQXJB5RyO5UtlijyHYUjSzNcScyeq8g=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "xhl7MsNHXUzFPNXxt/KOI6AIaFbs6QlySawLASdYScVnBDmVK//10EMAelwuN/macRLa53khIzeq6GdR2I7eYuqbBn9vKX6bdPqHwjY7Bq/fbmFKUBFbB69yDJeI8jVu3stMQ1Sv2Bkao5By1vvdVhOFtsvaRlYKGFEHBZ5UhgRDCzVtOJE5eqRxt5MjT/W3X6/8AL9jVZ7r9Q/bSo8vBJaypzgsJOfpIyAWk5qnMDZ2miexbCH75PukLDdt5hK2EsiyilYRWMvLO4vr2IA/RktLsgJmfqbPflOD72TQ2kLMxoBC4PLDXpESu4Xl3BTZrG+DRvvsHBVrYod+KadieIZnUci7pnlQiI2J63OiZJW9izZsPhUDH8Oy/ZWxAJAi+zRCh2ZyTDelC0ykjkgyaHUn+hzl8deVSKRoMpCwHB5e/XoJvVAw9A1rljdom8u01xGPgMYc0iitLO5e9wsqUhVrhCTqUXAoZyz1L0Uib/JUhS3XQAiRGh2adjEhDubwVH5vNVkqclijjSFGtMLrelGbZFcKWP4k7GJcdwlbWNgOsOUkFYHB4myERBhQzFbm9iw3wVo9tnDmqmPe1vSfDyF9wpMfsryS0RMMC284kAqXzMuHFXHzYujRMuYBNQ5dPhjKaD8KVwWYH/M124gXQXwkWWAFcXrZtHdi9wFtGRk=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "HWA5bFNMeO69H5+R3efkyZbzIb3CtHXW5WHnXhtZBX6sBTH04Cn5PHFfydKOjmyIYXqRQfoW8rx2bmh+qQQ3GPg/RJvScsCLwYhfL1IuXEoAAZFLVQjFCA/jddUBUM7xmPMBLonxz4ctB/T+sJfmDJ+2fMOqsuGvPodfcFflHt0p1qKpvnfg675ijbxO0zkb6ZT3jQawyTuTNhXTVRG6dhdCa35+1RHqWBFMbWdBoX7dpVM5vbQ+DjOvzht7pSHiv5rXpyy6TbtXmhHRzEuznutmCYVx1i5Wg7lqoqqGuwK1Y7DGYSRZo21cm3PKTJgNg/XUp1AL8YlJzHHkOtGZwXH+eJC0cg7TDw4KtFGRwOdFEOFxjG6ikeAy2mhXCgJBR+xVagHI6wxEGtNhu7S6eOWpeCS0uuFUrHL+f+i3twD33Cf7AXYBPFt9UizNw63RE0xQyY1pm9SpNRvYdICXSLPbR2b3W+vDykci6hNDklSO8rWYbFR+SPju3qBQbN3/m1KKqdmUa2MuD7rwAe9zcNQ8rerSMrjeODeRDx+Ol/G5U/l0hvuTJX6Gh80eK0S5qDMsBQF4sE4Oz8dQov3/Y38nAeJdz62cyS5u+r8zhE2Ici8X9ERTEMi32uGYfAkrx1HzrkLpkmXq0M+us+DI2ahLv+HE9FwuJcNCHMv3m7o=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "FTV4T5ZQXxhf5NkRCmD+6PrDgvCPf9e5dHbBEt3ZKD1aUjlx21U3KW6nv61lJ4DrG9woXlFfSd9HEP/viPZ48p173mR4/WTJiuVaMB6M7kRGTGhA+ZNq6RWFEj0mqCuPNtma45gUzDvklJDDO09eEQfatNMHQo2F/1oEpbfZyuI1Euxi1JnjAmMNMBJzkzsltDPdBafxy+ZGqdaQp4+9f5z4gi6AVmbu0zxGbu2Fa8KjgCUllvCQfgOBcq3o59BTtvvpYqSnR5z00rq+HPVxbiqqPxLL8ZO111oSfzSUPQ9OFnjWK1wx4eBIesxa42wyWTvXXR8QF5t2wOjCtNfhRjRfWAJOuVgBD8+PceqceRLqIMySeCmKUTlLQInrZIPp6ZBsexqFKQKCyuMCP79QA294gB8Oy6Bui5+NuWhsK+upCu2TxXhb8/Uqj8aPKWLkOwS0BVeRfwDmDebkN0XEOgVO99uxlxALj1Clkz9fBM4RbVfecGcn8y2txbAejanWTNsN9ifK6lA5NO/dFGsOkZXmFm2IxWTzL0r52HyxzUxeBIk3OnfijQpWbyRsWrqYw/uNEIYBFxu7O0VxSwvQLjl4fmj3XglKUrq2siLeQk3eXOx64RLyZ6uXeUbTn6bBcUN6iGHO9UhMPJFezvcqIWqXoCIM+/My4/7sDoYACLg=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "yKR6+Od3PLRVh7ubg7dIFIVWXCCQdRvKA72C7giF72cKNPzd9MhiGRQM7xEwG8XnQGwtfVTcOwLdLfXJK4ZDy8iuIxQxoAiG7/+p9X+/W/My2duUvaaiMBFStdvMPKv0guEJlasoVqI8g1GJZHen6ZNbhEZMh+VlOgDbWOPwMiYnxP+13lJ0l4AkuK449+rP4iATgVYCPBAhV9+H2EPYuNOkXtkukJem6agQAlqXvnv4WwZc8bhukVKqy7WAzYTzJfQzH/XeN3r5wVBbwwiOn0r2L1T9PDLBiTYcRxbCoN9Q3oxVwk8sBFh3mc/LlnOW7pwlME2xDHY5lfUVOq8/lNhFMomS8hkSIS53TKshxoa09vQNPR2WJJat5gVLTYGGOXYWDXFfALGmpHstsxHIxg1K4FnO1FSXz/5k9ZxL9JSgyW8Y8u+0ihkID8+Hef8Gtid1eK3kVsTp/Z541K+BB5lnSiRrnUlonVkns+5oN1Ep0gqjq0dQ1i2e4GtSX+CGzB7sXysAIxzqtHwbL4/cQVbSljFgqP/Agm4pWUpR7FwcrwVCpYLZMPTCV4C3mMvZN2EYdhRABpX2pmwoDj+TX/gnMzRO+E7yetTk9ntnakVcCNzIPt3Zhd55q8NDxrcYY79A8a65aEnYw7NTfB3HTx6wKLAgqO7B6D1d5hAK/DY="
          ]
        ),
        "👋": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "fUrZJy3RZm2QJvCLDOMTiU6P99iFZ34k3GhaRSWb/83WdDerMZuN9nG/BB26YNlcU4oUkuH42mP0sBGVCppFd1W6XBUnPub5jIeT5XpHxdEnZsfx/UJlR0Y3pCUKYaUYhSrl0nJEVKnn+exqKn0ij/6lJm3y2syXsgHd4GjLnGVPaAUU08G5BnueoVaYrmh2Dwi0TRmLTMIvti3U52YhhDsSVa2jbeAbCz4dJiBUH08hqXWnTw7toBcXIhrNDmnuTGU1M/nYQg9JH/2Wn5VhGokPyLaDEGn1R2wlJJokriO52h3U63wH8GwJL2lBl4eC7btx8uEQcXjJvRQ927fNXxVMdSXacaikW+sYjzvqYcN36XVIHRDpIpZcXEU0EFNo8lmuP2LoTnCCoI8aErMc+ua08XyQHjKWBqga++XFyvJyuJEl4DeamtNUrkCVdPDYs58VYw/HzbjR67f4btRUWR3uch/Azz2mxXtUGI62uTCuKAv2TZva2ILvkGhJC2CcJNg8CYP4UqwHA0v+GIwipyoGm0anNuqf3rz9Gn1TDv9Eg6PXP11oDPvhCapvlFW4vOkO4hqQSashgNOVEEm1sjplhql2+8LRQZJuOgrp7JNnSeF/E0EaVGVy+16eF+kdBix0q4C0U9CrSGYep32zOIriMKrvw2h4tyCEalvPcWg=",
            "algid:encrypt:RSA:PKCS1": "bW44iL5XzS3N3CU6SySet1aDMEVLYJvQoYflPrn4eE2ABE5/eurhdHIU1yh99zriAiWlhmDagmEKOQMroxhTRz+SKi+IDUV8Y3c2DIAi/LGFgzkBdvdiLmso9bxD7kq3w+ZDq+8ft6ETHUMibYPqtzIqQ58Ob3MgDxQqLsIFtY2iHWsJNylqkmEZVcNC4f9j+3FVkYgx396MizR/2p5WDHkO+bsJvKs9Kkmn2j5jFn4344VYXJFYf2vCtl6EEavfdklbtJGlsbXTZ5v7BfPI1CA9tLpnNhDQ5KvyBoiM8+iH1yJ4bdIT+diB5z39BE9EokYC7dCDczaW+Y/KK+xfu6DY1ht0B/DgiX30O7RF86tPVB6ZOHv9arhHx/GsY/bYDjQdl31pcIQ6RNuYxu4fM8RK8ig38zYvK7p8QoqTs/xQUkfij7JUU/MqDhWr1Syk/tM9ecauryUFh2hx8bT8ON83oCDq0R8EQcM31/nNz5NdGEnYVgrj+KI6olBUkfdHZ5Lrday7XOZA9OPUs0uvnhBgoVkIyGZR7MWZNOGBiz3LFEaQPIeEoR82o6u3CNuXLBi+Zm60gxooESne2XJLLTkkX1NAQJ7MUhBIPzZDVBqjBvsTVB/McoG/2iqNP9wHdBepyGJ9cVgvXb8pVjuh32giQt6IgYMtkJkdutvyy3c="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "RVfn/YLUJklmoAOwcNWO0EUOz0JlsbOXuIaTZ0E8Bvrcxc3QRzDgOo8esS468MkIG4L4iwEPpq9mkSqbz/Cua/MFkrZrcoiKrj5RMqvNsjExVOcAfW9I+keHzzEN2ymRobM7OsbO+bovlaXPe/APu4YW+rSvpBhHRzBchVtaHdzFhrraV7tGrJZeduq5CV/Sw1eTXP/JqStqFVEssib6fSKvks13yiaWBfGEdwjkSMVQpD5f9iPeKEpATGPT9D7rolWGPMN3pocI9DVnOQjY7jPD91G2M/N6onAfR3nH/HbH01HOGkpu+DJGqaCB8hgFMhwrhvRRtw1tsBlVAU0IFJfoX9kinpcpgY5U8YYkj2SQEKB9GMVEn9bVPaoiixy14y+HQocot8O9Lb6TJM/q/uI+yJ8X2nyU9NGy1q0HNWs7xH10FF8JCHcRDZHiCihtv6cVmst6gsKFMe5c502hHsdqk5pDmjeqgwm7Rnd3cRS8VD/Rxzl5y9MJw3APBQF1dqUto/QehLswh47uB+VlaR6KkUBPwWJGzKkstAjTUDUbmGO5wgG6EMP+7MoZbOVUa0xjk0uNUVstQs8HQ7ncS8+HC6dnoUTlFjF0GY9oNOi7KJNwqwmeBHin26sBruo/rN3lPF1ENT0TpHGaReK/amFtIY3wgdg9UI74/qug9uY=",
            "algid:sign:RSA:digest-PKCS1v15": "eC1NYUeo3mCJcKJqcuQRl8i66Ykdy6NGQAgJNgsftcaX/BY5+W1em1LDNVFagmy7Y3Um6LjkCRbqdggAWH0iE0DS7NJLFX7EfEf+r7n0bi5DjPsjA2dktof6os86jke1/kfKkwBJVQ/FbzBjvVxrq5cCft0wwGQvTagD1wwF59+IYQFUDJv7nC17xwpk2ctPXoM2RfWlWPwmhQKxFrBPVrE6vng3Nr9SwYceS+CCeaIdWdg7it5Md6ARrUaHOqubsN5xMszH4pysPwrTX+ndY2PLqorhOB3+m8mSzXWVC2VGYv96aGuNO1ihUY0/vhvsOn1btMr/O8Uk+gLduh8WbNdtYXik7dFrXhcOtmpOWhFKg+MVwDgcvWje9tbESB/H7u+wyB/0qaxA9ZrY0cjurut1VP9GIJHG0BmooHWfQtrqBlsLFhGhklSHuomjq3KjmFEEtVWC+xfEyrnGFS+YVZvO6CqAGd5wHLlAjWru23tPv22EXjA9I5h6LjQjmRB81KpAvXsKb+3GB8YA9v0jIERWzgXJ5Ip/+a65rOpmSLwfmRLPjw9G10PjAZEBrhIAjTUZhQFu0Ito+MfVxpiwPF/k5WCuhNqntePK0fwqywvQmzsRoO3ZNbhaY9vehytB0CyqVzigXfdYHRvAwC4RJ2q+VWevPYiB6utFWzcR/a8=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "gmXFm7eKWN7eIt1IvCKBwQR1rhQCZH9KHqBwHOBfVijT4pM6l7ccgucimxX0RtH/51pQblviLhFFCTMAz+Wle5aPtda2zC1U9y6mO3ytsQcJ35u//dggkO/UILESfHDkadIeQM3usxaLK5GqBgxKCg5S2ivk/m8Qi4YSOgSV44g3cAOkdnwsfiKR3CFj2gO6l3aW2tIhDHSgds4v6hqhs0qLU6xLZWUQX8RDCkVapTEZjB0df877HFiIINUMaWRpo1y+nIwaNJ+X6es1gTMsBnlogCJ69aKFhkT/ryiA0VTlyfpP/ndJXbzEvbt3U4fSBrp+jR7A6/t/OJxm5sCrGyYfeW/UmSa1xh6vUY6XCCEgrdmVyqQ8hbaC3BPKt3tDM5CFRF8SljJcLptOS/sJZMGEx+tispZ9S8KqGAqUWV2CVYT+cqHUXSH/4E8zeAuvnT9pePEZaE29P7nLYOBZul6wW2wNv+H9J8fMXlJKeM3cPYFF6X334GRvhQbomoHUm8hWMsVEvrGE6IH6HVxU6nYu3EphmLuuigBqusMa+g2LpYPGNZEE0sz8MJRi0ygAKFrMTlkGqZLGC//oOqcSIb3trTGSB30+XPEXdq0gxtY/FLmGQTpSU1McIVU5ZoCn68nzSwR9L2w2IgcDE6tfLXLj8u+4z18AwzP7buKpeFE=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "GOk+2sarqkyWvSNVN4Thu2yfOmfWiHr9Mb9xPoYzgGutdqaAaD5fvHLezw0QW2QVVKO9mHZ8yShtOouioKsMWEjKXzxw+plLfWyAtvuwSapcm6ImWl5+iCi00Wt2UyBCMn+jJhzSSupFK/QZEV//pqmy9EkRBGAtXjlUOk0XqMnksUGQ5h4F6SyTIJ131Xt9cgzVN5h0/rIcoxniFQ88mq9FDiKaL9Yt9zJhengGEK60vl3Fpu5HL3PMxg48vdlOI1M4GWN96AJdc/BgE0rXlyGnEEE3Q5y6UetZ5l5dxTJKVtpQNTAUwVatLnshlBNJjYN7bldELEVdfVj3l09HIZYOVjAiCWjlPrH7JhfgVm2J1hYDEdj105yAotl4s2Fk9P8fYPfE3tZyOqKTaGxDtEINMdMPjzqcFPwKpazIoShSNFMyTu9xudonSwZk8HNi3XRhp7iX2cu1eoJ4enAkm+ORSwLwRFGR1E5CVLhTZ83gvultGEdef0fbzJyM9UGDk1sq4vlUPbNXz55sAGBoCPOOV8Wfw7h/tfzsJ6s9W2u64141s8fs5gVHqwqCGJ/L9HsSx6HSYSDFaLYu4sm0NS+6lcs/lzN3ffFV3dfTJOY1x4a2+gjPU03eKdv/YoZtzijEM04TjLPzf6eAr7/F0WmmzzdycBCEZl9eg4Cyowo=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "iZPHmN7uK8r2jVkUmBdqJsgPnLbAQd9HwNErF8hnHowHS/W4tCcFmYODh20hIIok00b9Z4BGOlfs6FPqYL+cBctASqHR8FA1wD/ZitY0pfo/4UEOkM0qFuqAJ6iKIyQq0LAzlZ14o0wmpw+36fFEW7xK9zXq4AL37MjKn/OmuFSR6Tz3Tn08jkU/pfONP/YGdC/pQe55PdVxL8c1hjViZQVNoJbZDSieHrwI/wycJFvihJAFsFsdY8sa02SNqTPsBtWTlByOD3C1+WX6IZoYxKQELEw30jMQJjs2KU5eG/f0e0iwN653cm8fGw3AjPtN1CXLGDEl/gdSwHfX23972R+TZi9QkvCqXg6N3xVhXZBSj7RzI+tR1y3MFJXSqUOHgu2Vge7SSey4HVCFymExCVChWDwy7cxm3frV5rSBrWpOTJrSDI27TaB0WcC+wGGrmFavzHO5HsXeJwjUMr8wAVj5p0jnm2i+qwduThmbgMgQCPK/nG+FqGKBLA+VtFDrk4zQ3WFhCUPHhb1GKBJiJqMRGXzs/IpQGSmpFKj1J1AFZ5PSAezrCh28lVDStvt5h9JfzXmMJcT9SWQIfLmK38v53D9G8UcaWD6F0XLiEqWHaC6RhVYcpi0IGIwea6jBEKwIOpauQqE7dgT3iHM7/N/nwrjW8hQfA6bNy/d2Z/k=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "MHWI/4we5lib51UOVvjIir0UGAv0wyVZnsWuE0NK643XvVGpgtxmwUwjKDZ8V2Xt1aeg8sfw/iN47nl9y0lscoH3ZFPLc33hykz4KdI9zLTyXEYptpUcdabF0SAhd35l33zo43EG1S48bVL4hPZAJVGItok/hS/DtmhXgZbZuu5kLJf/VoCEawYb6n/dgk8e9dR9GKhiFpAkgF6TZlfk7fg1due2OmcDzQ3NZZo2PQljGj7jCjBJ/CEBqS/QOgVdRquRoRVoIFyaJlVEbHHv/+E68bBhMMQvq0qbKWsvEJdJLTWWHSMhIziINWHNEXaNuoxd5SkzfRVfoZc+Zi3gC4XK2/1lMWvKYMlNgoh0IuVOJBMjIMxaW6YwtkLTkP8rAtQzCvy4VbyB5Fiz1S9rcOe9AD2TQX7dF3S0qJ2CMJWG738HK0usb9pY5q7XIzqUCvK/geOf6/UNv8Cal+hJCKU+NwktlHHGRcMmZ/HTFgiKZAWCClTfmEDhK8wFnR8N5tCUXCM8zy7EbvNYnxFMxo6Mj3Eoeo3YkXvGkjIKen4YE9NYm7VzDRGRwxKiU3OH86yJdGZE0e59sOuppMR0jUMrq/I3fmq25Bwdg7RMtwhwsh3aOc6afZw/6Q1VSZ4Q4eU2unjlYtZ6BeZJcIwiplZfYzuI9n4oj5IsfNpcRH8=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "Jv8LKcl80B0/1slYYDryZDHKq2rLYVdmJfef993gM9G1EqfjZgXxtmgY/gjhSk9ZK8PfqnXbd9r+xtHBfyqCTLg4ApypQa1ir0dHzvOZsyaj/fhILG/C1pFMnVaIyFmUgU2N3sgtFJz3tbROwiwfL7sLt9EcIFSIRYLAuYVI8Mq8kTRv4VJYgtZBQXh3dc7sbtNGdeNuvT7GasBe6yzNwC5mDwhBaAb4B5POpzruyf9ICV1C3RrVJuG9Jujod7MWIh/dQir13OPgG+zFCpwLg/MFLK2pI2m3kzXsUxh4QqJ48F9LXHDy3i0R0uWYGNdl4wdIrM1cgYugksFSgmaBn394C/nL6dPtMRhAxUTUJehcw3oFeeTWWUx80G2BypgcbootMFnOEZeJO68qp/r8J8ffw2T3npuLRl6V2sbXCErBvq9tYdkR2z3DapGRVhE1q7g73OhJMveOkLwsrjR5Fr2sjB2+utO8L55RAnSLqOPKxX9mT+Mjevjwk9uGbxI8YTQ6we9pEwQUJ/l7IWakIJiVfrg3Zq9WAP8aLnku9gmhciSawNZpe6LGqdzBwwW3g6lscUceHpQ+yStLQOzpmrYDZRrjr0Z1TaRfgmHEJajLCK2/FKR1YpN0GxIkj8LU4tjT+1BDM0DqNhDXe7BNHpG5UeR5xifMJU2+r1avf44=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "LUGycQCpRNBvCSwTblYZMR0E9enq7mpTh9q/6OQYyP+bfry/BycWa39ChzR4JGOLPUAyCVuVSHRw0+14u8DtVICdy7rtxCjSsDBtgpfxNmRP2OTWjv+Si0W/+/rj1eKxLOi+3T1IJUx5cRxK3aC3UcmBQAOgbbcJKwmlFV6oeiPi2po6MsyqmQu5WcgY1BQtDcrmNP+1wBjHapHwxr/9cfWK7LzshqBM7ZwpF4/57aSpDa1XS03aubh38rgfO0QeYo6/0btRse2ZTjOywYSqI2Aod6YwXpp0fhfGEH4RNANDWaMUsFVlDjweWde1V3QWMFDdVHrnzguvqJ/rHRbAxUkenQgCpWcMnEP/Z8i/81gwwKAMuGo9eEkfFW1rfwOvL2z2N3AdVOknjR6tSqJmuqejRqktf6U1qZ1rUxMFRgYJpA0rHTJItsRdX6030HRROopGK5/IgGL+0/B4HPVPMUm7ulJ9et+Kk0enpt9cIDaHggL5h8DTGxKaFXFgf1A8kf50+rhD2g5vArFl6WjsJiZHhI8VL/NBgkPGKU/2a6DrxTcDZL5YhKSJu5v4QTCvviAT7sginkyZxB4XvXwAJtJr++cNkHGkFLuFGb2x549zeRitu2ZjNLYtYDBRTz1/EmL1AWGX675gauk9ajm52Oixr5ztEXfUIkVIlqEeIV8=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "a8saObW4HZ11Eg7sle9NPqXT20Q/LEJzaZezkokoEOVliFec3eYzPFF+rMrbLcOB9pBhye/gQ9ybbzR4O43YkxgBjt0R8k65v+gbklT82w7wLzKqS4wi782wroyO3KdHYX/InWGJ6COhptuHTJKRnl9O5rS7U+uBgIb3sf5TgT9rN192ltNlcYG4963FPf0fJSdgiO56Q3Q+WFKP1R8ix6VJLt9kT9VLdhyZSHKRocIB+bNY3JlVtczjCzFMadBPG5ZeWt+YhfvcQfWxDkqa39li4/NRJwcelN2nwIJ2kdr6rg1hQ41OtycesPnSOXWDmOdYDVCeddNpLos+0CenHFY8roQoAmA/5LSRce4G00b58kjFlqDuPt2g7BcjKghJ0LjAt0nTjBS6dprqImvSmqjMa844RqkT86O4kbfPJR1C7wEeB8EyRqv4ExeZTNU4PRDCRruBnVNTSVBqOMGwdAD9xCxuHPkasa+IKZdTShD0Zxc8iMSzBqT/9hp+P6t2IRPLv4G9ZZHw+tTGqYKjGKL2G0o2VjBhrEjnVzP4DFEWj0FOl/h2hB7z30k7d8dKEx/xvOkTCe2i0fDPzlPBeKPXj1IRAuyeIwd8aWOiRpZrd5ROJ6st/oJRc6BLizz5zstprkcQFvJlbtYlM2Dot1uLyb4JuW/G+j7torMQqKM=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "Qi7nNlTs5/zKpyStJWd/iHqCPjdWJmUtYG9peQXWVtnfvYtZmetLjxXwBbQLKroeVef3BN/iiScEUwH1Sb+14iXBI7pvs4BsFvj52aCzUOKmEBH1F6sms2Q+OVTABSBbBgsmD8aONN/VuCog+Mi2T9QOUh9Z9TzsPcvLeo4GtMQIeS+x8+BKhY3arcMMKlLShfEp1zysa5VOnQaX7bs0suUU2Pq3ceRGe2c5rTfgnIh7md5A5LNZAi/h/xsYQcMB6iiRWGUGIIPKwlJfL0Waskyhx6nwiVSyPyUUbrTmelTTFM8bgfPiaSFWlXXIS3dGNUzaIMdCfwXkv0M5mdoFvi+VkM2JP6GwXg9rxv+d3MTHrRxdC709MxQeLTldfkX+Z1YRIgUaDa3gQBRXOnD0l2aotm0XpjQw4HwW//P6rLg2VYbZphbu9EYornucZvtXmLwui957E1CELkEC5fk0yq8s46phEKGm9yL80sbeWOmoUvVvb1aUr8SR3iqFm/iEYvV4xCKM5A+H2YJO5V59Vdl/iv1PkdGBIcQCCeqLq/KQzcgdE3s91WCFZFGt/ngxjhyLivdFvVIjiv+VHxtYZGGWzoFWTM2H+VPzwIkYMRAa7w32FAxb5vgJGp2eq5oNPVcVp4zhPIaQYV9KV39O9ggoj8zcWdTutMtPNox0QIQ=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "FQivNy4acd5UVjlgtMJDtvid1DVh2+LQ9kiOY0enDyF9Aoq0omhtiAhzr2fZ2jG4SWQ+En/3PxkDjnIzWsb9dY0lNXpmq2q4ekz/RwSt4r6699z/x49p6fg3X4rCt4AIzs40dlXL728gA3urPh6PmmtzmokvLv7wNE+pQZAaNUwPkEVy1GUNY0OHo2MF5L8KU95/FW+V5tctTxyA6WHwzLZ6nKeABVZzgIPpWpOCy4KVOLliT5dnyUutXuLMk/zyKWuzHMYX0V8IBTLaqS+zDAJ3bFe9mpXCRf50xTy6Kljt2ZxmOuxkfLFMoSTC+fOg/FiHjyoM5x1VDha/Bz+xCsoBXAVYvVg/2FjiJ1GJxKV0Gdvt271Ke5fEX1lsY8jNmvUGj7VwJtmdpldiD4RDTc/f50DvpZ913OaFloX3VSiz1/PHQQdFXfGhOiS0+1cnhBZRaCHVFZPpCllLfPmSKFVWMwo4ViTJdjSr1ZxNr3xoyt1zEnVYTzirHiPPDJM63XAMfVJ1D6PKpytrimAT2uN7BvENkraZ17cYlhanp2kRNop2IHMBhT77lcrwCuAvOsMrcQDNUthMnK/WDeuUfwIpaChm1tAzDAtaYAJV1qqvqgl8CkeSOF4+UibcpeQV+JzHzwZC6FwWbFsf7o8cfvN1P3ySFT6CDjTAnqmsONU=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "F54RyblfVaXJQJuaiHlGtPWGAlCtUKYPTENnM4JCA3lCbH8F4nlzp6+FYX0o851ZbOA4hW0n7E65Wub41wpPaB87XAunckjMeumb7xibpAQXVvmGqG8DuOGctQ/3/O4yiTU26cn9en6x5ahPUWk5mjUgOw2FumKcBADO/bQ8pyUC0qkwzWJvGk252qJpIS/2sJdrhZQw2gJ4BpgG+ZQPDzY6BKyOD0mp5QGI7ppGkskBRpGfuZmH4ncT+Q7dqu/RkpVLEq0ypMf+ig4OBEWq3Ez1pmSd5P6ZpVLtSJ4Vg88Z/y4qe5hOv7GHLYg41LVsc7gh8ZZQwaHYdn+7O+mBLvj6kh0tDAMSYx79vN9KEvT+CuOAeLeY6phPGttwkPjQPzMDBbMVZfVcobfMgM3tEH2ICIrHZIK6ydAYva4Ulw5KJ242+hnpYktwmEeCclufkpvpq6J8QsL61RLJCrkThNNdKpijCypuBGx4C/r0sPvUUez0JcZ1P63d8ZE0NBG7aTuHroH9IaXsg/fTz43ssLbnDP5lsE8VnWzoVBA6oi4kp25/l8onX0QiKtJ/mvxS2h7W/FZjUBVkpTS7Z3HYW9p7nbaozGJmPL+dWqqAb7CkBUwkJ9Q55dLOZ0uzI9GkKzv5FHpoV+NusN2z6r/ijIGor0midOYPHYIqhYMaCKE="
          ]
        ),
        "RSA Keys": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "LQy026ikurKFBYuLIuWMXy0u0gTOOd53n/tY+uuFwsbKLJoadbrLCLHgMjjANCv9hCWtq5KdyhckFT83cvdAsLxWDf/CQ92/gGtEFWVNl2k2GzEEvf6XAY0UVfk7i2qsfBgpfpebY55/npERHGuOnjsxzIMD9Qpcu8nMqls1CSGs/dtFbV+5NC1PtCKBhP11Fhr2a+SD854xBlP+wzJLb8V6gOc4n3VBA6DPPQYrfafK13x2LOmGYJ0jksB5I2N4yxJ4mWjqOhe0iezG3ZjGgXGrMrvIOjNg6Cfy4ft1onPbOqB2tcR7M8t2DbNOWA3AyFqhUV3nDuEfuUM9Gep2a6Bk484su1Mgz550rQV6XfvvWjcRWOJz7Lh3q6sJvFJmTwiKjZLggYIMZ1oD7mB0gqhJU3NxfyvNHjtdYxkDFvqy9yZTpnkEBlwOz5Q0EfqWWZTSprTDFJeQkPvv6/ZCki1ls3pMHuxAOQnrZ46vbr9eZ1hbkizfLoNW0zbuFfpA7iWD/lzfm6XIrXe+V/BSnT66A3WoYszhQ+7ru0czWZxWRJ0NdjBFt6rY7vJjra9X5lIICd5MWypTUFRh7C6AAl/fvOGui/cBm3VYc3V1iPNU1DJW0sicjtl4SVJx1em6JVv+uHH7X70mo+rWytvp9GsOM792Nr2shdYNAA7f0GY=",
            "algid:encrypt:RSA:PKCS1": "hsfWWoLjpeX+LnoyzPHZoonzL118Kb/T8SlRGobNtPolGRIYouJC9chvAZzT18EGd6yh/E2AAbI46lENl3YREWZhKcnKohSovpVVHsM6lVBVir7C65uK9wfKkZbiRRoc6pdL45rwUVCF2/ffGKJseYL7LOSqK/GZPZA5/n16zQ5yICnmbT5ogCxdsEQsKsBpes3rbe13/R7W0nQCaZEP0KZv53CHuNzyVmjGc8TK5bYqYOm/XwwuyBLUxvoEMfXnIu6JIyPCygiOW5nMKcfIMuq63v/RpBJ70f0qjNLMzsgr5uxxZBwXyFQO9/zAdQQpYNkrOQj9XDK+tEox02Zf5IKEgB8+27k0aHuZqDumCJDHSOzJww6jmAP421Xn/tdkqP5kcqZ1q/e7sMlsDpMLcLr++PUaZwYxCs8GO32R20krmkgu/pmo4/0xIr/HWRMDii+HSfr40fvSY9DKBgbMla4IwYGmhJXnxKQwkZ4+xdsCZ8MhPPlC5wiRYIsuPVTKqAwPxtS1obYQ1oUZgIuKSI/TPkLNLGrepbJRKVxupN11PO0GdjAWratbIkrVgaNc61N7tSYQI2ny5aE+fUz2re0luUapDwmA2PxvYIxke/5rqIZrPWw65bhjGQoFTcu4w0wr2q+uMJvoYpYH2v7Ptct9K8vGXQ4u7BKw9KQSvhY="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "xApxotkihJbaaP/UPBR/nn2nWv7t7cMqX1w3l3fn/+FblVM9pxet08Z5TuQk9uJMxBYeCR37rUDxeYaA4stZ7lKyOZdh86Joy3PMcX4H7FnvzkZEB6KbFmpif4MOJflCEt0V3NpOW/NY9rA43c1P8EDVUYmnmC4qD9gWUvuzDHccsUas4IgUje9wHPRjt15jp3YYORRj/RRib8vTzcD5rfhliS9dmAWu5f55CD/nc9M9UaIO25bjvqoMEgykg6qRAP/C2urxU5pVlptxQavCwx0762bZhOBSm+WpDmmOq218tVq3v5bk+xEgZYR6kQoS3kust2FiBPbRvqAHUvwpREJN8eY30Tbt2I8vSoa0YejkJ7I9+2nj/dJPqXWkkjqdQWLXm3zP7zqC69d8RGjjGnpbuPpKgB0oSOSDsSrazJtOWgyQsnqRgEsBZtHWdGMAEZWavcAdbJqkxAyK/JCy8J8r+k0RB4wOah1kZZZ6uZlj3JO/rEx8Cy7STqMQJOyRarwgkjo0CCL4qvREk9Tb+QsHNp/tbmSfNcB3AgoO7YHwSN7pTRf7TlXXopMthu6jlEThJOf5NeIRC5KGNDMexV4HuqL06HdRBveLBU4DDiE6Y0QVZdLEu8T5A097qHhl5zfsjW/VlvUFXsR2gy9Qo0mJrhO/HUhlDO0PNU1oER8=",
            "algid:sign:RSA:digest-PKCS1v15": "jDhhAD3SKdB9foLpSM/Y/+njoYIHzCs2ImlXRcHTlQZXV9dGejae/lcOzr147M3q6Kr95g5RLo7sBLOlw2MQS+toSAvPM0GrDZRJ5ZB3fEdHs0GcmYZEIfu+7h6TmU/Msbl3twloh70To/h7CykRjDxIolJx0sBCIzmn1pGDxuNJtaWf0FEnj/EvM0b9pixdN7b4fOxG6D7XTuq3ZEqWpxqC7pCZZzu9piuCKCaRUK/0nU4M6YGwPnI3Ndljkt0alIkfitmwBzjKwYo65rNfq02d8NFVZ5eRZhEUtfpTcqaV5Y0jSEM47MnL3kUYIVHjhYecLU126J7YlTdPTcOJ7gM8cMsrEUQAVCif+kfaeeOsR/cSej4yyQjQIvVP2kho1zJxlWX30sYoZipzoJcFdth5IEBRO2AS3ZCJWiEagDjClOPWSquX3XOa6QKjH/4aVVfdM5WlzdEIkNxeI8i04mpgtQnOOR2NXOy3HW8arz/+L2riVbf7GjWQ09lvg5h+mqXCIkUu7j0I9SsHahTk6bZQcxZJtblidFXOLQP5BKst7F9FGfAZmaFZXTRKNYyHf0mxpe3HNEEYGDepUJ686/FUfS/W7Qv4cEtFR/Blr2K7rwOeqZYX9Y77rSCN6XOM+KZn1oCk3XoIuGJ/tVaUs7qtHrAurRdo30e7oCI8TDM=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "SbLKflUrjcK7gX0CO2KY9E7A4/P61lsnjaGis/y+0sRjfcYVTx7gsR6yHLl9j/9e+2TcXdpS573pBLWAfgzHg0p0Fz62Apl7n/v1xM6FSxrIYNXIz8ol+yfwt6VuwpBcfRSwEcdVpNqW0wQ77RPVGWZKK2q+AB+4UJi7D7fJNnRvNx1b2rOrv464k3EGBnymfhnS3wbkYCWBtFMUcKqEn6jY0raqcTaZ0+GFOA3gWYR55qTWgO/PFwHhNAv1zW5P8TtSDMuWtnCNM/e6yx9npeOliPZdqMnmpI5cWadZufLsLu4p5SmKDHda0qDceDqYlc+b8I86jIJ5Q+WKJ66rqV4vKi5G3LisLLmiZkGpX47e8nS59RtUO8wDl1EBpikqsh71EUFfReKQ30n6mDPiE0Nc5q1fQ2LiTDqfWpWFvNLY7CZd7QqIPCPscdF+B0GqtR92cInm72sKKSkDIDJQJ3+IEizna5S62Fgva+rjKt1zILd3jprcKoO+HOvNeLaBrGc5FiGJD59zCgBKWdCu1WKQapuY9ccb3b99Ss+imkOz6qDcJp5EI+XSibLijCUCJBcgur0ZkyFxc42EPtahAk5hA4eXeFzB11FLSsPFdXoeJhwIcbelre93IOblUYfac+YK2V4qWO6Z+j2J+AMXHfRAbvQ+/+GHiW7B75mTFOk=",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "x7s2nhZgMkvI9/dauNvKO3BAkRivzmuc20t+rvjBTRiIzk6hx6CiDbNcaMtji2ZB26okDYeREaHz9QY+/5BiFO1Ub88pWMmP3lKCtnPwgiapOJgOHA7HIWZ3L8v240prf+HgoIvZYiMsuUNmCtExgG7+O2FsmsMXPZnTbugCgU6ieVRwXySWpWE9mcPvI+Kf64toyWIkEKPNT6x+ry4ucD7Qk5fbdlX9PBHzQljymUMqMVtXn76+TTew4GP9vf/JjxHs8M+2ugHMFSMamE0cBlghBd0lnpMLpY6DELX+zto5T2ypdywAXvSMPFqSj6lors2rJUvf2/iGnGlE97Bz6s2n+yWVer5mThUWbCsvzF2xZU3akVJ/tAhMvXnEO26QDFv6ERYytNoDCizBvsx2xn8FU2npmufXwSCcM/Htxrgn5uP5yfMjVt0R8VNbl2T3J9JxmqtlO9o34x0v46tyhGJsS5iRZqv57WKAuu6oHYTt7tedjyN+FZnvrURA78Uijg63VL1SoFVde2nXxaKDAjMg8/pvbgI35cCqiREHLGpR+M0aOtxUTZD/OtfZZHRc0Km+gOjJ1YJm8A5R1VpApVK85qEiSFtROsLpSsoncMBslJ46DQJTeup4/sJB6rtAVDMMYUIKc6dr8xZaI4pZ4Gsd4aaBB5ntKCI+fqdAqPA=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "OjqBix/b1jwp7jdfkdWlHE5dukr9cR2G9a/NJWWtp910Ct0lsuNq8KhFe0GywpDntDqowKaidDV4BBAS2SNTFREbKy2zS/W+po7DaTZOXK+9gsZDpNDU9C3+x/GT0qhZp6ooYLVRT3qNE4PMk+qggB0x+H22CLy+RmDX5Kue6WCit5PjEWdXO+drSahW5P80GOKKSlM46gjfW3mTx304fr+WJXesRlHEUeedTlhgl8SZl1e4eFeS+gUIkCjgDDwuPDaOhckJZxVIvfk4Xznp9mk9K99ZxwBW8T4fwYf6vATWXP0FOWLkGDmDZHT2MnnfS442/27Ipox1Zgi2XAFkMXAuFa0iLl4cw8j6boruC3FoWqJ2GEDFqQwY6J0NyGT/5tDOk0DrCpxk2wM6gq/kGwX5CbJYaTfyShhXlPVYG+OyJhedJRondns1My0oOeVdeVIpRfKnIcVEnihmsFfkryK6fh7A1O7JSrqzxmUYnvtDjuGZ3udYBXtN5rRfqo2XndbBvT+UxSZzgnlOJPgJ+uIID3Xd/kSqwrYZux3Ooe39VqVg++xm8cAIN0sdkF5FV50XGuXgnSAGF2GIHZtWcndBMMPKvC7/znW+wefjvjsL1Id3avXYEgCaDvcS1pRkhpKpSfmOKig5ttKKHKqDY7wz5R9S775jGByHLcgoiz0=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "ElprLAsYrMqVRuk6vydyrzQNOczfh2/udvt6qlTl9D67PjXnIz6Dl4MqwFqIo96H65pb2TAGXK4bCa5IcrnASmLb3wcIQzpNvbU+QeK/GXs7KRbBml5MgY4bBNbLm3KKBCEVQJqLAg+HsCgrwkrEzvp4mZ2MgD0CfrlW926hxDrcBKr0HpPoNmFRuwDS7UN3ro+c0T1T2YqPfNpsU/5gyi3oFQz05RpFdpSyS42lvflQr+lPZoWdfTL0tzvzXa+A8sdLJYyMC9d33a42Pgnhce1EoaP2q+qhOcQKnFTenVShwTMUOARIEz4o/8gO5u5pJ8pnz+vjs51DKPBSvgM/9uooVCIre5VDeRjnVgsWs3O2EJynip60dOqzncPPwXpPfXibV6+ko060mLrKyn3oU7Z6RM9ZEB/Q3nyuTG3R2ZT2MvlFZ8tPQzmSt7zUJWCJ+1DjsuDoVj15HOdlJLATOUFBZ5WlRO4wzHyDKRgRHxxsLfwnpDgKFUgarTLBnpqzyEuFxJdGMgPfqzEgterN9ojQfWHp0DlxWXrn2cf+uf2SDoLgeGcPd9zh/1JS4RMS/XHpA1KTPr9OrqpyS9OXVwTTWSEhWz+v+DJuvsvJwQm8O2GxukKG6u4Y9MnVtnTASI8cgTVNrQPHrt5KWHAS93Ge/mJMPMpjTPBQzCw3ZqA=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "ZfReBmsAM4vPICtGrKmUT0hhhyJUGlsrFh+ZUfKSHNSGiSHpCQMmQ2IgEnskqwFlCEwCB3Q18OHh1hjylQm5O+PgM+RdRVKGvEJTtkovueTr7ow3Vqa75PL+yPt8dgFxSVbZB+V9d+cOf436MwlJPS5qQjq2MQ43Wv7s8DTwo154z/a+NciC5sPCftbME4m4RXKpVUDDI81BGdzrwXWy8w/nMrOkoPFnu1a4t0IzaGILiMHRRFNOWxsIsdEjGdAtVF9rfqku9aSrbB6cLwflG24exBzvTuleKjN0nPeQytX8xNvsivGm06n4YqCCPIJ8ecirNyS9gzrjRl5zSp47bUt15XbFIitJSdOaLDmBRPqDDCS2vhAUIECiGYHaT0OfDs37wCmRo5mER7B0T0cakkR34ucK4/LlUXEjh/jQhT7aDJ0wxDxqXHrzDrFPtHX3EJQ8THn20/gy34z54giiwxcZ5mxEudSxv075vDwbT0Yd8RRX6B8BJK6Q4HSMIrP+RaAxRIPoMBBXBOXKBhqh51MXnBybilmYfaYn33m8sqVBSArc6XYc6Glhe9AdWS9WA5NMZeX8J20A3q8g60VUVPq/PNafjjNo1594TdSiOpmNIZhRekoC1YZe2R35MDEoD6c+bkvOmRr0d1qgtkgiD7hwKjYQkcs/ODOZJwqTac8=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "W+1k8WlZ2q62DuCW9rvu7O315mSeOyu5/jHrQOjwjFfkSmPTvvmBwtJvDGuK+NFbjyxF0gM0zXLaTwpGfSllDHNlizSmexl3+jb5PXjvj/Szr5Xn4HtmoeI4l3HCEDp8OQTCpbyDLF/KjUAUC/rB0ZHCbJ8LPy+53nkhAnOiz0YJIx3H/jrw1bZnSBiJvBQs/ekOEvDEJsYAFUdRSayrfcELujARk7t6OZ5E4uO2hASDfqLT3A4hhw8oiz2IcqaRqAWQx7N3CSXIHveZb0KT400r3554kGvJ8UEh5ia2OJxTt1Tw44x+1h+b6iSA4uaCUTan44HDCNzLpBwPeinkwvFaDsKyKsT6eO8XePq+SeRpK6ZB2KFoEG3XB646tI1HmbNiC7XfVCclQe3+osjWRkG20hSa7ollaUI7lDMkCQHATpIBJ4v6FYlfK5OoUQxHQqKUUMur1uoMt101fyrPfWe1cIdEF2UnBTsX1jE6W8dE2yMPLux72JsUsqprBEFdaw6gcm4zgRsJ8V22MMAQ9K9BtyapkmfwIvMYcol//GR/kBCo3I1wfLc7JeBDSr1aYFyq4w0cvW+eEdGRsCeUbrgAXZ4DIaBMyf5wmHT5G07ehk2P2iP7/I7bvydHxgvmm7tglfqWYjCxxnqYjuxNzY5nl3jwHihFY/Lfx8nMgRc=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "UQkToUyUbNQELROez0WEf3cWJti+7sAhEWE488y6JQ2w2F9CImcWVTyezAzt+mUs+VpFEEDBswqO0Wvgsr4FnpHbAIqLGoTjajbYmRRqDey5vqTbG7bVgJeoNI7a8nyXoLfSH2be58fK8JB+HPPdMFHh/8ZK0rRwW73y1zoyXqNQpbWrEaTSwg88+AJ8PScc3jqVd6192LAM9c8IrFrfSsmWHJ7PcGHoxs5Q1UpBsFZLoBkcvTPacAU0jb1V3yG9eyDaU8Zy9T/cMrz0WsM27herQb9wAecJG3rVK4RZ6bwOd1uiSt2xcTg3v4FbYhEGNH8LDvPi1HEJKGFSnbz4Nd79I+WLXqE24gOUKqwpKBw1NPLPxKN125la6al1ToSZGBBZiyRbtGuMwBOgnPBlAsU+LnvLRCRilaAlN6TuNl8lixv/no1j4jf32FD5f+xfj7wlxLqaWkqQKx0UXkhEiTZ7lw5LaZwCQa06w9jV4F4Jewcn42TrLjQpik64eAyBNQHMBhEnGTMYCqWUYaPV+rYxEiViezqvJCeo307AFnHXgXXbnkQriaGANLpyMGP7GyvOk+VtfMEXQZ5OChb+0cp4Wn4u+scpvhmKvD2t7gZiiQhNBELeiMENc5E6LwpR13eoJjDQ4MHWjPQc/bAZfqH6WHAXyPMyVCjTYVKE+aA=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "eFmNictbH/gHOJ9z0CS1Iq2McAr+jli7DiCFA7w957H9DejodrntVkm2nua7NMKhR7abuwP+q4SQFSoDEp6rZsxn8VOhp0vidlojR52XNiTE8N+zV89Ir/H4bT7SxAKWt4njc71/DVlSug8PWdYw/CfD5uYPgTrhVkRsA0y060NuPb9V+b2LZrMCQFLm9F7qLOeJEdMM5gLErQFQzOJro28vwknqfyC/uywhj7yaJ0+2MlTxrxn2u/kXuqoDEAKLVOMRbYLiYgidsqdBJFs96kkSALWeWShSZsX4qfH8F3lE+PmiZyJ2wRfDRfX6TKpoPnFaaXx71GoO9zq9crxcb/mxqL5PeCgUCJiIolSFiOom4zx5ngw0qbzXx7UrSjEcJ/6OWdYfmhP2EirMRFOfY9G5cahJE2MeoFid4dA+nLJ2gvRYl88NIcB5ozmDRd1XCglfT4EBxC0UGbyQBzuFwAqgAOLAXvpm7HMuJUMHP/XYGg1RVC+886h6OBI6KTqijUql9PO9fChRui9JQM6gZl1/7y/UvT1ce2fpI7HxTw3zvJRHP30TKmGn12q4by9rCzWg5XE4/HJWD2ENy4KShlVEJF0n0iNpLInAiE3hcVHhcLaf4XZvqeSX6JjwEJD2umJsb3ev5OHJNdRy5A8x1DLv4uFNALITZ7XzEIlo+1M=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "EQi5aKYBmblsgS9IJ2SpcR5IQAE8pwd+E7gmL72bYGgarEADPRB1BZzrWjkTx2+g1HtXftedWBU3RcRaXdhv3iWa9mUXWMVjG6VNLvzBgUsyVMXTDIq9Q9xbTBR/jzxndTzfrTvvH7v52iNRpujoqzGibrZnVFDT6YB3xbx4h4pqKMA4kilmCz9WeQNTHUfXBoVYVvZ1RqzcoN2iJoU2f/bOjqxa/ZHNt5ZuIpIHrAkWkwCRv8y9nWf+BIEb/pSTUN5uapwo4fp2BzR1Db4SFhMEEocdkQvrgX2PUGHeZtwY9dOXAR9Y7qbjegahvXsI1kkHtCozI2O6yAUHVOZMmid6vXaTFT5E6C8OYfbHp9dqkLG+TGnRVpmAEo6FRP0MHbE5BocQkUMQlxYqzbrVBf8WMtNfghyWzqPQvv8sIVqoeZ/cuE8ywqwdWULK2Ldm+6tPXOtdvG330Sp7YgP5B2dQxzPoFXsWs9kkFfnwoSgOfR62GJ/+xrkoeWYXcvBlg/jTp/XsAD2o0nUtY+jzh27/ojZk+hm9qfSWKJgnBndULZym/Z5XKYZsui5icVUy9pUvJtPlcaJlht0xyGr7P8w6ubh82a+4iQ+vhq0Ayozg6ubCGvNpgY+Nm8pGzs+1EiIxmnmCTyq6rY1mlmWoZYRJBlZ4DowaCHzRNlBV97Y=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "RipJ0BWBSJ1nt4n9iGz9GZlBv2rjeZPJoxxqcVKVG+Jlee2Nx6ETP+sxdM92GN7bMGT15qMvY3L/3oNWGiP+7Oju4BmFCXHePozkAb94WFS5yvlVuci9ZsY8NAHFaEHi8kQoWohku7uZ4SJ5aCrVpYXOaZw8/5hpoRRAS058YE2chAf9h1xhtpL96wQlTawKxJIyPu7MnDDI7NkvOx2EnJl3E+kt4eGCwvt+He/E0GsYPrUIFsB4+onU7279CxcCsw0/tuP2WtLYFxGWGesjY8RklfrP0xjrRudMSP8s1zYhuzUhPIwefg+xpCkW6rJoTCFxiV40Myt9/PZIKovO7r5iFsa/jT/9o+QBd2v/4gKBT63h4mKPXriQEjn1zha3PlCT5tf1Kf+JnNZLufLcZ3zkenlbw4fQ53HTml2VCae4qruVV4IGo4B8oixucNkWeQN1167vFx8J0BfPAOeL57UFo1IdzM7TQmSm95aqvBke9tF4d6xWTAxMS1EYyyLa5FfL8FfSI1IJnFETyDwhP3IOaeMOw2sUt+iwMQiZwR+hAhQEi8FE1zhAQ6NOljoMEWT41YUbchQaBreC+quelIWraJJjWZ8QJbnMvmAodE/WqMRk1qg1iC6cTBJdzdrb4jSO/eOui1rhO9wyM6KIfeTBDaxbqPtWDWmvobSLwGY="
          ]
        ),
        "CryptoSwift RSA Keys!": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "JYqLmIFJR3fHQdqy9CQAsTkY6tE67vxkpkqnte9YY0vjVWGfDzX2s249PgRi6HhQIUhXI+++Awdo0bDewe5pcGXrCV/3322wu0vDlJFDpnvFC8mAH9m94pIh6CZ4jpGfdyz4+fbQOCZ5vLMWo36nRdXbZz4+dyBPvhlTzIO2cvpcA5ygBszIXhK4Z7LXyRNpcWxDCJKKD7xoLXHFa058y72XU23Qpyh3syXoc6lR7WOz4hWYwKJ4RtXg4yHcYNFuPCbR7glQNjPAMD9Apf/UvTFMGAgmFUhNt/qnRU/97uKGFMISJRvCVDxuynTDImnYWONx2u89RVlD0Yd3Tf2nIpfX5cLm2zmoLy7tJ8ZQOzi3nYcd6LOArwxDekQNkTVw9y9nYMas4EIGUOOr3OTC3RNK9Kt7a97L7OzY8R5+4rlXLjg0OuefkaAN4MlE+haTOtWICi3G0DuNnypqovCABnIVqRt5LgQZ6uY5ZtZbZDSyeIjQAiejlza3l0LReU+4sa77tvG4GkyCejULKAKVZczRH89q30dNVX8kqoxUNDnYICyfXwXss7XKLfF8AUCp1yx4yWzJHbw4Vq8kkw7M2ISgFQwF9vI89sjCZlqxtDfjSHNHz0vezOehtP1fs/P5re3E+q8YanhnJAg2VxXU0Xv5BdRk2j/CXy3dOtEMrLo=",
            "algid:encrypt:RSA:PKCS1": "uUT3t8NLWaZE/qCf9UaYUpCyQMkovESE8JfWnItU0uE6CD4NBTJK7d8kSdxBOeJL+vJBIqDkm3y7aCMEB6ah+QPRbh2NQFvPS/oilKE9YAcfZBa2V34bDCN+nr7N+p1UzVGPOdQeyXwh31/BbUZcZvNvQgNTspk9ZJ+5dEEnr6ACEipJIyjsH/pliP2kmfnC7KS92l33x0uT2sXsiFli8khqDCF5LObN3sGV3iCWwFyUU2nacW99HZ1SKkHryI/tfTGp+ficcUdjFxyb/Cj9RMJ113f7Cn3eCejXU2MLErXoB1GYSyWK9KccstUD4ohtCie225vQRxj0r60FlX8iiHD6ieEelPjT0cRqGNX7rmO5Tact0ldxhAQgoNOkmelMmOsjkJFwX/PaM20BLG/yr9WH8Rpp5eDlneKOE2zfQEwNQA8mYD3JAH/Xk1lx0ohZa1D8ZbJvbr75IPk/Cmf1DsbyvVeA646nKMMIzoloPU0Ux2PFVD0nu6O5Nkehnob8bkyPQ2kLNpxe2x08Nq8XsamZlHd+aMp91vzdbIb44ESzRX/JwCE/sw9NN6/focF6aVuVO+3syFUXLztvyre4QEw+lpmPDt2KCIGV23Gxw78g+nvBdLDjKlAnvtcjrELasD6VHuN/pJVzhx2n+DfHBbhjYt0KtNuRDdKMjSnjFJI="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "EuJuercZFslsiYtV9ynodBp3ov4AiE8W2dzMUJf62HeDyGANOEfRskUGzN0Iz7R/RwxfoiYEAKm7jzU7zWZUu/3toRfYkJzLE1V2+q8XM3DLUejWtfg4fTypBjg0gb8lZkxv9O1EZfwAEc/QHrDbHO+UL4ZPOkGPpBi6nI9m/ri6akumahYtt9uYPo6xQRmEd+1asIFmu6AgFR17L/wjRmY21UOMs3sUcSeA9klFXVBZszl+zF/abiROkrhA14wf9Q08Snj2BQwzrjjzpW1qlD1iDkd4gUJwL6kTc2r6NK1BLWF4PJ3yfH50Cf7cf9eHfPTFcROwuxFEVZmqJHDngJ6rGTr2wOXuT/WJfnzUc4GId1nD/h5rAZCeYXmOiksn22MQkiD5GHrsg5Gf1aqAt/U8X2w2N734X6Cg4klv5vB2CaCcCSHUeKb8UCx448aRYdzCPV0rm1z/VILydbAKk+l+Yss5fGHQtBIaWU5I7Uu1d8K4pLiEP0JH6EaQtr0w/E2IPNWjRcroTvfu2VyvRfMs+HxSARJ/OqsNUvocp8BXjXV5nYnzaAqmPQMRg0GRBo2k6G0zYpRSowwxvYjb5g53RZojc/zDfM74/GXLyuthxGCN0sNwAWfUtaTNWgglZTlM7zJbIlhXrxXPNjO34Nl/YbH6x1IzaAxXO3D5Fuo=",
            "algid:sign:RSA:digest-PKCS1v15": "vu0PRjG00nkdyJQKAZsQ5wcnvWOJwcwAOyhVj1LIyGkuv6yp7mU4uMLBEuQzuA2Xsorewy18BVut7yPOGnM97yMgmpAV4SCpk/C/0CVfXIpw311rjiPY5oieh+TjDqiqa1TTxWTjumoMrXq6xP4TkZ82DqIELXI7K/I/fic1GoO84B+EJR3Zy7SB7EIiyTMRCfR5JLh9lY/BodmvK92l1WxDTQG1u/cBanw19y+V8fjrHgu3VckkhhTMMT91LC4knUnzgO5xi1LTUoI7P9Zl1nvjb3o9cV11xKpK1bf095e8ZKoWBcZOA719qgfQbRGBIvxJT6fZYEE1XnnsmGCAEnTprsqUKBDYgHz5ZpbaYpMisu2rN/VrxY+I/Pe5bUTeQnPWyxdvMwvVFTaIofDkv5alzT+ykERFfwd+1ic/Ljz4M9YN73Rh5MNeaSw+nTJ+l3Xsi2X5ebq9af8/1tFSaq/XUiaKULcYnJQqjYEh2syQbfBx+puxIQwYqmT8v4f+Aus/7PMl98naeX7vvg0BjqC+roJPnR4MHc463PDQMpZBxNRt2hHPoASyYAJ/5wg9VLmuZHMA0GuSUiyludBlac0hPTvhq0WXdCuSBklRECU45TjM+X95F2OyRpo5/Xzh6tmhnA1+fBOv9oOBgUZwR1rFUoqg0opQdprGMOfrd1I=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "WvGFjDp+NjT7f/3zGVkhzlZg67ggmCdClokkNm4l7SjSyJUnxACUX06dn8DdbUjfAYYdp1sgU9F35GkuaviXipnF4p+nPvaSYNSQIApZ9qvYANiPjd4BJjD4/upaK8iBJZLm3s7jo5C0MSjRRIkFkD9gbDqDqz6B0DqJpnHCZ8A4gVxuwS7Taw6+3xwolHp5u1Sl8uxfiyYBqsYNbD5FVAborL0bK31l7jnoUUy0xAhA/7Pi0IVWVxkhZSIccyKwGQ27sSwslLwP7GffRiHX1dgL5m2+fJ/KtCAVuN61PWoJTWU0pUoyFqtRPWLtxmIBqp3/nLwU5h7LSJfKH1gdJBQ/EHr0yTNj1hUsghvVGNSvWHmCIQuSnQj+2m/mgC1CRx/TF2Y1zsWof0cMkLdKIqvW1druJmLJjOA3afyXcbHjrNQbSzV2kZGp5yclRQi/2GrnkcYWuhpEmvppCmO0XyJJ7zEkNLaLxVPThcXfv4IGdHJVV8ZQ0K3ytNkKvdIesO50/mkcQ1KlrjlRbehM4ehAJAzQxqlyfAFRTTRyPjP4Y3ds+jiYR7OW3tVZJf92sJcpp+By2txBtLjZFAW5EDLQAF4uysRU56tYP1qZZ6hE9iAEOw8nxHuQziGJtNeeP6pLk8l8MGmshezNNhCXbxfhyON8yk7mxPqiY6NEpr4=",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "x5wYrUzX+d+I+Wtg52NUrnX2Ih8Mz5q+Wl5NPFCQTGVQYOzhN4Y5YLAtdXEPkmd7u/17O2pi8LpvZuuaXkypC3brZq9GLokKDrNEIiorJdN4FuKs/SGqnqUM6B2TYp7QHak1av3FndEQOnQz/VcqrTEWzq0iYfmqqJM4F52TLRp/4MUKE6F4mngUNfyqpt9ts88rGBQoNzzYDMpgolimfUtDh1iUmKm3cSmuYvuYtASgJxGHsjxN+H6JsGHt7ltYeXh2JL7qeDGQ5UB5YGYyWJiTBTt7hLDPHULuOXT33meU2KuXYZBul5+mjLlxflNdfgLzceYvZc+xUphYl67dqyhnFTsD/NCmuHWDwKmcwxXrrzA6B/BMCxwkmjDJ6iOdtnCn9RmPeB742tAFHmqfqRBNQAXhgDfH73cNauIfbKsOEdjP26f5A6Zuvvr91YniZmgaCe5qwjWOC4PBZ0faPbtC9z76qTrn742OgZ6b5V8vUMlivOWsv6NeVdKRb51TNVsd6we2+MKIjmBfWoV1L9Wapuq6ln3Ipei6ujqJug0Q3Lo0WKaXNBJBfrtncYNR8A81fJ9Cl2yYC2vO7vmREqvqQWopx91Z77cs0Rl5mwRpfMzn6ZDGZ3MmmgNfN+1gTXgeR1wI/yoy9h0plpjNdUqGhuLvSZfaChya5XeMyRg=",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "hPCBYxTh+6YInYogLRih2l1ngMC2HFpzJ50et/i6MX+4GpqezEnpW6EqS6qBuqG9GVv+047OeO6a6m96oDUKG7DBU6sndZOoYVDuGR6XZ2rW9sqUyFOqblRlqR7Y1p2MomS7jLlCD13LtDR/h7imnqrBX8LLRvSkZslDVaw08j8UJ7MYUPHvrtR5327djmIfgS2frDrmpJmfKJcA1V3RFnDftC7ZU2E7M2F0nFN+b2zKw9aSLqhzRbO4FtgKn4Hu5QEcT5whz7jLMSCZoFP91q32lSopJIZf39PtznxxGimttI1LW+lzH42qUfRLUnLp0PUlqgyXGxdLtajyIvmpFupb0vm9p1336QohwYyvI2NSdHn/wXJ8HIRZbStrUAwenF3hEwD+dT5eYXv54phkpMg25RszFV1lGCw53SE0PpCl1Qj+TY6kRCqRNyvqxJA3ywdWnFY2Dm/QtXVRNtRf1pkhnCL1X9fI5Bj3X3YV+TQCuKQavKX8rMk+XGxAmjAyKZS109CSaNsaXe2rSQQ4SMowzbw8EcUnN9VbG9/JgmDUOu6KCwJtu4q9gzra1kuxyrlCDrO6cn5ELfLau/cKGIbMbxjklqkFg/1/SlWbEGxGohqPBnRRWQWs88sUXEgTfMdCyflnfjJ+Ofauorx+t/lTZfyrGN2N0kZgrdhv8EE=",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "CBYAi7jv30XmIPh9BnGm2aSi3qjj2HZHFsFGiVmkGa8ETuR0FcRvuT1VG3/MoosSfKatOx8D76wM9OTneJQSiqqvFWCoygbwVjrQfPbFqFkwPD3OJWv1lDoeaId0RtqhURvVL2qUuH+wEfQhgFBTVePEcUmf8ocx4iVJHi6Mq4AYEpPoID7Zyf0v59K3DBEICYlafPrc4+LYCpNYRgSt2CjeiODyc1gEMLgFQF7l3knIjsUxkAEgu/9Tfxpx5Grr2Qjuq4tAKxJ7I+yf+IHG48cQKiD8j9xBGHDy7D+V/bkFX86kZpGcUEh08TzweEQBTCYgMjo5o+yENY38Q6XWdE4fNQrpyjS/APUm9nEgF6lkYY4U7uxjHO0f57XCxjetNc5HEGPKxG3qXaEwEGyfK5xGi+KHWkJNhBtuKfKOYQBXxy8Y7ah3sYND1oAWwmBgoeFMKhm5oPRD0wMueWjAyvq7PZfzmO3Wqk4S+AfuvBE3QfKIVWbzPMIWhYbHY0hZk9i3Bc/PWxYOvfWUjVAxOWW2QrfZPscQebTkJFqCujzXJepM78lZ9HpYWbBzY7YVyN5shOCe3SyADuaDltvTzTj43E5b0F/1ozhWFEbTyfOPNCNj0ZhmFu0PAeDhv6r0SUL0yt2l18wpyXj82217NLhoOZ1CtIylAV7uXIW72bE=",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "rmFdxrNZFYAkFf40eblr9DqQJd6pX4DJmrYoL6fXcBGr97Dh7IuELYrpIUPa/197q3InQkT0ViwWYHDhrQIbFx4aqycyQW0rd+f44tZGd2YJOKybxfShx2tmHxL2U8vx+iEz59OfoMs9YAZvcj2RRFkJMhafaihJNwEJofFZZ42tLbj3CrCOpKOwi39oTikstLjaV9e3ToFFtNioT9tLKSSuK2wH9+YQLVRF9bqu6usSYDDrC/RhchWE1FP6uaQbdXrg+9LkwU7dV9lsqBIQcLwFwBqYJ7yqUUC10yVRFcWeA4Sqj0oBehuoG2ozwRlkUUnULUXl3DXMLJquAqT+L1QLtxNqfQyXQtbLmmL+i9gVkEbQrd+Uk3pWeiB5ajgS4YYKcJhwdxtEmWHs4QIGZCD8bKDWESBRfH79BRA4kPUEd9ATkR/Pnj/+X/8NNH9gwj95BhGiBpe/F0UjDRIa1S3xI1muU0tcvX2emG0ZKYYyZd7ei1ZSWl1KZuNDNTABhqDayLM7EsZholpW8/1+t9lOpOO92utTjm1M35UBIA5odRdbuZPUtMHx+e5K4c2l7n3cQZdkrievjlPc5D04r30JJHey3L0QT06X8kkjAyjbsMDBcuKwdkGNBaAlrfmFd6YOxVyiaXLqHwbmcjgtWDQsLRKEZdLRFGcIsmH9B54=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "I4SK+LMQBpEU/XlK9pLSpFFLafx0q+pQGIMfpZPEAnUXL3FSCxZobbHasYSzyKvwqfmGXc4H7wxdeOSp1ADgVcN6e2YyPo22jShCIzS2mjMDVq/PmZp7tzpKGPhFa/+42uGaJYVMQX1V0YDGTljtpie/2xDWU4I8BfGdTyT2U1PtspyR+ldW1DxR7KzHUGzYvm141oLutXr80bMT3Pk9iMqYigcEu/o+lrUqam4n/HHZ0/PM6HZptkgyhaM3r5/4DqcuIpiThqxDzEt1Lbn80boz2S9xJ9u6eJ2jENq3DN/iD2BtRkKyh5NyLs/nC26afedV/dj7R7Fkuxq0HZ7+/CIM8L28++chluwjY2iQzFJUXJ8Wss5eU/ZHs60mWZmRh3180J6Wj8buH/T/7fE3J9ViGkPzbcENyiev7LU6uh2do5aKtxr3cjrx5zdOFR23E7q0ci5mY6OoGrWHCyZ9d4LAg+938HO05LtkbxZJUZD2DT5lAkbde6asGNmn47XHyYjTJ30Zxd9r1rRpcSNPtCyRiP6zLe/pQztmE+d78evB9vUGfmw26HXBKN621407AKdfGvNte9YLvJ8P/SvlJy1YQ1plWjzTkX/B3U5e9GkR/NSJP2wQ/OiXq/ns9eO1pXjesrPEB+eES2MTQX3UBuc0lnh1FJqB1FrCKJlCq28=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "azRVVXFadtDgsYjEkWddSycFMwdKl2FPLczbgdgeVLxWNltdHAibYSa0I/kKA5hl9M6dj8B+Di5zw71C2owKoLyJufhFGWmr7cNRQ8YzolBKnCm9AzZMCofMp86BBxuRSioWacmp1vMMRB9tG0LGSnlyVT/rJKNBoi8R6c2JfaFw3p87n3IyqhSaonAVdNCPAUp0Hi6iF2Hj+7kqVEbv0Az1DwHs7kAU7yFiJodKCsR9bh4Z6rXOG1oWcs02xTu35FlzzzBC+r6UUdhlAA5CEvzjGhein9v09LSP1Fks5CHbE0cgjW85mbJITPMMbXqGkM5LOgl0wynVPPZycVzoeelo7TKXsJqff6JzsZyFkmbLdX0Uimm7L3yABV6mgYQ0xcL9lvtvlNF+MOBjh6fWVn1jU5aq91Dx/exyR5QPg0u0jJkjFIq8vkitjuZ5Q0pZAmvmjYS/Mms/Sd4eP90Rq5s3n7v3BRXKr8rvMAd2x4LnHxHaV++k7uY1uSP+1En+3wp8HSmBs5rfoEiAkrGyHaYFJZCD1hLnwV7WtRNyI2cp3aP1P9Qh+QMliuJel0+SrdNlHzrouIL+Z/UmQ0QqZhEmuy3zkLZ+9XjtWJAxYQuNqBn0cMEx5BkZ1R+vwqIH2JzRhXDJMkhZiqbz8IjP25FahGUJzHt4uom0J6vbjp8=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "kEt8tqcYFA9lP95wZNkhBtx8sEf1tfp78PvgPj5bLEj5zO2dhC3ho8RV8076Ns7VqqtqGSdiLZ0xnNwwDUhgGerw1w23ar9ZxoQxYUM67SKIyfVS0l4TjnxDVGm/mREc3+O/v4NVjY+axo3FndsV8C5q0PIidt744GDVhheex82r7Cnp5gZdrObM8e3g2RIqJJUGEA+XKSwgofSspehh/tHkfgV122lUhf7SA9v6T3729NaxpWEzZCgQms+o+JQ4XoeNaCevMjGCRL2UZuhRelyFXiBwR469OJdwazEDO8QvrIdIU7a6WQMBi/kxDL8iLjRaZKCvLdvx9GueVgHoaSvEMJUhab6+v3GjzEbqs6BIRgyaJESYqjx3tU6WwvF98PWk9Vh9ZZ3D41oqt7sHVtDAtO+FWC7oasff7z1QY28qqZL4bt3KMIxFFbUpkKflGEQzZ28+d498FECfQSfu1be630D3O0p9S8Oxg1Y9QTlTXu0+7lU9zJWuSZGSetpNAewJEac50gfT3qpqQjKovEuzCEehGCqeJsQNU3WC7P+jfTr7JzXSCUNSuKwJQ3YHTwWNWIrIhXJb5otoDaKFd8fgB+QXruWCQQjGsb+kjXyCKsD6cfheH9PsuQVatbip5VbxnqLxcll3NapgR+kU4lAz+TilcpS/pXkbOqKdZZM=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "xnz4RUusIFwIaFiO63IIBgQ3GqyHsjJwnJ/a8B7T9z9YehKZa6Hh55bL3t1+7oKNAkK60H2nIprL7DZbS+bSoSkuDhihE9WQxqy4kt71zaqQIFu3FuFHji3ID1TYhZxEgf09NepVo7tQpYwOt9H6icc91mc2APrYiTlnjBuNGtm7vGixzXonhZcLAHLGjAhzqMqkx9LSpc6mc0DGqTHVC7++4syCznyf5T4JnE0ScgiMdLeFHeUiMG58HU8o9VOANWwQxdfDgl/saueaKhW3yHMS0ZvK2Ii07EiTjEhfBGBzb6xakdgH+ogEiqfqvGAN5OU09KnVRmWl4jDrk3d3xeQJl/LQvRt0M5Nbe3dw26HYDUNLf558fvYVuuMPi3mA9+6FDjQeJ0VakBujdHAG87a1x4pDurmreFIWGU3oJS0xC5WyHz1Tdh6IuPUVHCnM4V2fDW2Vq0rxgxz+KqHxtLrANjl6Jpe5b9Q/oC6VyWl5OHayu67xWYlI93BxCsKM9YN0kFJPI9ho6BzkEa2LowIJLKkmxjp5D/P/tMYCJRqNCtxatUj4aS5TLIw5SmrLEZA31bHYZ7xUoRmBqH4OnHd+GFc6KiAD4nTSznkSSlj8ybURjVHpOE65iafX0Q+c4DnvS4/0Lgu1PQ5as0uo+kCnRfLMYmt7iA8Ls6rGy9o="
          ]
        ),
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐": (
          encryptedMessage: [
            "algid:encrypt:RSA:raw": "FoQR9BSodvPui0+rY1MGQ8nxqpcWjZRJ6fQ9Ck8pqFtHyaZNG5rTYZIS+xn09f2bOdldAn9TV7MyHAO794hoEtUwbBHChdsUDsmqoag2VOdfU7mpHF0qVl77YO+dAybc/CZj8zOTAepZyS2btelyCUnrwh9nidCO7R4q21nDgEYPwnXwCgnXG0/9fFbA6kPho08pVApfFihgUMnFA/EY4Kg0VNkkSNtk1CLcM4rZOb2uslhdEQfBxEr6Bo8ZQUXZGckRTm2JIsT3k2vewddt9yQMF3jjaKeQbbsmx0kMZiblcEpv0s/s+Yqwgelhtg68go0WHO4M6Ae0Ds231DLTo2ctwTPOznlECtxQ43s1vjdaO9KViB2SrBrm+798P85EvtBQMI6P19W7sTAQzPJjbhDjvodks4WS/apCpHUkM6lowiBgfKAqCWTNjlTa4MN6thV63HTMUVt+zbWMWd3/RuJjTUmwDxwdD5gMDE3J26GZFi/IS/qImPgo/fTvsgEqHt1EivNBhGZ+5G6MYo7MSEH2ftLz6ZfLQz0+wn1VEsLH8jsUAX5+KIar1luTRSdeRGpNmThZU/rxGQgQqEGjaIhBUmym6TD15aNVBIIl+yhlAUn0iCaknmedj7SsOsL/h8IVieq2kjVl9zCHQ8jl5DqwX3LnxWhVzAJAhUcwMjg=",
            "algid:encrypt:RSA:PKCS1": "LbjTnod9jalsiGR80n4slViv3auqAlqXL7+Te+ZnuQAWoInfjZjM4Wx4j2ITaW2swYJFAnB7N1EGVUdeMw0NHncTXXUoTQ/wuNhQefvFF6z9uFq4NJP2tXxhWc1H6/W4urXmlmKzbTAf0CKDbdiNjpnpXijg1hlkvFj/LOMn19TROpQfQyBVoBGIMDKndthZioMD0+8MUlThKLlH7f7BRpx2JQfn2KJ6f+YZfg9j9BHGWK0So8oaqTgwwPhPruzIMEJa5cFak3slss5gIGAFZZ5IjjnuL7OXH7uV+ntFo0Rv4kd56w6rrs6rE7o6iVNtYhP4Rzk5qUD2J0WTeXwj7tYEpGiNxNm5AQ4Bql0fxzVaV+zCtkJdyFzucLIl4/FOeuCIKAReA9Z1GvGVSbWoMxzrQVM4uOmmIcKCFLKMHsyW6kdtZXnvEl1BCJmkOdxTekmao02SZqWZh4yZV9fhq1lcy82OYSAD8Ou0dFf368HFFZmpv9rJZqOKKV05dWBFr7iCdrp3aXTwvs3G/uYsCP3Lng6mIIXIe+gzHR4+QzWHJsMZHlLVzGoYL2KLDC0SIjV+j9X31QalENIyTefmTrLxt3JwFhUNO2vF0w/8ZQuXDFEQswEB0zfharyJL1WFUOZ6uI/BEataICJ0Gv20lcPktAZx8Tsy2G4op0LTs20="
          ],
          signedMessage: [
            "algid:sign:RSA:raw": "wvvDbby0xhUBI5srmt3pF1TB9UH8xQwm1grHPha3MKCjp1m9wzJGBScUz/nFotYY/w+sbirOe+UQeTsk96QU+iAURvvEF46n8ACXw7vThlf1j8+EJyWrfSyPvxcZfUP/4wNKAORPhHreUYM5Q6xASdhporadi8ITVKlch5QSvJxUH7wy6YDt/34z16C6OzoUPICJXy/b8q98Cf+xK4/es0k+z6Bt6cQDFYyEK+OUJm9HD588Mq0gAuteS7mRQqGL2LHDA0fKOX0ptSU6vNOSv9GAuflsNCSAPxRNkOhHXN3dWDCrM96AJM9bQGvxnQWlbQf+yVnf5tClXlPqZcWZEN/I4dR2KFcg5OQx0pmudJ9AxcQFfaiyMw0b79rIcbJIb6vHWmz7fS/dNq1bvjXxPeOM+ahR91xqLENbphGt4y8MXZesGQjP3POw9YBL4XrUHOiTGhMr2SWJR569yUzglWNfnKFHl66HaaZrS688spbd+9f6rAxsyUaSZmcd43/CJjetpgEmHqu3E9k4Hq2Nm2NyhSiV7vNaiceCyF9yXMTDKHd7xAmDcs4wQyBXwXcFaJwFbWyEjUwXvumaq0eyM5Vs5u4NIcpo16FHMvHsu3wbI39ze7AK7jjD45STq6DJsJklp5WiV5WYv+2xDamZGi06XJmPaI2XnH+DrsiDqgg=",
            "algid:sign:RSA:digest-PKCS1v15": "aO5KdePNBsIJrolKleGat1/ZG1vqSHdocVznwvL96iLzxtr58I4IDO23P1U8/fsxz8HwDRRJoX/YvyZYRm8p+s1MO4stFZT6hOS2wCQx4z56JKFEzuld1rKSnUIppoxECQVBiQr3+xMb6jKX4eKPh42iN5e7x4Z0dQLk8cr6KfQFXJ8n7Hwz5154txDq/ZF0Jqbikwmg/yKsSWh1pecNkmel/PEgvP6HcAuuZx11QSu4U/P2psDngMV5AmuAeBEsd8cw7dmlRedUbNYTGk3FMEYL2q5lwigXr5uiwBvG8pBRtzX0r+TWRLk3x3i82dTEBID5FG2K5IIqsnqTyxvzspD5pePlc7v2JC61JcKIfWk/VAgSgAQbSdBbfpUj3XR3mBaWKjLBVTAGDHRLWFTgVnvcuC4hUmhUvpo7kRO9+c3XXAP0f+E3Zd3T3Cf+uhslB7mfmq1ctdg+zMNky9eBVbznWDDi3vVj/ase8ANTY0hHFXQfnDWfTpbPpJLYGK+SJuIyWzBxsOasPU6kSbN7nBgGUUnRSqFNWKpHfuHVT89nwDpPt1ynJoXWYjyVZGZdd5X36HfRjDrGw5q1AJMofAi/T/gb4QcfyDdrBDax7b/P/fiJ2PGeh1f1WJgjKiCDJvqBI6+vpKquhk6aqJFR5Z5XTBZTXXsV7nkZXeKE+98=",
            "algid:sign:RSA:digest-PKCS1v15:SHA1": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA224": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA256": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA384": "",
            "algid:sign:RSA:digest-PKCS1v15:SHA512": "",
            "algid:sign:RSA:message-PKCS1v15:SHA1": "mmZt44HAZatukr2IHHmkvPJZOlL2rmkQ1KVGemw4pkLy/ixWmVKpMP/AT1DeB8bfINxVfwopeyAUhgcmXQrbEc5tlgmlezEhMBgHt7kqa03oAzqbDRw+ebTFCWsFMIsNdNII8fC6xHGpyB2mldNaitRmgvdWn3lrmuW8/1pWlXn4IRyOVbO0JevqHCFB4916khXT84FDxG0iAKTqFIJMXD213MDfyxM9kh7JFdbE+EpFDEknbCdpudOBNWrPLBpZVLyeV2p9usZpE2YT1KYzzPoWIvwHZbGTjcz54cC3ZPiX+x4Eu9ErAmC1CdmxYU2jd6xrMur4oNDn8rfvqK/xCpt/f2O90U1UwEvWzGTNYgtFaVwVURaryOIWz7algY26V6GWwJY31mftaL5PriAOxkajitegHvk7irHV2AFfEXZq4aR0VnBf7ua6tfvy9j/acbE9+ag/gojUkycXvTImYlpvQANUd2nJH/4wwB+dsiZUSMvOfgQjtSc3Ih+uu9whxOAQ3RNoYgvNbi4A8U1jflzA9aWo+Rfon4+wm/tuGB9NXn9ik0e7JeDJAWxhAmXW7AhPWpqfujS3kwgkb/Rm7W06r2+2xS3woCl+SST20nUu+/rcDsYUrwfS8SAiWQI69j1ukdZmgL13iK5Ah3sypNaj8Yx/0Y8S+E78LqzxKJg=",
            "algid:sign:RSA:message-PKCS1v15:SHA224": "bwSdwF2gSkYLR1ji1kDRFQKXSwcO625TcqTSLdw+nGpYZKR/6UCxD0OpIYGfOwa2Pzp1FApqNVJlGO2jXYFpXKQPsUm1RhrB87t0NE2pKuEo/Bb2ekC8kIXk1NloKSef0fMR01EbfKOsIJvJSIf7E5dXf9p4c+JnWaMzJ94EHQGJlrlSjDaiQu485dGArwOiMU3ZI/C3XqL0raYh6iOclKhU1Wzn38F9KnReHYC+I5+fld9L4zAjoigmvHUVJ8yQRvdUUauh5gatuIOl2W03qR25Tstv86sF1j7PzFYf2hYTRvCqzQ814hC3/Oh9hAi1rO7JHl8ntXcIi6YpiJxi4fztbbESTz0Mnd0Hq8PXWPIkCZjP4w0voJ73tuQf3Ogfe92L4Mb1Mzb1CquD7moBEQkHeq1S3B6uCdNG3e8KRGxS3e5fgqvTYmlSUrCbBh2qoEEEOIaqjVrx+rUqUMEQwbi+pFQqM2sRUjX0kEMRTNx6ZJg/iM1fh6XqYBmSVz7ZSub1hoCZxPudQXRkar46A+kLsErr6sZRrXXG4wZqqjHUMRmTz7m1VEY9chddanmX3na3E3EJQH5Qw6oOBRVrLPyeH9ov1EAj80ZauNpZaPl+FobEF1PS1v0BKfVcUXwtD/ZqdAbSJomSoWets93UtEPHv9F+msWJEU68vR6pQ7Q=",
            "algid:sign:RSA:message-PKCS1v15:SHA256": "Z2i9kWJBBTNccpZ27eB50h4jXGsTmjttJjbHZFpLeoJTLHe/VXt0UljlqRXoxkTi5gpJyFTA8wNRiekXBDZIILq3Od1AQR9/kRnx9VEhiXMJvQ8op6yVwI4w+kAroIIalLNGOSgPTjUNltj1l186UKJ0LM7SqeTuytEJJYJp8go8wC0ncU80Q1cl4CkSZQXP8y0WvJctguJFBIm2dg1/f2UF6HQBjyP4La35pXf3gfLJRZGf9fSkUlUpfpJvbdgc843saxfTyzvXQ7+YEk1zwEnRw62qp4l+A52fq1grJ8TwLMlRbn0YLEn76Kn8fWfkl3mlQu5ykfsLwqgpsUOndNjTATGSEc2qkxadTSJCJTaHeiW2UWmz+k6Blcy/+HCYc663zQxs/bV8qeoqrLapSdkDLBHYyr0C0cYuiM/xp6INITh4ryruiwA1zCiKv0hLKbT8r30mkwSfDxpal3VElOYIWsqA09oO0sk4g6bhByHWF4yg0Youx+yf1nQeQdHS1I7W86qXZCOJEVf/XNK/GZj7WOXkrt+QtYkv2DS2mAwF16Qlijcl4fBjpi+A9dezVEP/5celKdgSLOh5rtXlrQLdAv/qIqiO2r18IsJQplZdFOeR+TGt5x0QERt7EMEix5//pAEkhhWM7sCfUuLGFviWlX0GH2ZIt7qriEmASXk=",
            "algid:sign:RSA:message-PKCS1v15:SHA384": "hRh6hS1J6J5fXiBwnuZRwZ3ilXeYpvP8PSYxyI8+iKbS0Td7jXXLZqGK8NC+3YAwo9i/fbLcOmqqsPma7fVrmwfaqdNMcbOMF1Ifxvw0CPlski/K4VmEaI5h+N9kOMdes7TrZW1ZvqGbt82i9YuZY+nW9NBNpwlKWNd8LfIcLdqAtl8CgBgLv5qVminhws1BZPdFmQnZtE2venak7l+QBk1mXR/CAmZbMc+sKLru9WMRIBJO2Y+RGuEXtY6aGeghC+lEMejlP8SO8dDK3t9guYJTrHnUVmiamNL0qshYNBtxP0v67JnhbxFwZaWCITvzuGAfBvPVqiP/u0PuoIVQpvCsK6bdfs0xrXpvqWGpO952VZfmevu6XthLPI2rNPqncvPIX6hpMmWCUpVjVl8jW/mGQUIYyrlevCGe+0waHU1pgVGENd1vFCJ4aZ0RQOD5c68Rc1au9+5RkaoV4SvQvnf6yo1OpTMmWPrRTVbeLF5ke3cNMvNHEtoBoSLcyaJoNXWoWwN2rhkJ17WqCaJE7TJUtSxnmoAP8D0E+58kCwLTx3iOcuGSqC9cI6Yh8icigoD2eUVK8M1zrHbpX5tOqt9myQCXP9zu3xwU+DuzhxY3xwpI2LUAmvg215/4elEH5gYzSpQqDDINUWwykcG0sAsr9AZUAzLuBcxEIRkORxI=",
            "algid:sign:RSA:message-PKCS1v15:SHA512": "YDOCicIPMG7SRzkWybBnWXrDUBvc3I/N5cLDi41FaTwuFnnKSPZXmFKtYwsBJJEEr6dwtgJLJOVcqBShYW13XmOJWmtFqptCKxiS8K8ar9/CDaf0fnZLx3tYLqndi465ytbnGiDpcEy7uMOeKbyz744Vj4e8ZTLmADPZ1fG7IDvjfpJMVyKctus/elzFnKd9Xkczf7/drDjuQ9WejCbN/mTJblYFzY4PKmeukJl1LWcSw+jrsD4LAuIsLatpu2LjJK9W/RoGrzrR0rOk0xZCAA5m7BMnlr7vvDiSxH5Brt5CZ8UImrBgCV+Npl36m4aBlLUlGCQvMbYoUQa4oCoJsbwUHMnVSiRFxVGFBpkUjcxY7/6fvBsFZ2+sHY+nADrpAxlMRrq7mt6bZVTUFyQtCku2Un2We9XmTDIYEFZh3p+z44jLhdy1JFlAkgavVUjwDQA2GsdE2u/Hq3GiTAPx6CtJ1KG/SDqovxlIs+ImmYcWcgQcXCjVANjG3YnS9XIJXhF75TjVy+ooyxlATg1giNUzPHkVjovqf/2GcMNHotHumb98vafLXXSJXctErlP4ubk8ZHFtj09m5xrHXNm96B3DkOZWiuJ12bCMP1eSM2z8Wflq9+WUDti6DMb8O2NxxfVK5zh6cssTZrsUKH4AsSETxIE3sZJrWEDs2vJDVPA="
          ]
        )
      ]
    )
  }
}
