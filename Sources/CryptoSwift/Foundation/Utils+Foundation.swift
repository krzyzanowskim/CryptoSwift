//
//  Utils+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

func perf(text: String, closure: () -> ()) {
    let measurementStart = NSDate();
    
    closure()
    
    let measurementStop = NSDate();
    let executionTime = measurementStop.timeIntervalSince(measurementStart)
    
    print("\(text) \(executionTime)");
}