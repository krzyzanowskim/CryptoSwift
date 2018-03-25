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

public protocol _UInt8Type {}
extension UInt8: _UInt8Type {}

/** casting */
extension UInt8 {
    /** cast because UInt8(<UInt32>) because std initializer crash if value is > byte */
    static func with(value: UInt64) -> UInt8 {
        let tmp = value & 0xff
        return UInt8(tmp)
    }

    static func with(value: UInt32) -> UInt8 {
        let tmp = value & 0xff
        return UInt8(tmp)
    }

    static func with(value: UInt16) -> UInt8 {
        let tmp = value & 0xff
        return UInt8(tmp)
    }
}

/** Bits */
extension UInt8 {
    init(bits: [Bit]) {
        self.init(integerFrom(bits) as UInt8)
    }

    /** array of bits */
    public func bits() -> [Bit] {
        let totalBitsCount = MemoryLayout<UInt8>.size * 8

        var bitsArray = [Bit](repeating: Bit.zero, count: totalBitsCount)

        for j in 0..<totalBitsCount {
            let bitVal: UInt8 = 1 << UInt8(totalBitsCount - 1 - j)
            let check = self & bitVal

            if check != 0 {
                bitsArray[j] = Bit.one
            }
        }
        return bitsArray
    }

    public func bits() -> String {
        var s = String()
        let arr: [Bit] = bits()
        for idx in arr.indices {
            s += (arr[idx] == Bit.one ? "1" : "0")
            if idx.advanced(by: 1) % 8 == 0 { s += " " }
        }
        return s
    }
}
