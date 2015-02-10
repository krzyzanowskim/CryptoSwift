//
//  Helpers.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

func compareMatrix(a:[[UInt8]], b:[[UInt8]]) -> Bool {
    for (i,arr) in enumerate(a) {
        for (j,val) in enumerate(arr) {
            if (val != b[i][j]) {
                println("Not equal: \(val) vs \(b[i][j])")
                return false
            }
        }
    }
    return true
}