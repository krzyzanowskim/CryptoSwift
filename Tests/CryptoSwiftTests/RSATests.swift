//
//  CryptoSwift
//
//  Copyright (C) 2014-2021 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

    let encrypted = try! rsa.encrypt(message)
    XCTAssertEqual(encrypted, expected, "small encrypt failed")

    let decrypted = try! rsa.decrypt(encrypted)
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

    let encrypted = try! rsa.encrypt(message)
    XCTAssertEqual(encrypted, expected, "encrypt failed")

    let decrypted = try! rsa.decrypt(encrypted)
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

    let encrypted = try! rsa.encrypt(message)
    XCTAssertEqual(encrypted, expected, "encrypt failed")

    let decrypted = try! rsa.decrypt(encrypted)
    XCTAssertEqual(decrypted, message, "decrypt failed")
  }

  func testGenerateKeyPair() {
    /*
     * To test key generation and its validity
     */
    let message: Array<UInt8> = [
      0x11, 0x22, 0x33, 0x44
    ]

    let rsa = try! RSA(keySize: 2048)
    // Sometimes the modulus size is 2047 bits, but it's okay (with two 1024 bits primes)
    //XCTAssertEqual(rsa.keySize, 2048, "key size is not correct")

    let decrypted = try! rsa.decrypt(try! rsa.encrypt(message))
    XCTAssertEqual(decrypted, message, "encrypt+decrypt failed")
  }

  func testRSAKeys() {

    let fixtures = [TestFixtures.RSA_1024, TestFixtures.RSA_2048, TestFixtures.RSA_3072, TestFixtures.RSA_4096]

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

        // Ensure that we do not have a private key by checking the private exponent
        XCTAssertNil(rsa.d)

        // Ensure the public external representation matches the fixture
        XCTAssertEqual(try rsa.publicKeyExternalRepresentation(), Data(base64Encoded: fixture.publicDER))

        // Ensure externalRepresentation results in the publicDER
        XCTAssertEqual(try rsa.externalRepresentation(), Data(base64Encoded: fixture.publicDER))

        // Encrypt the plaintext message and ensure it matches the fixture
        let encrypted = try rsa.encrypt(fixture.rawMessage.bytes)
        XCTAssertEqual(encrypted, Data(base64Encoded: fixture.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes)

        // Decryption requires access to the Private Key, therefor this should throw and error
        XCTAssertThrowsError(try rsa.decrypt(Data(base64Encoded: fixture.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes))

        // TODO: Ensure each encryption algo matches the fixture
        // for encryption in fixture.encryptedMessage {
        //   let encrypted = try rsa.encrypt(fixture.rawMessage.bytes)
        //   XCTAssertEqual(encrypted, Data(base64Encoded: encryption.value)?.bytes)
        // }

        // TODO: Add Signature Tests Here...

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

        // Ensure that we have a private key by checking the private exponent
        XCTAssertNotNil(rsa.d)

        // Ensure the public external representation matches the fixture
        XCTAssertEqual(try rsa.publicKeyExternalRepresentation(), Data(base64Encoded: fixture.publicDER))

        // Ensure the private external representation matches the fixture
        XCTAssertEqual(try rsa.externalRepresentation(), Data(base64Encoded: fixture.privateDER))

        // Encrypt the plaintext message and ensure it matches the fixture
        let encrypted = try rsa.encrypt(fixture.rawMessage.bytes)
        XCTAssertEqual(encrypted, Data(base64Encoded: fixture.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes)

        // Decrypt the fixtures encrypted message and ensure it matches the plaintext message
        let decrypted = try rsa.decrypt(Data(base64Encoded: fixture.encryptedMessage["algid:encrypt:RSA:raw"]!)!.bytes)
        XCTAssertEqual(String(data: Data(decrypted), encoding: .utf8), fixture.rawMessage)

        // TODO: Ensure each encryption algo matches the fixture
        // for encryption in fixture.encryptedMessage {
        //   let encrypted = try rsa.encrypt(fixture.rawMessage.bytes)
        //   XCTAssertEqual(encrypted, Data(base64Encoded: encryption.value)?.bytes)
        // }

        // TODO: Add Signature Tests Here...

        print("RSA<\(fixture.keySize)>Private Test took \(DispatchTime.now().uptimeNanoseconds - tic)ns")
      }
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
}

extension RSATests {
  static func allTests() -> [(String, (RSATests) -> () -> Void)] {
    let tests = [
      ("testSmallRSA", testSmallRSA),
      ("testRSA1", testRSA1),
      ("testRSA2", testRSA2),
      ("testGenerateKeyPair", testGenerateKeyPair),
      ("testRSAKeys", testRSAKeys)
    ]

    return tests
  }
}

/// RSA Test Fixtures
///
/// - Note: These fixtures were generated using Apple's `Security` framework (we assume they got it right)
struct TestFixtures {
  struct Fixture {
    let keySize: Int
    let publicDER: String
    let privateDER: String
    let rawMessage: String
    let encryptedMessage: [String: String]
  }

  static let RSA_1024 = Fixture(
    keySize: 1024,
    publicDER: """
    MIGJAoGBAMGeZvIG84vyKAATwKkKz2g+PeNaZ63rxk/zEnLGxkMCVKnUZ6jPAtzYOKM24949yIhfxYBC/bOCPwRK4wbr4YyIx3WB2v+Zcqe8pRM/BThUpNIx3K2+jbJBhAopf1GXJ3i31RuiLMh9HWhxzkVamz1KnDjCuTZguCRRHIv+r3XTAgMBAAE=
    """,
    privateDER: """
    MIICXQIBAAKBgQDBnmbyBvOL8igAE8CpCs9oPj3jWmet68ZP8xJyxsZDAlSp1GeozwLc2DijNuPePciIX8WAQv2zgj8ESuMG6+GMiMd1gdr/mXKnvKUTPwU4VKTSMdytvo2yQYQKKX9Rlyd4t9UboizIfR1occ5FWps9Spw4wrk2YLgkURyL/q910wIDAQABAoGAGJkNLxZe/pqHJmtcAJ3U98NgjW/A2EGp8iJJZ7eFHKJBK0pG2RVjobb+iw3AKU3kGh9AsijQnmufoeX5rblt7/ojgpfVhS7NHsKCi8Nx7U92bNnP0RP4mogpvzGWVknUdv6jW7dX83FKgEywbNKa5CPQk1XinqXL33gNjWdOh/ECQQDjdE4kNdVwKA59ddWRShvJiOMOG8+TjE5HvcZzKQ+UMlBwbknL5tIJE7KnN9ZEfNihVmyrMAzJAfe2PCyZAip/AkEA2esFkG+ScgeVYlGrUqrqUkvzj1j6F8R+8rGvCjq2WnDL8TzO7NoT7qivW/+6E9osX1WwWAtj/84eN7dvLLxCrQJBAN7GomZq58MzKIYPLH9iI3cwAJtn99ZfHKi9oipW9DBFW23TR6pTSDKlvVx0nwNzeEYFPOgqZstVhwZRR6kRawcCQHx/u0QTmjUvg/cR9bFbGFhAMDxbdzaQ+n4paXmMpZXyD3IZbZb/2JdnJBiJd4PUB7nHuOH0UANbfQQT9p42SFkCQQCcdFRTZEZv5TjmcUn0GBUzRmnswiRc1YEg81DSDlvD3dEIVSl6PLkzcNNItrgD5SfC5MxCv6PIUlJVhnkavEjS
    """,
    rawMessage: "CryptoSwift RSA Keys!",
    encryptedMessage: [
      "algid:encrypt:RSA:raw": "UzG6FLxGjtlqXWxC16gKW4KX/26rIt4IekwYoI6sbYK1aacHsyPkg5/OEk3on1RQldvyijc6vccFumUVY4ig37noE7r39KTJocSPEJoDiDiBUvu66BkZOIKYy7Z3bkJY7nAppbze7vjTmC/j9IV4aNFL45P+ghGjQIyoP9eKTco=",
      "algid:encrypt:RSA:PKCS1": "VMLV+4uRTEJI5ST6jKt84IEKIW4KbS/JzlhUMYuB3jeXJufwHvDZW5aGk+JYUCwYVkFckyBRZl3PP8hSTyQ7lvnNckm218nEPzEvZJebxnQjuaD7ncSl++j0XVoXQNPrqkIbo+mYJVL/SMM4J0FDXkmXmzc3e+ylQt7tQChGvFE="
    ]
  )

  static let RSA_2048 = Fixture(
    keySize: 2048,
    publicDER: """
    MIIBCgKCAQEAoucLcSqXFjsHkanA/UAdSllXb2f2Seh4sJ/QiK1lHXYq822mruYzKysHH6wLet+c/VaOJNNHMSRCaNxKiFKUH7yH/rTzjcxxDTB/4PboLm+SMBCiChv/EdOrLM/xBnP5aUC2urx3sVbFc2s+3u9fWlXcdxTFvY7WKP0YL+t1ls+N+vGP9Lq2deXB1DM8CkDIRgtgKoJBp6dW1X5qO5jf9XBWRubWaOD14XSmExF4HKGHAc1VFcMDv3rxkzOyVRUIHC7odzDqYPRDOWDtBvGogkR3LXImbrJsrkoWz4tQh4BTTIggqfKcyKELdGrrD3B42vcYsqols4kKtbVHBGBqHwIDAQAB
    """,
    privateDER: """
    MIIEpAIBAAKCAQEAoucLcSqXFjsHkanA/UAdSllXb2f2Seh4sJ/QiK1lHXYq822mruYzKysHH6wLet+c/VaOJNNHMSRCaNxKiFKUH7yH/rTzjcxxDTB/4PboLm+SMBCiChv/EdOrLM/xBnP5aUC2urx3sVbFc2s+3u9fWlXcdxTFvY7WKP0YL+t1ls+N+vGP9Lq2deXB1DM8CkDIRgtgKoJBp6dW1X5qO5jf9XBWRubWaOD14XSmExF4HKGHAc1VFcMDv3rxkzOyVRUIHC7odzDqYPRDOWDtBvGogkR3LXImbrJsrkoWz4tQh4BTTIggqfKcyKELdGrrD3B42vcYsqols4kKtbVHBGBqHwIDAQABAoIBAHte4VJ+P9hNMklFt2vUf5pMGSS9JlAI6EZTclngf8CVOqgK9f5lRoE93/JDmJog+cL/Jz2KaNM1s7m4hBXD/HwgixoCLqXIHCIyBdb5BxQL2Tnfjuh7FWyJ0oxomxAZCt2Ebh70Fu3OWlEz+nRZ8uv2NLZWm/8YSubV7thzySVBq85ElJVfhwBFdNUm6V3D7w6HxseaDY04RmrCNnqaU6j0U913zMTAfdVchTZIU40Z+MW8R2+PYxhg3UPrO7elcC/ujmrLxGRKDd5MXEPUbhJkv74RaY0ejGkz0Kh6Ad75O8krYnw0sgmXR/yjvRNz4grsIhxUkCQNdMTggW1qemkCgYEA0PF1xCCpJChiZ1b0i7RRxMWbr7P8+tbeocrfz2B3UGcwCK2Qwqim53MngWZVmox2TYz/vetdhWWuOd7RcQfXArrkO0lMrVQdr1hHl3r8N3wAM5lk4ONGLlgIwnrSofMb6YMfOt3/aJtVp/W7ngE+AzwnNErXb0iBBpefKlEqIQMCgYEAx5cgb5HsdsQZqHkRfjP1EJRjQy50tCE7ZjLCidn6C4iebghbEEbcbDjdNakcObdm6BunhkzcuCAKzKbczCBJGyo4+mKrxO8DXiCfOV+eQ42/wgTeb2M40nOHsEC3PwvVDUICiq4Ya/KHhBfKxJ+7QO297AwPslhp3JC6iwbssbUCgYEAzFosJPsQklWREKMCIBTnGD1wrCKsHSTDr5e815TwfMm/N+2RNGFAhAOjMrLErJgOKIDrq3MkD5DIGr9rNlJFntzs1XM2NBudwN3lfykAvr9fbxfqiuydujvNrW/0zAH6XaMpiyiOYV/zIYd7zOhIH1/YtBMyqxtNXgYy3G9vdcMCgYBG7oulewu5jam8uQIhgt+WO9YnGwx4s9LDWEjQ6vm1PaFoY2nRmA1gHLlpB6ezT12wIZvg29IZUbHk12xi0xqIH/JN8eEvxO3Cdv9/SV8ajPbYQhi3J2EbUdmoJue47UCTTKFQndyqCHBm3nm+dTH8OkGj8QlnDYrZy0mwfQ6DfQKBgQDG0snESZKRg6cHxty0Zd+EKjKuWlRRAG3GOt9rVAmaT5iNvckwNcXy8ujKibpkMLzK1Zh0GN5R/vVWzJOIxDfgEXn83HKMtjRlyCWVP+9W/q/fNraGK0BpibhJyNW+D//xMwLSHjrqVSViCXYkKNgLH51VcZyio0rzyg8Hk/ynPQ==
    """,
    rawMessage: "CryptoSwift RSA Keys!",
    encryptedMessage: [
      "algid:encrypt:RSA:raw": "DHAjkUdfJgiqBO36LLMRBb6OuAoM37g+xVRZcJ2LzgeuyoF/022sL/f2mgfxYb9u4myu2nQ4VhNnfoXl1LZFESky4vXJVygtQS85/+UugydDCHuaX4vh0aE5V3H0hJnnQQgSQ9oX/JVvvsyxccK81bcozUClm7a5nAydnAOnKKenYhX9Ej9W+ftU1Dr305UbOC/Tl/O3t9wGfb0KTkZfHe0lIJdYt6IxjLgqEFzCuAUm+cbLTWQjT0ecUUdr9U1RTq0p8uoa2HwqBrCyAvaxOnpIqRDVAkVghQWKHWpCHXgC0lCcpuzchSvZSK8Fp+ooKXC44EULk4w/wFGkOFJOMQ==",
      "algid:encrypt:RSA:PKCS1": "BSuDa5ssKbVeUVj6eVpmKJKXyFylrpPOqFe7L40CE5XS90O38D/NOhUwObGUk4VL1nf2Z63MBQ2mu/i93fBwEs4h8K+DBZ6LkS1pucnqtHLrCnCLBFlJI1xHGHzaH7VAgefmCmJ/wgVURsGyKadee0KCDIlWpbxeJEUE4I7VAT2dumSYtru/kKqo3VmPkjWq6MTuidU/GaCUkAJ4JfcOF7lcbJVwhNEAcXa/QWgb+CAYXiJMBHxVUkNAR1g/tOb1ff26CMMP2dtj818lSwn03mxSGxffa3WW+gyIDF3U/hl1qmMTiMCqbcHZnvb6/XVhYAR78nAGLYP7S7aRkrWHVg=="
    ]
  )

  static let RSA_3072 = Fixture(
    keySize: 3072,
    publicDER: """
    MIIBigKCAYEAmgiHcGl9/MdiezLUTwcrr0usSAyOagtzl5bP/XGhROk+tzjbXpbFyTJl27j+dHouFfa7lQAN0e6PE5MllEKBSyCb515Fz2kFZ2OEdU6M5E1YedDKCvBNXre4uG4WpaSZCorREVCenmwtq8fCrN43OqkJPQrgSFSi2uz+8dxkoG7P3zo3RxMHr8Y4HVOOY61F2dlJFIvPRTo3nD5KtJPkE3orDUDCWG+hg1bzNLrLkNG9icZF5ocQlqZGXwuYTYfPqMFzThUA8vdrNAO4kkcaYAZawp8PXveh3ZTfUmQ8muuy7uRadAJ4h7gfb2oPqGIb036ldTPVvXC1hJOHApt4u6atRIUR5Og7R6IxwpGCbXVxLALhZC5s00ddwmHatRo2Q0Sqa8gM2YLJVxDZLjpcZxQKs9UzkIWBK7fALRxCDlP6rbJ74unufO4v/z0iHumlsZSlStFQ4EP5F/uop6R24Vr1JShFWS+gi1KbIPHokg2QPZ8L5Z18uwN0nsFkb3A7AgMBAAE=
    """,
    privateDER: """
    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
    """,
    rawMessage: "CryptoSwift RSA Keys!",
    encryptedMessage: [
      "algid:encrypt:RSA:raw": "JuQvlWxXLyPQnhw3CZ1BYofKIltRt23lgG38zdMc49RAZIHJhV10hvgZi18vGzjI8c9nl+Gc1UqswzW/VeLJ4NJmWmGcJ4lfqUMSKIixYWbBSAjZGb7TmxJ81Pf8we3OI1ht5s7xjJzWW1B/QAiG75Jdp4uOVEpgXc5zUzGtn3x4Ya3hNCGTPVRckM5BzhVGK3Jmfli8uOZcMWlyg1e/iidMBWf90VETOa2vKXOBZbIgZLwDfR0qXobSdJ9JokkxIJTYLt29Y03KEcewvLoBqP/7qHazjs9g/OmVPc00MffByMplBHtU+PF4/8b5GOrKA1slnH2qxaxsIzEa/iXwxlCM9pUo7SQD72x0a9S55FGmHc4F1bl4/5xV7T92Tl1k0p+lYLkLFNFX2Ho7+4t/dttq8aojOS7BrYwducHoArS6wQLx8LRRBVIjDghQ+zCCLyed+nV3ybZ+YvvYbg3xXsDMayTCbkZgUCZHpfp+/HMnMY7VBBZU4BdKN7/swnDo",
      "algid:encrypt:RSA:PKCS1": "BP4w+TXwb+9Us8AuJ+wMQnBvXoDvlQ0yagcIX5kgXSCn1+32gfo0hd/4iR/TUmLdHvrv7/w9nFci2EI9E+XpZXRmw07XfoD1OWdTMdUVwxgeq6h/woGl7JcgK1MO3YPGwWKd2rNNK+WW3Yrc+ZzzH+CumRSdUpZDPIEcBRi2IR1lrtTzCjpD2pkQSo/pP+n7lhSdO9c+XJuQ6YpkP+63R4gsirgX0TIPp7I2tJM+p9pk6u+8CMI4K1fkqoWfreCi7U7wH+qOXk4/pcK69AtgQovOOxrN37478B7O7FDNmyD4VR0YtojJk4aCQTTkTa/aUbOEgkWM6X02deEyOY3RxNfe0ORwQt7gqdI2y1if2O7xx03SS7XJg8RZr8J04Q50KlmRtAuLCeSluASFKBO/54lLtmoGvehtZhV/Y6hsRguOTSCLS+rOQV/z2sTGOgzSbTusATsyinMsfOa/AB6EXeaLajmiLcASm9YWV2JTOobYxbNdbRTPesO61YWBsyqw"
    ]
  )

  static let RSA_4096 = Fixture(
    keySize: 4096,
    publicDER: """
    MIICCgKCAgEA1nWM2B1i1FJZ/I+7qFc5SSlP0/Yz7CPksUWeVauBaRvT/6SRzbHoC9bbN0xwmZmyEwBzHukiY5QCdwvdi4OGbPQqACpZxinsPwGM1ZKIGCdoDQmPS8rS5kYayo3+wLYSjxhenw/iQCf4FTMJWRIjmE+2xHFBS5urjdF0K4DwJ7k5s1tFH77VSmq66HNULNlWWomZIQDLMziz8oK+CkAHQqiMFHucfN9sRHu3Kj3nWStuw3acy6QZnmSPCETwMZQkAkpVmJF2cZFpcrsCK/1lFS8VpsDmr2dWwJCF473FcBCG647pRM8EPn/Mg73vxtyN4yKpz5CLmt5aY1dn/wvET8oziFVMU156OJV+6LDVhS7IG8UmMjSvwZ07STg6y8Co24aAcRrwftsBtcVrBryA8kYd4iXMbPHW++dnY6sMek5ebyj5mIfeOO7IgEl53SYK7PrOlTagMqvR1/WdajcOcYWGOFyubcwRTDk/eFJ9kBP1CuSjBS5DC88LtAeAtMUfbpAIAZKRHYhKS/+BbWbJXG2B3/4fJT8PP0LrzDFx6QxVNVt3db5MdGRg8FDowSzWGqsIMXKcYFdY8yquaOo7XVEXiqgVOMlSa7Ui7nXzIn32iwAuAR4zfbYEDpM5qyunIOZA95Ab8IZH5RnPO9RITQFX/5T704SN5KZBxbKNGmcCAwEAAQ==
    """,
    privateDER: """
    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
    """,
    rawMessage: "CryptoSwift RSA Keys!",
    encryptedMessage: [
      "algid:encrypt:RSA:raw": "JpQpn5D6/kBPI0SFXlX2thIjSIwZTcPuT752JJaIUic35rXc3V13GumpXxIe6uZsksLPgDWIuzzYjWmbQOdc7qgjnUZLJT1thjMxW9Icy/P4heGOIMcat2cg0MU0JJlgcr3vgt14AsCL7K2LFTskwy3vV4k2tLwD25NY4lLTMGcnq2iQ60Nkg1tXkUD5QqE1mQBasc1vIlRpobWlaICL9WW/wC+qjpPM7lOzp+Dqw1X/LG/JnHZjXyclQdnN7/07uioqhKGeqLQtFwSyORPdM/FAp/o+k9NSUiKtpjCuvnaBiJEY18E7PbuLbH76FtaPfMjFN/f7mC4eHZCqUEWvim3Uu1JmLIgcQETVCMHtISODBsVKST8mcKYZqoaxGsMHwDgSs1bCscSYijWHRgGXmabi7KF0qqLKLYqDlXKBKgloggkPqF+3joh0tunhZ90/0kks0jLPmurhZyBKUoTU1lAM6QtzN+/iQ7hr6/yPNAtpS5P7K/GQM4sK+f7JM6Y378yH659JgAstHlqP7XPZJok78bg3jdn7rOByeNXPr+T3u5vocEcoC0VieulKiI2ogE3S+QBFXr18fWa2vwMayP4VECfnFQeO6gZcyDWfE66FBBLttfFBDRIq6QO3FlMCM77w3ELTIS7Ytp9NAZam7H2OAw7iY+mK9SJ7dgqoUdM=",
      "algid:encrypt:RSA:PKCS1": "rlSXp5pvs+D6vNfkLHrlI2tQ0FVTwrsXHK3tyHnoeoWR9dD2APDIEk95sHt36l9zg9MlrK33HqjlGYSlRuFrf/Dhbr3cCz7SbvoAgCw86dMcEzmWs9PQYuDTDgLzIaemlXbA4FRkLEM32TeUNMqV9LafHjH/MVAx2tL0Yt0/Ges20F6WUpdQwxDq6ESNWcCtet78bot2TEceMOLpLo+yhhQAwW7xlfpKQy4Jpg15U3CNiax2k+54U0D632xOlWkaIZy9PS6Mwx0im79gQlZLTLLBaHhEwffVV+WfFUhSye9rDu3jyeenLIZ9Zmsr7SEwpgdg+0bGGbfZjGWi0ek36KOBP2g9qDEz6w0gzyLfBgndrpEk2kiZU56Wu27tYSUr5M/nUgImGnzH0jViaBNaZgei+VS8mlnxQNkNzgTY8by779ijp0nmsmnMJkjtJbcLNwXqGfM9NsMOGolU6ilGXLWw7dFwz4qCKueCVPxn5+4zAwL1zbT0zZgBGxE1xFWeiNldW2bSZ1tohfN1yQ53lw6K3zJitaFdpYzVr3TwSeALpHx9ne95lsXc2kKhXYIGsfIBSfsyF4/+nm4VNBSpb3MuynZOlAjI8N/FdtHRm2Q8UDr7KiPrfB0+SPHJcuQY2jpHkrzuNeemkbBi5BGH94IHNwM0zCCCl12d1KkaqpY="
    ]
  )
}
