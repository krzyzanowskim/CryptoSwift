//
//  Poly1305Tests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 29/08/14.
//  Copyright (C) 2014-2017 Krzyzanowski. All rights reserved.
//
import XCTest
import Foundation
@testable import CryptoSwift

final class Poly1305Tests: XCTestCase {

    func testPoly1305() {
        let key: Array<UInt8> = [0xdd, 0xde, 0xdf, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc]
        let msg: Array<UInt8> = [0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0xc0, 0xc1]
        let expectedMac: Array<UInt8> = [0xdd, 0xb9, 0xda, 0x7d, 0xdd, 0x5e, 0x52, 0x79, 0x27, 0x30, 0xed, 0x5c, 0xda, 0x5f, 0x90, 0xa4]

        XCTAssertEqual(try Poly1305(key: key).authenticate(msg), expectedMac)

        // extensions
        let msgData = Data(bytes: msg)
        XCTAssertEqual(try msgData.authenticate(with: Poly1305(key: key)), Data(bytes: expectedMac), "Invalid authentication result")
    }

    // https://github.com/krzyzanowskim/CryptoSwift/issues/183
    func testIssue183() {
        let key: Array<UInt8> = [111, 53, 197, 181, 1, 92, 67, 199, 37, 92, 76, 167, 12, 35, 75, 226, 198, 34, 107, 84, 79, 6, 231, 10, 25, 221, 14, 155, 81, 244, 15, 203]
        let message: Array<UInt8> = [208, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 162, 210, 40, 78, 3, 161, 87, 187, 96, 253, 104, 187, 87, 87, 249, 56, 5, 156, 122, 121, 196, 192, 254, 58, 98, 22, 47, 151, 205, 201, 108, 143, 197, 99, 182, 109, 59, 63, 172, 111, 120, 185, 175, 129, 59, 126, 68, 140, 237, 126, 175, 49, 224, 249, 245, 37, 75, 252, 69, 215, 171, 27, 163, 16, 185, 239, 184, 144, 37, 131, 242, 12, 90, 134, 24, 237, 209, 127, 71, 86, 122, 173, 238, 73, 186, 58, 102, 112, 90, 217, 243, 251, 110, 85, 106, 18, 172, 167, 179, 173, 73, 125, 9, 129, 132, 80, 70, 4, 254, 178, 211, 200, 207, 231, 232, 17, 176, 127, 153, 120, 71, 164, 139, 56, 106, 71, 96, 79, 11, 213, 243, 66, 53, 167, 108, 233, 250, 136, 69, 190, 191, 12, 136, 24, 157, 202, 49, 158, 152, 150, 34, 88, 132, 112, 74, 168, 153, 116, 31, 7, 61, 60, 22, 199, 108, 187, 209, 114, 234, 185, 247, 41, 68, 184, 95, 169, 60, 126, 73, 59, 54, 126, 162, 90, 18, 32, 230, 123, 2, 40, 74, 177, 127, 219, 93, 186, 22, 75, 251, 101, 95, 160, 68, 235, 77, 2, 10, 202, 2, 0, 0, 0, 0, 0, 0, 0, 208, 0, 0, 0, 0, 0, 0, 0]
        let expectedMac: Array<UInt8> = [68, 216, 92, 163, 164, 144, 55, 43, 185, 18, 83, 92, 41, 133, 72, 168]
        XCTAssertEqual(try message.authenticate(with: Poly1305(key: key)), expectedMac)
    }

    static let allTests = [
        ("testPoly1305", testPoly1305),
        ("testIssue183", testIssue183),
    ]
}
