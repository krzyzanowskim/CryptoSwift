//
//  LinuxMain.swift
//  CryptoSwift
//
//  Created by Alsey Coleman Miller on 4/18/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

#if os(OSX) || os(iOS) || os(watchOS)
    func XCTMain(_ testCases: [XCTestCaseEntry]) { fatalError("Not Implemented. Linux only") }
    
    func testCase<T: XCTestCase>(_ allTests: [(String, T -> () throws -> Void)]) -> XCTestCaseEntry { fatalError("Not Implemented. Linux only") }
    
    struct XCTestCaseEntry { }
#endif

XCTMain([testCase(AESTests.allTests)])