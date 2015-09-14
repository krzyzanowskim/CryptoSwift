//
//  NSDataSequence.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/07/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

struct NSDataSequence: SequenceType {
    
    let chunkSize: Int
    let data: NSData
    
    func generate() -> AnyGenerator<NSData> {
        
        var offset:Int = 0
        
        return anyGenerator {
            let result = self.data.subdataWithRange(NSRange(location: offset, length: min(self.chunkSize, self.data.length - offset)))
            offset += result.length
            return result.length > 0 ? result : nil
        }
    }
}