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

#if canImport(Darwin)
    import Darwin
#else
    import Glibc
#endif

struct RandomBytesSequence: Sequence {
    let size: Int

    func makeIterator() -> AnyIterator<UInt8> {
        var count = 0
        return AnyIterator<UInt8>.init { () -> UInt8? in
            guard count < self.size else {
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
        }
    }
}
