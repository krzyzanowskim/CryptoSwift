//
//  Utils+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

func perf(text: String, closure: () -> ()) {
    let measurementStart = NSDate();
    
    closure()
    
    let measurementStop = NSDate();
    let executionTime = measurementStop.timeIntervalSince(measurementStart)
    
    print("\(text) \(executionTime)");
}

#endif