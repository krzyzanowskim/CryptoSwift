//
//  SHA1.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 16/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

public final class SHA1: DigestType {
    static let digestLength: Int = 20 // 160 / 8
    static let blockSize: Int = 64
    fileprivate static let hashInitialValue: ContiguousArray<UInt32> = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]

    fileprivate var accumulated = Array<UInt8>()
    fileprivate var processedBytesTotalCount: Int = 0
    fileprivate var accumulatedHash: ContiguousArray<UInt32> = SHA1.hashInitialValue

    public init() {
    }

    public func calculate(for bytes: Array<UInt8>) -> Array<UInt8> {
        do {
            return try self.update(withBytes: bytes, isLast: true)
        } catch {
            return []
        }
    }

    fileprivate func process(block chunk: ArraySlice<UInt8>, currentHash hh: inout ContiguousArray<UInt32>) {
        // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
        // Extend the sixteen 32-bit words into eighty 32-bit words:
        var M = ContiguousArray<UInt32>(repeating: 0, count: 80)
        for x in 0 ..< M.count {
            switch x {
            case 0 ... 15:
                let start = chunk.startIndex.advanced(by: x * 4) // * MemoryLayout<UInt32>.size
                M[x] = UInt32(bytes: chunk, fromIndex: start)
                break
            default:
                M[x] = rotateLeft(M[x - 3] ^ M[x - 8] ^ M[x - 14] ^ M[x - 16], by: 1)
                break
            }
        }

        var A = hh[0]
        var B = hh[1]
        var C = hh[2]
        var D = hh[3]
        var E = hh[4]

        // Main loop
        for j in 0 ... 79 {
            var f: UInt32 = 0
            var k: UInt32 = 0

            switch j {
            case 0 ... 19:
                f = (B & C) | ((~B) & D)
                k = 0x5A827999
                break
            case 20 ... 39:
                f = B ^ C ^ D
                k = 0x6ED9EBA1
                break
            case 40 ... 59:
                f = (B & C) | (B & D) | (C & D)
                k = 0x8F1BBCDC
                break
            case 60 ... 79:
                f = B ^ C ^ D
                k = 0xCA62C1D6
                break
            default:
                break
            }

            let temp = rotateLeft(A, by: 5) &+ f &+ E &+ M[j] &+ k
            E = D
            D = C
            C = rotateLeft(B, by: 30)
            B = A
            A = temp
        }

        hh[0] = hh[0] &+ A
        hh[1] = hh[1] &+ B
        hh[2] = hh[2] &+ C
        hh[3] = hh[3] &+ D
        hh[4] = hh[4] &+ E
    }
}

extension SHA1: Updatable {

    public func update<T: Collection>(withBytes bytes: T, isLast: Bool = false) throws -> Array<UInt8> where T.Iterator.Element == UInt8 {
        self.accumulated += bytes

        if isLast {
            let lengthInBits = (self.processedBytesTotalCount + self.accumulated.count) * 8
            let lengthBytes = lengthInBits.bytes(totalBytes: 64 / 8) // A 64-bit representation of b

            // Step 1. Append padding
            bitPadding(to: &self.accumulated, blockSize: SHA1.blockSize, allowance: 64 / 8)

            // Step 2. Append Length a 64-bit representation of lengthInBits
            self.accumulated += lengthBytes
        }

        var processedBytes = 0
        for chunk in self.accumulated.batched(by: SHA1.blockSize) {
            if (isLast || (self.accumulated.count - processedBytes) >= SHA1.blockSize) {
                self.process(block: chunk, currentHash: &self.accumulatedHash)
                processedBytes += chunk.count
            }
        }
        self.accumulated.removeFirst(processedBytes)
        self.processedBytesTotalCount += processedBytes

        // output current hash
        var result = Array<UInt8>(repeating: 0, count: SHA1.digestLength)
        var pos = 0
        for idx in 0 ..< self.accumulatedHash.count {
            let h = self.accumulatedHash[idx].bigEndian
            result[pos] = UInt8(h & 0xff)
            result[pos + 1] = UInt8((h >> 8) & 0xff)
            result[pos + 2] = UInt8((h >> 16) & 0xff)
            result[pos + 3] = UInt8((h >> 24) & 0xff)
            pos += 4
        }

        // reset hash value for instance
        if isLast {
            self.accumulatedHash = SHA1.hashInitialValue
        }

        return result
    }
}
