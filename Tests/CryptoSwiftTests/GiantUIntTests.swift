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
  
  func testComparable() {
    XCTAssertTrue(GiantUInt([1, 2, 3]) == GiantUInt([1, 2, 3]), "equality check failed")
    XCTAssertTrue(GiantUInt([1, 2, 3]) > GiantUInt([1, 3, 2]), "greater than check failed")
    XCTAssertTrue(GiantUInt([1, 3, 2]) < GiantUInt([1, 2, 3]), "lower than check failed")
  }
  
  func testAddition() {
    let a = GiantUInt([1]) + GiantUInt([1])
    XCTAssertEqual(a, GiantUInt([2]), "simple addition failed")
    
    let b = GiantUInt([200]) + GiantUInt([200])
    XCTAssertEqual(b, GiantUInt([144, 1]), "addition with retenue failed")
    
    let c = GiantUInt([200, 200]) + GiantUInt([200, 200])
    XCTAssertEqual(c, GiantUInt([144, 145, 1]), "addition with double retenue failed")
  }
  
  func testMultiplication() {
    let a = GiantUInt([2]) * GiantUInt([2])
    XCTAssertEqual(a, GiantUInt([4]), "simple multiplication failed")
    
    let b = GiantUInt([200]) * GiantUInt([200])
    XCTAssertEqual(b, GiantUInt([64, 156]), "multiplication with retenue failed")
    
    let c = GiantUInt([200, 200]) * GiantUInt([200, 200])
    XCTAssertEqual(c, GiantUInt([64, 28, 121, 157]), "multiplication with double retenue failed")
  }
  
  func testExponentiation() {
    let a = GiantUInt([3]) ^^ GiantUInt([7])
    XCTAssertEqual(a, GiantUInt([139, 8]), "simple exponentiation failed")
  }
  
}

extension GiantUIntTests {
  static func allTests() -> [(String, (GiantUIntTests) -> () -> Void)] {
    let tests = [
      ("testComparable", testComparable),
      ("testAddition", testAddition),
      ("testMultiplication", testMultiplication),
      ("testExponentiation", testExponentiation)
    ]

    return tests
  }
}
