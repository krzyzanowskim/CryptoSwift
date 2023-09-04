//
//  CryptoSwift
//
//  Copyright (C) Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

final class XChaCha20Tests: XCTestCase {

  /// See: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#section-2.2.1
  func testHChaCha20BlockFunction() {
    let key: Array<UInt8> = .init(
      hex: "00:01:02:03:04:05:06:07:08:09:0a:0b:0c:0d:0e:0f:10:11:12:13:14:15:16:17:18:19:1a:1b:1c:1d:1e:1f".replacingOccurrences(of: ":", with: ""))
    let counter: Array<UInt8> = .init(
      hex: "00:00:00:09:00:00:00:4a:00:00:00:00:31:41:59:27".replacingOccurrences(of: ":", with: ""))
    XCTAssertEqual(
      XChaCha20.hChaCha20(key: key, nonce: counter).toHexString(),
      """
      82413b42 27b27bfe d30e4250 8a877d73
      a0f9e4d5 8a74a853 c12ec413 26d3ecdc
      """.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    )
  }

  // See: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#appendix-A.3.2.1

  let plaintext: Array<UInt8> = .init(
    hex: """
    5468652064686f6c65202870726f6e6f756e6365642022646f6c652229206973
    20616c736f206b6e6f776e2061732074686520417369617469632077696c6420
    646f672c2072656420646f672c20616e642077686973746c696e6720646f672e
    2049742069732061626f7574207468652073697a65206f662061204765726d61
    6e20736865706865726420627574206c6f6f6b73206d6f7265206c696b652061
    206c6f6e672d6c656767656420666f782e205468697320686967686c7920656c
    757369766520616e6420736b696c6c6564206a756d70657220697320636c6173
    736966696564207769746820776f6c7665732c20636f796f7465732c206a6163
    6b616c732c20616e6420666f78657320696e20746865207461786f6e6f6d6963
    2066616d696c792043616e696461652e
    """.replacingOccurrences(of: "\n", with: ""))
  let key: Array<UInt8> = .init(hex: "808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f")
  let iv: Array<UInt8> = .init(hex: "404142434445464748494a4b4c4d4e4f5051525354555658")
  let expectedResult0 = """
  4559abba4e48c16102e8bb2c05e6947f50a786de162f9b0b7e592a9b53d0d4e9
  8d8d6410d540a1a6375b26d80dace4fab52384c731acbf16a5923c0c48d3575d
  4d0d2c673b666faa731061277701093a6bf7a158a8864292a41c48e3a9b4c0da
  ece0f8d98d0d7e05b37a307bbb66333164ec9e1b24ea0d6c3ffddcec4f68e744
  3056193a03c810e11344ca06d8ed8a2bfb1e8d48cfa6bc0eb4e2464b74814240
  7c9f431aee769960e15ba8b96890466ef2457599852385c661f752ce20f9da0c
  09ab6b19df74e76a95967446f8d0fd415e7bee2a12a114c20eb5292ae7a349ae
  577820d5520a1f3fb62a17ce6a7e68fa7c79111d8860920bc048ef43fe84486c
  cb87c25f0ae045f0cce1e7989a9aa220a28bdd4827e751a24a6d5c62d790a663
  93b93111c1a55dd7421a10184974c7c5
  """.replacingOccurrences(of: "\n", with: "")

  func testXChaCha20() {
    do {
      let actualResult0 = try XChaCha20(key: key, iv: iv, blockCounter: 0).encrypt(self.plaintext).toHexString()
      XCTAssertEqual(actualResult0, self.expectedResult0)

      // See: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#appendix-A.3.2.2
      let actualResult1 = try XChaCha20(key: key, iv: iv, blockCounter: 1).encrypt(self.plaintext).toHexString()
      XCTAssertEqual(
        actualResult1,
        """
        7d0a2e6b7f7c65a236542630294e063b7ab9b555a5d5149aa21e4ae1e4fbce87
        ecc8e08a8b5e350abe622b2ffa617b202cfad72032a3037e76ffdcdc4376ee05
        3a190d7e46ca1de04144850381b9cb29f051915386b8a710b8ac4d027b8b050f
        7cba5854e028d564e453b8a968824173fc16488b8970cac828f11ae53cabd201
        12f87107df24ee6183d2274fe4c8b1485534ef2c5fbc1ec24bfc3663efaa08bc
        047d29d25043532db8391a8a3d776bf4372a6955827ccb0cdd4af403a7ce4c63
        d595c75a43e045f0cce1f29c8b93bd65afc5974922f214a40b7c402cdb91ae73
        c0b63615cdad0480680f16515a7ace9d39236464328a37743ffc28f4ddb324f4
        d0f5bbdc270c65b1749a6efff1fbaa09536175ccd29fb9e6057b307320d31683
        8a9c71f70b5b5907a66f7ea49aadc409
        """.replacingOccurrences(of: "\n", with: "")
      )
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testXChaCha20PartialEncryption() {
    do {
      let cipher = try XChaCha20(key: key, iv: iv)
      var ciphertext = Array<UInt8>()
      var encryptor = try cipher.makeEncryptor()
      try self.plaintext.batched(by: 8).forEach { chunk in
        ciphertext += try encryptor.update(withBytes: chunk)
      }
      ciphertext += try encryptor.finish()
      XCTAssertEqual(ciphertext.toHexString(), self.expectedResult0)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  func testXChaCha20PartialDecryption() {
    do {
      let cipher = try XChaCha20(key: key, iv: iv)
      var plaintext = Array<UInt8>()
      var decryptor = try cipher.makeDecryptor()
      let ciphertext = Array<UInt8>(hex: expectedResult0)
      try ciphertext.batched(by: 8).forEach { chunk in
        plaintext += try decryptor.update(withBytes: chunk)
      }
      plaintext += try decryptor.finish()
      XCTAssertEqual(plaintext, self.plaintext)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  static func allTests() -> [(String, (XChaCha20Tests) -> () -> Void)] {
    let tests = [
      ("Test Vector for the HChaCha20 Block Function", testHChaCha20BlockFunction),
      ("Test Vectors for XChaCha20", testXChaCha20),
      ("XChaCha20 partial encryption", testXChaCha20PartialEncryption),
      ("XChaCha20 partial decryption", testXChaCha20PartialDecryption),
    ]

    return tests
  }
}
