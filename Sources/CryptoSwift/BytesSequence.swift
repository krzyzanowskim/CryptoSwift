//
//  BytesSequence.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

//TODO: func anyGenerator is renamed to AnyGenerator in Swift 2.2, until then it's just dirty hack for linux (because swift >= 2.2 is available for Linux)
private func CS_AnyGenerator<Element>(body: () -> Element?) -> AnyGenerator<Element> {
 #if os(Linux)
    return AnyGenerator(body: body)
 #else
     return anyGenerator(body)
 #endif
}

struct BytesSequence: SequenceType {
    let chunkSize: Int
    let data: [UInt8]
    
    func generate() -> AnyGenerator<ArraySlice<UInt8>> {
        
        var offset:Int = 0
        
        return CS_AnyGenerator {
            let end = min(self.chunkSize, self.data.count - offset)
            let result = self.data[offset..<offset + end]
            offset += result.count
            return result.count > 0 ? result : nil
        }
    }
}