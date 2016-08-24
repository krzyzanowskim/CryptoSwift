//
//  CommonCryptoTests.swift
//  CryptoSwift
//
//  Created by Michael Ledin on 22.08.16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
@testable import CryptoSwift

final class CryptoSwiftTests: XCTestCase {
    func testMD5PerformanceCommonCrypto() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, for: { () -> Void in
            let buf: UnsafeMutableRawPointer = calloc(1024 * 1024, MemoryLayout<UInt8>.size)
            let data = NSData(bytes: buf, length: 1024 * 1024)
            let md = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
            self.startMeasuring()
            CC_MD5(data.bytes, CC_LONG(data.length), md)
            self.stopMeasuring()
            md.deallocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
            md.deinitialize()
            buf.deallocate(bytes: 1024 * 1024, alignedTo: MemoryLayout<UInt8>.alignment)
        })
    }
}
