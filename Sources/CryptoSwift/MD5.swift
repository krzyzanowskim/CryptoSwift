//
//  MD5.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Krzyżanowski <marcin@krzyzanowskim.com>
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

public final class MD5: DigestType {
    static let blockSize: Int = 64
    static let digestLength: Int = 16 // 128 / 8
    fileprivate static let hashInitialValue: Array<UInt32> = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]

    fileprivate var accumulated = Array<UInt8>()
    fileprivate var processedBytesTotalCount: Int = 0
    fileprivate var accumulatedHash: Array<UInt32> = MD5.hashInitialValue

    /** specifies the per-round shift amounts */
    private let s: Array<UInt32> = [7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                                    5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                                    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                                    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21]

    /** binary integer part of the sines of integers (Radians) */
    private let k: Array<UInt32> = [0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
                                    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
                                    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
                                    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                                    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
                                    0xd62f105d, 0x2441453, 0xd8a1e681, 0xe7d3fbc8,
                                    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
                                    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                                    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
                                    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                                    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x4881d05,
                                    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                                    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
                                    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                                    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
                                    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391]

    public init() {
    }

    public func calculate(for bytes: Array<UInt8>) -> Array<UInt8> {
        do {
            return try self.update(withBytes: bytes, isLast: true)
        } catch {
            fatalError()
        }
    }

    // mutating currentHash in place is way faster than returning new result
    fileprivate func process(block chunk: ArraySlice<UInt8>, currentHash: inout Array<UInt32>) {
        assert(chunk.count == 16 * 4)

        // Initialize hash value for this chunk:
        var A: UInt32 = currentHash[0]
        var B: UInt32 = currentHash[1]
        var C: UInt32 = currentHash[2]
        var D: UInt32 = currentHash[3]

        var dTemp: UInt32 = 0

        // Main loop
        for j in 0 ..< k.count {
            var g = 0
            var F: UInt32 = 0

            switch (j) {
            case 0 ... 15:
                F = (B & C) | ((~B) & D)
                g = j
                break
            case 16 ... 31:
                F = (D & B) | (~D & C)
                g = (5 * j + 1) % 16
                break
            case 32 ... 47:
                F = B ^ C ^ D
                g = (3 * j + 5) % 16
                break
            case 48 ... 63:
                F = C ^ (B | (~D))
                g = (7 * j) % 16
                break
            default:
                break
            }
            dTemp = D
            D = C
            C = B

            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15 and get M[g] value
            let gAdvanced = g << 2

            var Mg  = UInt32(chunk[chunk.startIndex &+ gAdvanced])
                Mg |= UInt32(chunk[chunk.startIndex &+ gAdvanced &+ 1]) << 8
                Mg |= UInt32(chunk[chunk.startIndex &+ gAdvanced &+ 2]) << 16
                Mg |= UInt32(chunk[chunk.startIndex &+ gAdvanced &+ 3]) << 24

            B = B &+ rotateLeft(A &+ F &+ k[j] &+ Mg, by: s[j])
            A = dTemp
        }

        currentHash[0] = currentHash[0] &+ A
        currentHash[1] = currentHash[1] &+ B
        currentHash[2] = currentHash[2] &+ C
        currentHash[3] = currentHash[3] &+ D
    }
}

extension MD5: Updatable {

    public func update<T: Collection>(withBytes bytes: T, isLast: Bool = false) throws -> Array<UInt8> where T.Iterator.Element == UInt8 {
        self.accumulated += bytes

        if isLast {
            let lengthInBits = (self.processedBytesTotalCount + self.accumulated.count) * 8
            let lengthBytes = lengthInBits.bytes(totalBytes: 64 / 8) // A 64-bit representation of b

            // Step 1. Append padding
            bitPadding(to: &self.accumulated, blockSize: MD5.blockSize, allowance: 64 / 8)

            // Step 2. Append Length a 64-bit representation of lengthInBits
            self.accumulated += lengthBytes.reversed()
        }

        var processedBytes = 0
        for chunk in self.accumulated.batched(by: MD5.blockSize) {
            if (isLast || (self.accumulated.count - processedBytes) >= MD5.blockSize) {
                self.process(block: chunk, currentHash: &self.accumulatedHash)
                processedBytes += chunk.count
            }
        }
        self.accumulated.removeFirst(processedBytes)
        self.processedBytesTotalCount += processedBytes

        // output current hash
        var result = Array<UInt8>()
        result.reserveCapacity(MD5.digestLength)

        for hElement in self.accumulatedHash {
            let hLE = hElement.littleEndian
            result += [UInt8(hLE & 0xff), UInt8((hLE >> 8) & 0xff), UInt8((hLE >> 16) & 0xff), UInt8((hLE >> 24) & 0xff)]
        }

        // reset hash value for instance
        if isLast {
            self.accumulatedHash = MD5.hashInitialValue
        }

        return result
    }
}
