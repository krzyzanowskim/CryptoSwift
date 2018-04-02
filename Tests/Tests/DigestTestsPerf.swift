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

// http://www.di-mgt.com.au/sha_testvectors.html (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA_All.pdf)
//

@testable import CryptoSwift
import Foundation
import XCTest

final class DigestTestsPerf: XCTestCase {
    func testMD5Performance() {
        measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
            let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
            self.startMeasuring()
            _ = Digest.md5(arr)
            self.stopMeasuring()
        }
    }

    func testSHA1Performance() {
        measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
            let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
            self.startMeasuring()
            _ = Digest.sha1(arr)
            self.stopMeasuring()
        }
    }

    // Keep it to compare
    /*
    func testSHA1PerformanceCC() {
        measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
            let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
            self.startMeasuring()
            var digest = Array<UInt8>(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(arr, CC_LONG(arr.count), &digest)
            self.stopMeasuring()
        }
    }
    */
}

extension DigestTestsPerf {
    static func allTests() -> [(String, (DigestTestsPerf) -> () -> Void)] {
        return [
            ("testMD5Performance", testMD5Performance),
            ("testSHA1Performance", testSHA1Performance)
        ]
    }
}
