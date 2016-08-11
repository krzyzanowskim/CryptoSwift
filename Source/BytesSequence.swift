//
//  BytesSequence.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

struct BytesSequence: Sequence {
    let chunkSize: Int
    let data: Array<UInt8>

    func makeIterator() -> AnyIterator<ArraySlice<UInt8>> {
        var offset:Int = 0
        return AnyIterator {
            let end = Swift.min(self.chunkSize, self.data.count - offset)
            let result = self.data[offset..<offset + end]
            offset += result.count
            return !result.isEmpty ? result : nil
        }
    }
}