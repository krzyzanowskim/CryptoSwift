//
//  TestsPerformance.swift
//  TestsPerformance
//
//  Created by Marcin Krzyzanowski on 03/04/2018.
//  Copyright © 2018 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

class TestsPerformance: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMD5() {
        let data = Array("passworddrowssap".utf8)
        var md5 = MD5()
        
        measure {
            for _ in 0..<100_000 {
                _ = try! md5.finish(withBytes: data)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
