//
//  CryptoSwift
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

@testable import CryptoSwift
import XCTest

class Scrypt: XCTestCase {
    
    func testScrypt_0() {
        let password = Array("password".data(using: .ascii)!)
        let salt = Array("NaCl".data(using: .ascii)!)
        let deriver = try! CryptoSwift.Scrypt(password: password, salt: salt, dkLen: 64, N: 1024, r: 8, p: 16)
        let derived = try! deriver.calculate()
        let expected: [UInt8] = Array<UInt8>.init(hex: """
                fd ba be 1c 9d 34 72 00 78 56 e7 19 0d 01 e9 fe
                7c 6a d7 cb c8 23 78 30 e7 73 76 63 4b 37 31 62
                2e af 30 d9 2e 22 a3 88 6f f1 09 27 9d 98 30 da
                c7 27 af b9 4a 83 ee 6d 83 60 cb df a2 cc 06 40
""".replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: ""))
        XCTAssertEqual(derived, expected)
    }
    
    func testScrypt_1() {
        let password = Array("pleaseletmein".data(using: .ascii)!)
        let salt = Array("SodiumChloride".data(using: .ascii)!)
        let deriver = try! CryptoSwift.Scrypt(password: password, salt: salt, dkLen: 64, N: 16384, r: 8, p: 1)
        let derived = try! deriver.calculate()
        let expected: [UInt8] = Array<UInt8>.init(hex: """
                70 23 bd cb 3a fd 73 48 46 1c 06 cd 81 fd 38 eb
                fd a8 fb ba 90 4f 8e 3e a9 b5 43 f6 54 5d a1 f2
                d5 43 29 55 61 3f 0f cf 62 d4 97 05 24 2a 9a f9
                e6 1e 85 dc 0d 65 1e 40 df cf 01 7b 45 57 58 87
""".replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: ""))
        XCTAssertEqual(derived, expected)
    }
    
//          Takes too long to run in debug mode!
    func testScrypt_2() {
        #if !DEBUG
        let password = Array("pleaseletmein".data(using: .ascii)!)
        let salt = Array("SodiumChloride".data(using: .ascii)!)
        let deriver = try! CryptoSwift.Scrypt(password: password, salt: salt, dkLen: 64, N: 1048576, r: 8, p: 1)
        let derived = try! deriver.calculate()
        let expected: [UInt8] = Array<UInt8>.init(hex: """
                21 01 cb 9b 6a 51 1a ae ad db be 09 cf 70 f8 81
                ec 56 8d 57 4a 2f fd 4d ab e5 ee 98 20 ad aa 47
                8e 56 fd 8f 4b a5 d0 9f fa 1c 6d 92 7c 40 f4 c3
                37 30 40 49 e8 a9 52 fb cb f4 5c 6f a7 7a 41 a4
""".replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: ""))
        XCTAssertEqual(derived, expected)
        #endif
    }
    
    static let allTests = [
        ("testScrypt_0", testScrypt_0),
        ("testScrypt_1", testScrypt_1),
        ("testScrypt_2", testScrypt_2)
    ]
}
