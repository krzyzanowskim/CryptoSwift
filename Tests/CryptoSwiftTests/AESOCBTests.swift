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

import Foundation
import XCTest
@testable import CryptoSwift

final class OCBTests: XCTestCase {

  struct TestFixture {
    let N: Array<UInt8>
    let A: Array<UInt8>
    let P: Array<UInt8>
    let C: Array<UInt8>
  }

  func testAESOCBWithRFC7253Tests() {

    let K = Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F")

    let fixtures = [
      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221100"),
                  A: Array<UInt8>(hex: ""),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "785407BFFFC8AD9EDCC5520AC9111EE6")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221101"),
                  A: Array<UInt8>(hex: "0001020304050607"),
                  P: Array<UInt8>(hex: "0001020304050607"),
                  C: Array<UInt8>(hex: "6820B3657B6F615A5725BDA0D3B4EB3A257C9AF1F8F03009")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221102"),
                  A: Array<UInt8>(hex: "0001020304050607"),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "81017F8203F081277152FADE694A0A00")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221103"),
                  A: Array<UInt8>(hex: ""),
                  P: Array<UInt8>(hex: "0001020304050607"),
                  C: Array<UInt8>(hex: "45DD69F8F5AAE72414054CD1F35D82760B2CD00D2F99BFA9")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221104"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  C: Array<UInt8>(hex: "571D535B60B277188BE5147170A9A22C3AD7A4FF3835B8C5701C1CCEC8FC3358")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221105"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "8CF761B6902EF764462AD86498CA6B97")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221106"),
                  A: Array<UInt8>(hex: ""),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F"),
                  C: Array<UInt8>(hex: "5CE88EC2E0692706A915C00AEB8B2396F40E1C743F52436BDF06D8FA1ECA343D")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221107"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F1011121314151617"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F1011121314151617"),
                  C: Array<UInt8>(hex: "1CA2207308C87C010756104D8840CE1952F09673A448A122C92C62241051F57356D7F3C90BB0E07F")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221108"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F1011121314151617"),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "6DC225A071FC1B9F7C69F93B0F1E10DE")),

      TestFixture(N: Array<UInt8>(hex: "BBAA99887766554433221109"),
                  A: Array<UInt8>(hex: ""),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F1011121314151617"),
                  C: Array<UInt8>(hex: "221BD0DE7FA6FE993ECCD769460A0AF2D6CDED0C395B1C3CE725F32494B9F914D85C0B1EB38357FF")),

      TestFixture(N: Array<UInt8>(hex: "BBAA9988776655443322110A"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F"),
                  C: Array<UInt8>(hex: "BD6F6C496201C69296C11EFD138A467ABD3C707924B964DEAFFC40319AF5A48540FBBA186C5553C68AD9F592A79A4240")),

      TestFixture(N: Array<UInt8>(hex: "BBAA9988776655443322110B"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F"),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "FE80690BEE8A485D11F32965BC9D2A32")),

      TestFixture(N: Array<UInt8>(hex: "BBAA9988776655443322110C"),
                  A: Array<UInt8>(hex: ""),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F"),
                  C: Array<UInt8>(hex: "2942BFC773BDA23CABC6ACFD9BFD5835BD300F0973792EF46040C53F1432BCDFB5E1DDE3BC18A5F840B52E653444D5DF")),

      TestFixture(N: Array<UInt8>(hex: "BBAA9988776655443322110D"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627"),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627"),
                  C: Array<UInt8>(hex: "D5CA91748410C1751FF8A2F618255B68A0A12E093FF454606E59F9C1D0DDC54B65E8628E568BAD7AED07BA06A4A69483A7035490C5769E60")),

      TestFixture(N: Array<UInt8>(hex: "BBAA9988776655443322110E"),
                  A: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627"),
                  P: Array<UInt8>(hex: ""),
                  C: Array<UInt8>(hex: "C5CD9D1850C141E358649994EE701B68")),

      TestFixture(N: Array<UInt8>(hex: "BBAA9988776655443322110F"),
                  A: Array<UInt8>(hex: ""),
                  P: Array<UInt8>(hex: "000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627"),
                  C: Array<UInt8>(hex: "4412923493C57D5DE0D700F753CCE0D1D2D95060122E9F15A5DDBFC5787E50B5CC55EE507BCB084E479AD363AC366B95A98CA5F3000B1479")),
    ]

    func testEncrypt(fixture: TestFixture) -> Bool {
      let ocb = OCB(nonce: fixture.N, additionalAuthenticatedData: fixture.A, mode: .combined)
      let aes = try! AES(key: K, blockMode: ocb, padding: .noPadding)
      let encrypted = try! aes.encrypt(fixture.P)
      if encrypted != fixture.C {
        return false
      }
      return true
    }

    func testDecrypt(fixture: TestFixture) -> Bool {
      let ocb = OCB(nonce: fixture.N, additionalAuthenticatedData: fixture.A, mode: .combined)
      let aes = try! AES(key: K, blockMode: ocb, padding: .noPadding)
      let plaintext = try! aes.decrypt(fixture.C)
      if plaintext != fixture.P {
        return false
      }
      return true
    }

    func testInvalidTag(fixture: TestFixture) -> Bool {
      let ocb = OCB(nonce: fixture.N, additionalAuthenticatedData: fixture.A, mode: .combined)
      let aes = try! AES(key: K, blockMode: ocb, padding: .noPadding)
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
