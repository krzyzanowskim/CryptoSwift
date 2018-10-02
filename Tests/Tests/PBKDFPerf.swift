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

class PBKDFPerf: XCTestCase {
    func testPerformance() {
        let password: Array<UInt8> = "s33krit".bytes
        let salt: Array<UInt8> = "nacl".bytes
        measure {
            _ = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 65536, keyLength: 32, variant: .sha1).calculate()
        }
    }

    static func allTests() -> [(String, (PBKDFPerf) -> () -> Void)] {
        let tests = [("testPerformance", testPerformance)]
        return tests
    }
}
