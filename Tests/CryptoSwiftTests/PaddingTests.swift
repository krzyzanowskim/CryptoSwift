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

import XCTest
@testable import CryptoSwift

final class PaddingTests: XCTestCase {
  func testPKCS7_0() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16]
    let padded = PKCS7.Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded, expected, "PKCS7 failed")
    let clean = PKCS7.Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "PKCS7 failed")
  }

  func testPKCS7_1() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 1]
    let padded = PKCS7.Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded, expected, "PKCS7 failed")
    let clean = PKCS7.Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "PKCS7 failed")
  }

  func testPKCS7_2() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 2, 2]
    let padded = PKCS7.Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded, expected, "PKCS7 failed")
    let clean = PKCS7.Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "PKCS7 failed")
  }

  func testZeroPadding1() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0]
    let padding = ZeroPadding()
    XCTAssertEqual(padding.add(to: input, blockSize: 16), expected, "ZeroPadding failed")
    XCTAssertEqual(padding.remove(from: padding.add(to: input, blockSize: 16), blockSize: 16), input, "ZeroPadding failed")
  }

  func testZeroPadding2() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let padding = ZeroPadding()
    XCTAssertEqual(padding.add(to: input, blockSize: 16), expected, "ZeroPadding failed")
    XCTAssertEqual(padding.remove(from: padding.add(to: input, blockSize: 16), blockSize: 16), input, "ZeroPadding failed")
  }

  func testISO78164_0() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 0x80]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 0x80, 0x80]
    let padded = ISO78164Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded, expected, "ISO78164 failed")
    let clean = ISO78164Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "ISO78164 failed")
  }

  func testISO78164_1() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 0]
    let expected: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 0, 0x80] + [UInt8](repeating: UInt8(0), count: 15)
    let padded = ISO78164Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded, expected, "ISO78164 failed")
    let clean = ISO78164Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "ISO78164 failed")
  }

  func testISO78164_2() {
    let input: Array<UInt8> = []
    let expected: Array<UInt8> = [0x80] + [UInt8](repeating: UInt8(0), count: 15)
    let padded = ISO78164Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded, expected, "ISO78164 failed")
    let clean = ISO78164Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "ISO78164 failed")
  }

  func testISO10126_0() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3]
    let padded = ISO10126Padding().add(to: input, blockSize: 16)
    XCTAssertTrue(padded.starts(with: input), "ISO10126 failed")
    XCTAssertEqual(padded.last, 3, "ISO10126 failed")
    XCTAssertEqual(padded.count, 16)
    let clean = ISO10126Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "ISO10126 failed")
  }

  func testISO10126_1() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let padded = ISO10126Padding().add(to: input, blockSize: 16)
    XCTAssertTrue(padded.starts(with: input), "ISO10126 failed")
    XCTAssertEqual(padded.last, 16, "ISO10126 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = ISO10126Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "ISO10126 failed")
  }

  func testISO10126_2() {
    let input: Array<UInt8> = []
    let padded = ISO10126Padding().add(to: input, blockSize: 16)
    XCTAssertTrue(padded.starts(with: input), "ISO10126 failed")
    XCTAssertEqual(padded.last, 16, "ISO10126 failed")
    XCTAssertEqual(padded.count, 16)
    let clean = ISO10126Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "ISO10126 failed")
  }

  func testEMSAPKCS1v15_1() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let padded = EMSAPKCS1v15Padding().add(to: input, blockSize: 32)
    XCTAssertEqual(padded.prefix(2), [0, 1], "EMSAPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(16) == input, "EMSAPKCS1v15 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = EMSAPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMSAPKCS1v15 failed")
  }

  func testEMSAPKCS1v15_2() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let padded = EMSAPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded.prefix(2), [0, 1], "EMSAPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(16) == input, "EMSAPKCS1v15 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = EMSAPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMSAPKCS1v15 failed")
  }

  func testEMSAPKCS1v15_3() {
    let input: Array<UInt8> = []
    let padded = EMSAPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertTrue(padded.starts(with: input), "EMSAPKCS1v15 failed")
    XCTAssertEqual(padded.last, 0, "EMSAPKCS1v15 failed")
    XCTAssertEqual(padded.count, 16)
    let clean = EMSAPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMSAPKCS1v15 failed")
  }

  func testEMSAPKCS1v15_4() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3]
    let padded = EMSAPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded.prefix(2), [0, 1], "EMSAPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(13) == input, "EMSAPKCS1v15 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = EMSAPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMSAPKCS1v15 failed")
  }

  func testEMSAPKCS1v15_5() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
    let padded = EMSAPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded.prefix(2), [0, 1], "EMSAPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(12) == input, "EMSAPKCS1v15 failed")
    XCTAssertEqual(padded.count, 16)
    let clean = EMSAPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMSAPKCS1v15 failed")
  }

  func testEMEPKCS1v15_1() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let padded = EMEPKCS1v15Padding().add(to: input, blockSize: 32)
    XCTAssertEqual(padded.prefix(2), [0, 2], "EMEPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(16) == input, "EMEPKCS1v15 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = EMEPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMEPKCS1v15 failed")
  }

  func testEMEPKCS1v15_2() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6]
    let padded = EMEPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded.prefix(2), [0, 2], "EMEPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(16) == input, "EMEPKCS1v15 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = EMEPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMEPKCS1v15 failed")
  }

  func testEMEPKCS1v15_3() {
    let input: Array<UInt8> = []
    let padded = EMEPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertTrue(padded.starts(with: input), "EMEPKCS1v15 failed")
    XCTAssertEqual(padded.last, 0, "EMEPKCS1v15 failed")
    XCTAssertEqual(padded.count, 16)
    let clean = EMEPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMEPKCS1v15 failed")
  }

  func testEMEPKCS1v15_4() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3]
    let padded = EMEPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded.prefix(2), [0, 2], "EMEPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(13) == input, "EMEPKCS1v15 failed")
    XCTAssertEqual(padded.count, 32)
    let clean = EMEPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMEPKCS1v15 failed")
  }

  func testEMEPKCS1v15_5() {
    let input: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
    let padded = EMEPKCS1v15Padding().add(to: input, blockSize: 16)
    XCTAssertEqual(padded.prefix(2), [0, 2], "EMEPKCS1v15 failed")
    XCTAssertTrue(padded.suffix(12) == input, "EMEPKCS1v15 failed")
    XCTAssertEqual(padded.count, 16)
    let clean = EMEPKCS1v15Padding().remove(from: padded, blockSize: nil)
    XCTAssertEqual(clean, input, "EMEPKCS1v15 failed")
  }

  static let allTests = [
    ("testPKCS7_0", testPKCS7_0),
    ("testPKCS7_1", testPKCS7_1),
    ("testPKCS7_2", testPKCS7_2),
    ("testZeroPadding1", testZeroPadding1),
    ("testZeroPadding2", testZeroPadding2),
    ("testISO78164_0", testISO78164_0),
    ("testISO78164_1", testISO78164_1),
    ("testISO78164_2", testISO78164_2),
    ("testISO10126_0", testISO10126_0),
    ("testISO10126_1", testISO10126_1),
    ("testISO10126_2", testISO10126_2),
    ("testEMSAPKCS1v15_1", testEMSAPKCS1v15_1),
    ("testEMSAPKCS1v15_2", testEMSAPKCS1v15_2),
    ("testEMSAPKCS1v15_3", testEMSAPKCS1v15_3),
    ("testEMSAPKCS1v15_4", testEMSAPKCS1v15_4),
    ("testEMSAPKCS1v15_5", testEMSAPKCS1v15_5),
    ("testEMEPKCS1v15_1", testEMEPKCS1v15_1),
    ("testEMEPKCS1v15_2", testEMEPKCS1v15_2),
    ("testEMEPKCS1v15_3", testEMEPKCS1v15_3),
    ("testEMEPKCS1v15_4", testEMEPKCS1v15_4),
    ("testEMEPKCS1v15_5", testEMEPKCS1v15_5),
  ]
}
