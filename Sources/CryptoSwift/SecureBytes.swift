//
//  SecureBytes.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  SecureBytes keeps bytes in memory. Because this is class, bytes are not copied
//  and memory area is locked as long as referenced, then unlocked on deinit
//

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

class SecureBytes {
    private let bytes: [UInt8]
    let count: Int

    init(bytes: [UInt8]) {
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

    subscript(index: Int) -> UInt8 {
        return self.bytes[index]
    }
}
