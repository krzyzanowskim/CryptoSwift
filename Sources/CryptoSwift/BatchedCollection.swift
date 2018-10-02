//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

struct BatchedCollectionIndex<Base: Collection> {
    let range: Range<Base.Index>
}

extension BatchedCollectionIndex: Comparable {
    static func == <Base>(lhs: BatchedCollectionIndex<Base>, rhs: BatchedCollectionIndex<Base>) -> Bool {
        return lhs.range.lowerBound == rhs.range.lowerBound
    }

    static func < <Base>(lhs: BatchedCollectionIndex<Base>, rhs: BatchedCollectionIndex<Base>) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }
}

protocol BatchedCollectionType: Collection {
    associatedtype Base: Collection
}

struct BatchedCollection<Base: Collection>: Collection {
    let base: Base
    let size: Int
    typealias Index = BatchedCollectionIndex<Base>
    private func nextBreak(after idx: Base.Index) -> Base.Index {
        return base.index(idx, offsetBy: size, limitedBy: base.endIndex) ?? base.endIndex
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
    func batched(by size: Int) -> BatchedCollection<Self> {
        return BatchedCollection(base: self, size: size)
    }
}
