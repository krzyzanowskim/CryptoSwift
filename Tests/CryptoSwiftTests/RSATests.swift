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
  
  let n: Array<UInt8> = [
    0xba, 0xd4, 0x7a, 0x84, 0xc1, 0x78, 0x2e, 0x4d, 0xbd, 0xd9, 0x13, 0xf2, 0xa2, 0x61, 0xfc, 0x8b,
    0x65, 0x83, 0x84, 0x12, 0xc6, 0xe4, 0x5a, 0x20, 0x68, 0xed, 0x6d, 0x7f, 0x16, 0xe9, 0xcd, 0xf4,
    0x46, 0x2b, 0x39, 0x11, 0x95, 0x63, 0xca, 0xfb, 0x74, 0xb9, 0xcb, 0xf2, 0x5c, 0xfd, 0x54, 0x4b,
    0xda, 0xe2, 0x3b, 0xff, 0x0e, 0xbe, 0x7f, 0x64, 0x41, 0x04, 0x2b, 0x7e, 0x10, 0x9b, 0x9a, 0x8a,
    0xfa, 0xa0, 0x56, 0x82, 0x1e, 0xf8, 0xef, 0xaa, 0xb2, 0x19, 0xd2, 0x1d, 0x67, 0x63, 0x48, 0x47,
    0x85, 0x62, 0x2d, 0x91, 0x8d, 0x39, 0x5a, 0x2a, 0x31, 0xf2, 0xec, 0xe8, 0x38, 0x5a, 0x81, 0x31,
    0xe5, 0xff, 0x14, 0x33, 0x14, 0xa8, 0x2e, 0x21, 0xaf, 0xd7, 0x13, 0xba, 0xe8, 0x17, 0xcc, 0x0e,
    0xe3, 0x51, 0x4d, 0x48, 0x39, 0x00, 0x7c, 0xcb, 0x55, 0xd6, 0x84, 0x09, 0xc9, 0x7a, 0x18, 0xab,
    0x62, 0xfa, 0x6f, 0x9f, 0x89, 0xb3, 0xf9, 0x4a, 0x27, 0x77, 0xc4, 0x7d, 0x61, 0x36, 0x77, 0x5a,
    0x56, 0xa9, 0xa0, 0x12, 0x7f, 0x68, 0x24, 0x70, 0xbe, 0xf8, 0x31, 0xfb, 0xec, 0x4b, 0xcd, 0x7b,
    0x50, 0x95, 0xa7, 0x82, 0x3f, 0xd7, 0x07, 0x45, 0xd3, 0x7d, 0x1b, 0xf7, 0x2b, 0x63, 0xc4, 0xb1,
    0xb4, 0xa3, 0xd0, 0x58, 0x1e, 0x74, 0xbf, 0x9a, 0xde, 0x93, 0xcc, 0x46, 0x14, 0x86, 0x17, 0x55,
    0x39, 0x31, 0xa7, 0x9d, 0x92, 0xe9, 0xe4, 0x88, 0xef, 0x47, 0x22, 0x3e, 0xe6, 0xf6, 0xc0, 0x61,
    0x88, 0x4b, 0x13, 0xc9, 0x06, 0x5b, 0x59, 0x11, 0x39, 0xde, 0x13, 0xc1, 0xea, 0x29, 0x27, 0x49,
    0x1e, 0xd0, 0x0f, 0xb7, 0x93, 0xcd, 0x68, 0xf4, 0x63, 0xf5, 0xf6, 0x4b, 0xaa, 0x53, 0x91, 0x6b,
    0x46, 0xc8, 0x18, 0xab, 0x99, 0x70, 0x65, 0x57, 0xa1, 0xc2, 0xd5, 0x0d, 0x23, 0x25, 0x77, 0xd1
  ]
  let e: Array<UInt8> = [
    0x01, 0x00, 0x01
  ]
  let d: Array<UInt8> = [
    0x40, 0xd6, 0x0f, 0x24, 0xb6, 0x1d, 0x76, 0x78, 0x3d, 0x3b, 0xb1, 0xdc, 0x00, 0xb5, 0x5f, 0x96,
    0xa2, 0xa6, 0x86, 0xf5, 0x9b, 0x37, 0x50, 0xfd, 0xb1, 0x5c, 0x40, 0x25, 0x1c, 0x37, 0x0c, 0x65,
    0xca, 0xda, 0x22, 0x26, 0x73, 0x81, 0x1b, 0xc6, 0xb3, 0x05, 0xed, 0x7c, 0x90, 0xff, 0xcb, 0x3a,
    0xbd, 0xdd, 0xc8, 0x33, 0x66, 0x12, 0xff, 0x13, 0xb4, 0x2a, 0x75, 0xcb, 0x7c, 0x88, 0xfb, 0x93,
    0x62, 0x91, 0xb5, 0x23, 0xd8, 0x0a, 0xcc, 0xe5, 0xa0, 0x84, 0x2c, 0x72, 0x4e, 0xd8, 0x5a, 0x13,
    0x93, 0xfa, 0xf3, 0xd4, 0x70, 0xbd, 0xa8, 0x08, 0x3f, 0xa8, 0x4d, 0xc5, 0xf3, 0x14, 0x99, 0x84,
    0x4f, 0x0c, 0x7c, 0x1e, 0x93, 0xfb, 0x1f, 0x73, 0x4a, 0x5a, 0x29, 0xfb, 0x31, 0xa3, 0x5c, 0x8a,
    0x08, 0x22, 0x45, 0x5f, 0x1c, 0x85, 0x0a, 0x49, 0xe8, 0x62, 0x97, 0x14, 0xec, 0x6a, 0x26, 0x57,
    0xef, 0xe7, 0x5e, 0xc1, 0xca, 0x6e, 0x62, 0xf9, 0xa3, 0x75, 0x6c, 0x9b, 0x20, 0xb4, 0x85, 0x5b,
    0xdc, 0x9a, 0x3a, 0xb5, 0x8c, 0x43, 0xd8, 0xaf, 0x85, 0xb8, 0x37, 0xa7, 0xfd, 0x15, 0xaa, 0x11,
    0x49, 0xc1, 0x19, 0xcf, 0xe9, 0x60, 0xc0, 0x5a, 0x9d, 0x4c, 0xea, 0x69, 0xc9, 0xfb, 0x6a, 0x89,
    0x71, 0x45, 0x67, 0x48, 0x82, 0xbf, 0x57, 0x24, 0x1d, 0x77, 0xc0, 0x54, 0xdc, 0x4c, 0x94, 0xe8,
    0x34, 0x9d, 0x37, 0x62, 0x96, 0x13, 0x7e, 0xb4, 0x21, 0x68, 0x61, 0x59, 0xcb, 0x87, 0x8d, 0x15,
    0xd1, 0x71, 0xed, 0xa8, 0x69, 0x28, 0x34, 0xaf, 0xc8, 0x71, 0x98, 0x8f, 0x20, 0x3f, 0xc8, 0x22,
    0xc5, 0xdc, 0xee, 0x7f, 0x6c, 0x48, 0xdf, 0x66, 0x3e, 0xa3, 0xdc, 0x75, 0x5e, 0x7d, 0xc0, 0x6a,
    0xeb, 0xd4, 0x1d, 0x05, 0xf1, 0xca, 0x28, 0x91, 0xe2, 0x67, 0x97, 0x83, 0x24, 0x4d, 0x06, 0x8f
  ]
  let EM: Array<UInt8> = [
    0x70, 0x99, 0x2c, 0x9d, 0x95, 0xa4, 0x90, 0x8d, 0x2a, 0x94, 0xb3, 0xab, 0x9f, 0xa1, 0xcd, 0x64,
    0x3f, 0x12, 0x0e, 0x32, 0x6f, 0x9d, 0x78, 0x08, 0xaf, 0x50, 0xca, 0xc4, 0x2c, 0x4b, 0x0b, 0x4e,
    0xeb, 0x7f, 0x0d, 0x4d, 0xf3, 0x03, 0xa5, 0x68, 0xfb, 0xfb, 0x82, 0xb0, 0xf5, 0x83, 0x00, 0xd2,
    0x53, 0x57, 0x64, 0x57, 0x21, 0xbb, 0x71, 0x86, 0x1c, 0xaf, 0x81, 0xb2, 0x7a, 0x56, 0x08, 0x2c,
    0x80, 0xa1, 0x46, 0x49, 0x9f, 0xb4, 0xea, 0xb5, 0xbd, 0xe4, 0x49, 0x3f, 0x5d, 0x00, 0xf1, 0xa4,
    0x37, 0xbb, 0xc3, 0x60, 0xdf, 0xcd, 0x80, 0x56, 0xfe, 0x6b, 0xe1, 0x0e, 0x60, 0x8a, 0xdb, 0x30,
    0xb6, 0xc2, 0xf7, 0x65, 0x24, 0x28, 0xb8, 0xd3, 0x2d, 0x36, 0x29, 0x45, 0x98, 0x2a, 0x46, 0x58,
    0x5d, 0x21, 0x02, 0xef, 0x79, 0x95, 0xa8, 0xba, 0x6e, 0x8a, 0xd8, 0xfd, 0x16, 0xbd, 0x7a, 0xe8,
    0xf5, 0x3c, 0x3d, 0x7f, 0xcf, 0xba, 0x29, 0x0b, 0x57, 0xce, 0x7f, 0x8f, 0x09, 0xc8, 0x28, 0xd6,
    0xf2, 0xd3, 0xce, 0x56, 0xf1, 0x31, 0xbd, 0x94, 0x61, 0xe5, 0x66, 0x7e, 0x5b, 0x73, 0xed, 0xac,
    0x77, 0xf5, 0x04, 0xda, 0xc4, 0xf2, 0x02, 0xa9, 0x57, 0x0e, 0xb4, 0x51, 0x5b, 0x2b, 0xf5, 0x16,
    0x40, 0x7d, 0xb8, 0x31, 0x51, 0x8d, 0xb8, 0xa2, 0x08, 0x3e, 0xc7, 0x01, 0xe8, 0xfd, 0x38, 0x7c,
    0x43, 0x0b, 0xb1, 0xa7, 0x2d, 0xec, 0xa5, 0xb4, 0x9d, 0x42, 0x9c, 0xf9, 0xde, 0xb0, 0x9c, 0xc4,
    0x51, 0x8d, 0xc5, 0xf5, 0x7c, 0x08, 0x9a, 0xa2, 0xd3, 0x42, 0x0e, 0x56, 0x7e, 0x73, 0x21, 0x02,
    0xc2, 0xc9, 0x2b, 0x88, 0xa0, 0x7c, 0x69, 0xd7, 0x09, 0x17, 0x14, 0x0a, 0xb3, 0x82, 0x3c, 0x63,
    0xf3, 0x12, 0xd3, 0xf1, 0x1f, 0xa8, 0x7b, 0xa2, 0x9d, 0xa3, 0xc7, 0x22, 0x4b, 0x4f, 0xb4, 0xbc
  ]
  let S: Array<UInt8> = [
    0x7e, 0x65, 0xb9, 0x98, 0xa0, 0x5f, 0x62, 0x6b, 0x02, 0x8c, 0x75, 0xdc, 0x3f, 0xbf, 0x98, 0x96,
    0x3d, 0xce, 0x66, 0xd0, 0xf4, 0xc3, 0xae, 0x42, 0x37, 0xcf, 0xf3, 0x04, 0xd8, 0x4d, 0x88, 0x36,
    0xcb, 0x6b, 0xad, 0x9a, 0xc8, 0x6f, 0x9d, 0x1b, 0x8a, 0x28, 0xdd, 0x70, 0x40, 0x47, 0x88, 0xb8,
    0x69, 0xd2, 0x42, 0x9f, 0x1e, 0xc0, 0x66, 0x3e, 0x51, 0xb7, 0x53, 0xf7, 0x45, 0x1c, 0x6b, 0x46,
    0x45, 0xd9, 0x91, 0x26, 0xe4, 0x57, 0xc1, 0xda, 0xc4, 0x95, 0x51, 0xd8, 0x6a, 0x8a, 0x97, 0x4a,
    0x31, 0x31, 0xe9, 0xb3, 0x71, 0xd5, 0xc2, 0x14, 0xcc, 0x9f, 0xf2, 0x40, 0xc2, 0x99, 0xbd, 0x0e,
    0x62, 0xdb, 0xc7, 0xa9, 0xa2, 0xda, 0xd9, 0xfa, 0x54, 0x04, 0xad, 0xb0, 0x06, 0x32, 0xd3, 0x63,
    0x32, 0xd5, 0xbe, 0x61, 0x06, 0xe9, 0xe6, 0xec, 0x81, 0xca, 0xc4, 0x5c, 0xd3, 0x39, 0xcc, 0x87,
    0xab, 0xbe, 0x7f, 0x89, 0x43, 0x08, 0x00, 0xe1, 0x6e, 0x03, 0x2a, 0x66, 0x21, 0x0b, 0x25, 0xe9,
    0x26, 0xed, 0xa2, 0x43, 0xd9, 0xf0, 0x99, 0x55, 0x49, 0x6d, 0xdb, 0xc7, 0x7e, 0xf7, 0x4f, 0x17,
    0xfe, 0xe4, 0x1c, 0x44, 0x35, 0xe7, 0x8b, 0x46, 0x96, 0x5b, 0x71, 0x3d, 0x72, 0xce, 0x8a, 0x31,
    0xaf, 0x64, 0x15, 0x38, 0xad, 0xd3, 0x87, 0xfe, 0xdf, 0xd8, 0x8b, 0xb2, 0x2a, 0x42, 0xeb, 0x3b,
    0xda, 0x40, 0xf7, 0x2e, 0xca, 0xd9, 0x41, 0xdb, 0xff, 0xdd, 0x47, 0xb3, 0xe7, 0x77, 0x37, 0xda,
    0x74, 0x15, 0x53, 0xa4, 0x5b, 0x63, 0x0d, 0x07, 0x0b, 0xcc, 0x52, 0x05, 0x80, 0x4b, 0xf8, 0x0e,
    0xe2, 0xd5, 0x16, 0x12, 0x87, 0x5d, 0xbc, 0x47, 0x96, 0x96, 0x00, 0x52, 0xf1, 0x68, 0x7e, 0x00,
    0x74, 0x00, 0x7e, 0x6a, 0x33, 0xab, 0x8b, 0x20, 0x85, 0xc0, 0x33, 0xf9, 0x89, 0x2b, 0x6f, 0x74
  ]

  func testRSA1() {
    let rsa = RSA(n: n, e: e, d: d)
    XCTAssertEqual(rsa.keySize, 2048, "key size is not correct")
    
    let encrypted = try! rsa.encrypt(EM)
    XCTAssertEqual(encrypted, S, "encrypt failed")
    
    //let decrypted = try! rsa.decrypt(S)
    //XCTAssertEqual(decrypted, EM, "decrypt failed")
  }

}

extension RSATests {
  static func allTests() -> [(String, (RSATests) -> () -> Void)] {
    let tests = [
      ("testRSA1", testRSA1)
    ]

    return tests
  }
}