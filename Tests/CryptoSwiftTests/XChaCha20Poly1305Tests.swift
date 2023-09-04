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

class XChaCha20Poly1305Tests: XCTestCase {

  /// See: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#appendix-A.3.1
  func testRoundTrip() {
    do {
      let plaintext: Array<UInt8> = .init(
        hex: """
        4c616469657320616e642047656e746c656d656e206f662074686520636c6173
        73206f66202739393a204966204920636f756c64206f6666657220796f75206f
        6e6c79206f6e652074697020666f7220746865206675747572652c2073756e73
        637265656e20776f756c642062652069742e
        """.replacingOccurrences(of: "\n", with: "")
      )
      let aad: Array<UInt8> = .init(
        hex: "50515253c0c1c2c3c4c5c6c7")
      let key: Array<UInt8> = .init(
        hex: "808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f")
      let iv: Array<UInt8> = .init(
        hex: "404142434445464748494a4b4c4d4e4f5051525354555657")

      let encryptResult = try AEADXChaCha20Poly1305.encrypt(
        plaintext,
        key: key,
        iv: iv,
        authenticationHeader: aad
      )

      XCTAssertEqual(
        encryptResult.cipherText.toHexString(),
        """
        bd6d179d3e83d43b9576579493c0e939572a1700252bfaccbed2902c21396cbb
        731c7f1b0b4aa6440bf3a82f4eda7e39ae64c6708c54c216cb96b72e1213b452
        2f8c9ba40db5d945b11b69b982c1bb9e3f3fac2bc369488f76b2383565d3fff9
        21f9664c97637da9768812f615c68b13b52e
        """.replacingOccurrences(of: "\n", with: "")
      )

      XCTAssertEqual(
        encryptResult.authenticationTag.toHexString(),
        "c0875924c1c7987947deafd8780acf49"
      )

      let decryptResult = try AEADXChaCha20Poly1305.decrypt(
        encryptResult.cipherText,
        key: key,
        iv: iv,
        authenticationHeader: aad,
        authenticationTag: encryptResult.authenticationTag
      )

      XCTAssertEqual(decryptResult.plainText, plaintext)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }

  static let allTests = [
    ("Test Vector for AEAD_XCHACHA20_POLY1305", testRoundTrip)
  ]
}
