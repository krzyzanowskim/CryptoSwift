//
//  BatchedCollection.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/01/2017.
//  Copyright © 2017 Marcin Krzyzanowski. All rights reserved.
//

struct BatchedCollectionIndex<Base: Collection> {
    let range: Range<Base.Index>
}

extension BatchedCollectionIndex: Comparable {
    static func ==<Base: Collection>(lhs: BatchedCollectionIndex<Base>, rhs: BatchedCollectionIndex<Base>) -> Bool {
        return lhs.range.lowerBound == rhs.range.lowerBound
    }
    static func < <Base: Collection>(lhs: BatchedCollectionIndex<Base>, rhs: BatchedCollectionIndex<Base>) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
}

protocol BatchedCollectionType: Collection {
    associatedtype Base: Collection
}

struct BatchedCollection<Base: Collection>: Collection {
    let base: Base
    let size: Base.IndexDistance
    typealias Index = BatchedCollectionIndex<Base>
    private func nextBreak(after idx: Base.Index) -> Base.Index {
        return base.index(idx, offsetBy: size, limitedBy: base.endIndex)
            ?? base.endIndex
    }
    var startIndex: Index {
        return Index(range: base.startIndex..<nextBreak(after: base.startIndex))
    }
    var endIndex: Index {
        return Index(range: base.endIndex..<base.endIndex)
    }
    func index(after idx: Index) -> Index {
        return Index(range: idx.range.upperBound..<nextBreak(after: idx.range.upperBound))
    }
    subscript(idx: Index) -> Base.SubSequence {
        return base[idx.range]
    }
}

extension Collection {
    func batched(by size: IndexDistance) -> BatchedCollection<Self> {
        return BatchedCollection(base: self, size: size)
    }
}
