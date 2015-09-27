//
//  Helpers.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

func compareMatrix(a:[[UInt8]], b:[[UInt8]]) -> Bool {
    for (i,arr) in a.enumerate() {
        for (j,val) in arr.enumerate() {
            if (val != b[i][j]) {
                print("Not equal: \(val) vs \(b[i][j])") //FIXME: remove verbose
                return false
            }
        }
    }
    return true
}