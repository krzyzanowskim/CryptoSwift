//
//  ArrayExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 10/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Array {
    
    /** split in chunks with given chunk size */
    func chunks(chunksize:Int) -> [Array<Element>] {
        var words = [[Element]]()
        words.reserveCapacity(self.count / chunksize)        
        for var idx = chunksize; idx <= self.count; idx = idx + chunksize {
            let word = Array(self[idx - chunksize..<idx]) // this is slow for large table
            words.append(word)
        }
        let reminder = Array(self.suffix(self.count % chunksize))
        if (reminder.count > 0) {
            words.append(reminder)
        }
        return words
    }
}

// MARK: - Array<UInt8>

public protocol _UInt8Type {}
extension UInt8: _UInt8Type {}

extension Array where Element: _UInt8Type {
    public func toHexString() -> String {
        var s:String = "";
        for byte in self {
            s = s + String(format:"%02x", byte as! UInt8)
        }
        return s
    }
}

