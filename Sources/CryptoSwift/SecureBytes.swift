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

#if os(Linux) || os(Android) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

typealias Key = SecureBytes

///  Keeps bytes in memory. Because this is class, bytes are not copied
///  and memory area is locked as long as referenced, then unlocked on deinit
final class SecureBytes {
    fileprivate let bytes: Array<UInt8>
    let count: Int

    init(bytes: Array<UInt8>) {
        self.bytes = bytes
        count = bytes.count
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
        return bytes.endIndex
    }

    var startIndex: Int {
        return bytes.startIndex
    }

    subscript(position: Index) -> UInt8 {
        return bytes[position]
    }

    subscript(bounds: Range<Index>) -> ArraySlice<UInt8> {
        return bytes[bounds]
    }

    func formIndex(after i: inout Int) {
        bytes.formIndex(after: &i)
    }

    func index(after i: Int) -> Int {
        return bytes.index(after: i)
    }
}

extension SecureBytes: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: UInt8...) {
        self.init(bytes: elements)
    }
}
