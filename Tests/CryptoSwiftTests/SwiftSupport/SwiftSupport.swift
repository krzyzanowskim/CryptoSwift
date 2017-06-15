//
//  SwiftSupport.swift
//  CryptoSwift
//
//  Created by Volodymyr  Gorbenko on 15/6/17.
//  Copyright © 2017 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

#if swift(>=4.0)
#else
  import XCTest
  enum XCTPerformanceMetric {
    static let wallClockTime = XCTPerformanceMetric_WallClockTime
  }
#endif
