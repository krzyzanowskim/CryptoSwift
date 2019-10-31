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

import Foundation
import XCTest
@testable import CryptoSwift

final class SHATestsPerf: XCTestCase {

  static let len = 100000
    let a = [UInt8](unsafeUninitializedCapacity: SHATestsPerf.len) { buf, count in
    for i in 0..<len {
      buf[i] = UInt8.random(in: 0...UInt8.max)
    }
    count = len
  }

  func testSHA1Performance() {
    self.measure {
      _ = a.sha1()
    }
  }

  func testSHA2224Performance() {
    self.measure {
      _ = a.sha2(.sha224)
    }
  }

  func testSHA2256Performance() {
    self.measure {
      _ = a.sha2(.sha224)
    }
  }

  func testSHA2384Performance() {
    self.measure {
      _ = a.sha2(.sha384)
    }
  }

  func testSHA2512Performance() {
    self.measure {
      _ = a.sha2(.sha512)
    }
  }

  func testSHA3224Performance() {
    self.measure {
      _ = a.sha3(.sha224)
    }
  }

  func testSHA3256Performance() {
    self.measure {
      _ = a.sha3(.sha256)
    }
  }

  func testSHA3384Performance() {
    self.measure {
      _ = a.sha3(.sha384)
    }
  }

  func testSHA3512Performance() {
    self.measure {
      _ = a.sha3(.sha512)
    }
  }

  func testSHA3keccak224Performance() {
    self.measure {
      _ = a.sha3(.keccak224)
    }
  }

  func testSHA3keccak256Performance() {
    self.measure {
      _ = a.sha3(.keccak256)
    }
  }

  func testSHA3keccak384Performance() {
    self.measure {
      _ = a.sha3(.keccak384)
    }
  }

  func testSHA3keccak512Performance() {
    self.measure {
      _ = a.sha3(.keccak512)
    }
  }

}
