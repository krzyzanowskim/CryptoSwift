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
    internal func chunks(chunksize:Int) -> [Array<T>] {
        var words:[[T]] = [[T]]()
        for var idx = chunksize; idx <= self.count; idx = idx + chunksize {
            let word = Array(self[idx - chunksize..<idx])
            words.append(word)
        }
        let reminder = Array(suffix(self, self.count % chunksize))
        if (reminder.count > 0) {
            words.append(reminder)
        }
        return words
    }
}