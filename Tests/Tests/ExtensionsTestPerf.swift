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
import Foundation
import XCTest

final class ExtensionsTestPerf: XCTestCase {
    func testArrayInitHexPerformance() {
        var str = "b1b2b3b3b3b3b3b3b1b2b3b3b3b3b3b3"
        for _ in 0...12 {
            str += str
        }
        measure {
            _ = Array<UInt8>(hex: str)
        }
    }
}

extension ExtensionsTestPerf {
    static func allTests() -> [(String, (ExtensionsTestPerf) -> () -> Void)] {
        let tests = [
            ("testArrayInitHexPerformance", testArrayInitHexPerformance),
        ]
        return tests
    }
}
