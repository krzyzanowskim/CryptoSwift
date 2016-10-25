//
//  BytesSequence.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

/// Generic version of BytesSequence is slower, therefore specialized version is in use
///
// struct BytesSequence<D: RandomAccessCollection>: Sequence where D.Iterator.Element == UInt8, D.IndexDistance == Int, D.SubSequence.IndexDistance == Int, D.Index == Int {
//    let chunkSize: D.IndexDistance
//    let data: D
//
//    func makeIterator() -> AnyIterator<D.SubSequence> {
//        var offset = data.startIndex
//        return AnyIterator {
//            let end = Swift.min(self.chunkSize, self.data.count - offset)
//            let result = self.data[offset..<offset + end]
//            offset = offset.advanced(by: result.count)
//            if !result.isEmpty {
//                return result
//            }
//            return nil
//        }
//    }
// }

struct BytesSequence: Sequence {
    let chunkSize: Array<UInt8>.IndexDistance
    let data: Array<UInt8>

    func makeIterator() -> AnyIterator<ArraySlice<UInt8>> {
        var offset = data.startIndex
        return AnyIterator {
            let end = Swift.min(self.chunkSize, self.data.count &- offset)
            let result = self.data[offset ..< offset &+ end]
            offset = offset.advanced(by: result.count)
            if !result.isEmpty {
                return result
            }
            return nil
        }
    }
}
