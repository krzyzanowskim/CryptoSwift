////  CryptoSwift
//
//  Copyright (C) 2014-__YEAR__ Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

class OCBTests: XCTestCase {


  struct TestFixture {
    let K: Array<UInt8>
    let N: Array<UInt8>
    let P: Array<UInt8>
    let C: Array<UInt8>
  }

  func testAESOCBWithRFC7253Tests() {

    var fixtures = [
      TestFixture(K: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  N: Array<UInt8>(hex: "BBAA99887766554433221100"),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "785407BFFFC8AD9EDCC5520AC9111EE6")),

      TestFixture(K: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  N: Array<UInt8>(hex: "BBAA99887766554433221103"),
                  P: Array<UInt8>(hex: "0001020304050607"),
                  C: Array<UInt8>(hex: "45DD69F8F5AAE72414054CD1F35D82760B2CD00D2F99BFA9")),

      TestFixture(K: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  N: Array<UInt8>(hex: "BBAA99887766554433221106"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  C: Array<UInt8>(hex: "5CE88EC2E0692706A915C00AEB8B2396F40E1C743F52436BDF06D8FA1ECA343D")),

      TestFixture(K: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  N: Array<UInt8>(hex: "BBAA99887766554433221109"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F1011121314151617"),
                  C: Array<UInt8>(hex: "221BD0DE7FA6FE993ECCD769460A0AF2D6CDED0C395B1C3CE725F32494B9F914D85C0B1EB38357FF")),

      TestFixture(K: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  N: Array<UInt8>(hex: "BBAA9988776655443322110C"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F"),
                  C: Array<UInt8>(hex: "2942BFC773BDA23CABC6ACFD9BFD5835BD300F0973792EF46040C53F1432BCDFB5E1DDE3BC18A5F840B52E653444D5DF")),

      TestFixture(K: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  N: Array<UInt8>(hex: "BBAA9988776655443322110F"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627"),
                  C: Array<UInt8>(hex: "4412923493C57D5DE0D700F753CCE0D1D2D95060122E9F15A5DDBFC5787E50B5CC55EE507BCB084E479AD363AC366B95A98CA5F3000B1479")),
    ]

    func testEncrypt(fixture: TestFixture) -> Bool {
      let ocb = OCB(nonce: fixture.N, mode: .combined)
      let aes = try! AES(key: fixture.K, blockMode: ocb, padding: .noPadding)
      let encrypted = try! aes.encrypt(fixture.P)
      if encrypted != fixture.C {
        return false
      }
      return true
    }

    func testDecrypt(fixture: TestFixture) -> Bool {
      let ocb = OCB(nonce: fixture.N, mode: .combined)
      let aes = try! AES(key: fixture.K, blockMode: ocb, padding: .noPadding)
      let plaintext = try! aes.decrypt(fixture.C)
      if plaintext != fixture.P {
        return false
      }
      return true
    }

    func testInvalidTag(fixture: TestFixture) -> Bool {
      let ocb = OCB(nonce: fixture.N, mode: .combined)
      let aes = try! AES(key: fixture.K, blockMode: ocb, padding: .noPadding)
      var C_ = fixture.C.slice
      C_[C_.count - 1] ^= 0x01
      let plaintext = try? aes.decrypt(C_)
      return plaintext == nil
    }

    for (i, fixture) in fixtures.enumerated() {
      XCTAssertTrue(testEncrypt(fixture: fixture), "Encryption failed")
      XCTAssertTrue(testDecrypt(fixture: fixture), "(\(i) - Decryption failed.")
      XCTAssertTrue(testInvalidTag(fixture: fixture), "(\(i) - Invalid Tag verification failed.")
    }
  }

  static let allTests = [
    ("testAESOCBWithRFC7253Tests", testAESOCBWithRFC7253Tests),
  ]
}
