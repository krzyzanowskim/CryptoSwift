//
//  Helpers.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

func compareMatrix(_ a:Array<Array<UInt8>>, b:Array<Array<UInt8>>) -> Bool {
    for (i,arr) in a.enumerated() {
        for (j,val) in arr.enumerated() {
            if (val != b[i][j]) {
                print("Not equal: \(val) vs \(b[i][j])") //FIXME: remove verbose
                return false
            }
        }
    }
    return true
}
