//
//  Access.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

class Access: XCTestCase {
    func testCRC() {
        let _ = CRC.crc32([1,2,3])
        let _ = CRC.crc16([1,2,3])
    }

    func testHash() {
        let _ = Hash.md5([1,2,3])
        let _ = Hash.sha1([1,2,3])
        let _ = Hash.sha224([1,2,3])
        let _ = Hash.sha256([1,2,3])
        let _ = Hash.sha384([1,2,3])
        let _ = Hash.sha512([1,2,3])
    }
}
