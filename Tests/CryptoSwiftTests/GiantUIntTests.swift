//
// CryptoSwift
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

final class GiantUIntTests: XCTestCase {
  
  func testAddition() {
    let a = GiantUInt([1]) + GiantUInt([1])
    XCTAssertEqual(a, GiantUInt([2]), "simple addition failed")
    
    let b = GiantUInt([200]) + GiantUInt([200])
    XCTAssertEqual(b, GiantUInt([144, 1]), "addition with retenue failed")
    
    let c = GiantUInt([200, 200]) + GiantUInt([200, 200])
    XCTAssertEqual(c, GiantUInt([144, 145, 1]), "addition with double retenue failed")
  }
  
}

extension GiantUIntTests {
  static func allTests() -> [(String, (GiantUIntTests) -> () -> Void)] {
    let tests = [
      ("testAddition", testAddition)
    ]

    return tests
  }
}
