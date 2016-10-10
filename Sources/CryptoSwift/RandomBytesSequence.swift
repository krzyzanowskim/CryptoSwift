//
//  RandomBytesSequence.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 10/10/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux) || os(Android) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

struct RandomBytesSequence: Sequence {
    let size: Int

    func makeIterator() -> AnyIterator<UInt8> {
        var count = 0
        return AnyIterator<UInt8>.init({ () -> UInt8? in
            if count >= self.size {
                return nil
            }
            count = count + 1

            #if os(Linux) || os(Android) || os(FreeBSD)
                let fd = open("/dev/urandom", O_RDONLY)
                if fd <= 0 {
                    return nil
                }

                var value: UInt8 = 0
                let result = read(fd, &value, MemoryLayout<UInt8>.size)
                precondition(result == 1)

                close(fd)
                return value
            #else
                return UInt8(arc4random_uniform(UInt32(UInt8.max) + 1))
            #endif
        })
    }
}
