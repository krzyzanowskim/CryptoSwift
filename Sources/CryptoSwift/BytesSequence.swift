//
//  BytesSequence.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

struct BytesSequence: SequenceType {
    let chunkSize: Int
    let data: [UInt8]
    
    func generate() -> AnyGenerator<ArraySlice<UInt8>> {
        
        var offset:Int = 0
        
        return AnyGenerator {
            let end = min(self.chunkSize, self.data.count - offset)
            let result = self.data[offset..<offset + end]
            offset += result.count
            return !result.isEmpty ? result : nil
        }
    }
}