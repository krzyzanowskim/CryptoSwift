//
//  Utils+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

func perf(_ text: String, closure: () -> Void) {
    let measurementStart = Date()

    closure()

    let measurementStop = Date()
    let executionTime = measurementStop.timeIntervalSince(measurementStart)

    print("\(text) \(executionTime)")
}
