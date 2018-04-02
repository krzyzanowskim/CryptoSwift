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

final class ChaCha20TestsPerf: XCTestCase {
    func testChaCha20Performance() {
        let key: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f]
        let iv: Array<UInt8> = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        let message = Array<UInt8>(repeating: 7, count: 1024 * 1024)
        measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true) { () -> Void in
            do {
                _ = try ChaCha20(key: key, iv: iv).encrypt(message)
            } catch {
                XCTFail()
            }
            self.stopMeasuring()
        }
    }
}

extension ChaCha20TestsPerf {
    static func allTests() -> [(String, (ChaCha20TestsPerf) -> () -> Void)] {
        let tests = [("testChaCha20Performance", testChaCha20Performance)]
        return tests
    }
}
