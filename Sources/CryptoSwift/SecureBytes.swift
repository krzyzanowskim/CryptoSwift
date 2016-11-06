//
//  SecureBytes.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux) || os(Android) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

///  Keeps bytes in memory. Because this is class, bytes are not copied
///  and memory area is locked as long as referenced, then unlocked on deinit
final class SecureBytes {
    fileprivate let bytes: Array<UInt8>
    let count: Int

    init(bytes: Array<UInt8>) {
        self.bytes = bytes
        self.count = bytes.count
        self.bytes.withUnsafeBufferPointer { (pointer) -> Void in
            mlock(pointer.baseAddress, pointer.count)
        }
    }

    deinit {
        self.bytes.withUnsafeBufferPointer { (pointer) -> Void in
            munlock(pointer.baseAddress, pointer.count)
        }
    }
}

extension SecureBytes: Collection {
    typealias Index = Int

    var endIndex: Int {
        return self.bytes.endIndex
    }

    var startIndex: Int {
        return self.bytes.startIndex
    }

    subscript(position: Index) -> UInt8 {
        return self.bytes[position]
    }

    subscript(bounds: Range<Index>) -> ArraySlice<UInt8> {
        return self.bytes[bounds]
    }

    func formIndex(after i: inout Int) {
        self.bytes.formIndex(after: &i)
    }

    func index(after i: Int) -> Int {
        return self.bytes.index(after: i)
    }
}

extension SecureBytes: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: UInt8...) {
        self.init(bytes: elements)
    }
}
