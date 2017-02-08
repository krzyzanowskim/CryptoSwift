//
//  DES.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 21/01/2017.
//  Copyright © 2017 Marcin Krzyzanowski. All rights reserved.
//
//  http://csrc.nist.gov/publications/fips/fips46-3/fips46-3.pdf
//  Eric Young's http://ftp.nluug.nl/security/coast/libs/libdes/ALGORITHM

///  Data Encryption Standard (DES).
public final class DES: BlockCipher {
    public static let blockSize: Int = 8

    // PC-1
    fileprivate let permutedChoice1: Array<UInt8> = [7, 15, 23, 31, 39, 47, 55, 63,
                                                 6, 14, 22, 30, 38, 46, 54, 62,
                                                 5, 13, 21, 29, 37, 45, 53, 61,
                                                 4, 12, 20, 28, 1, 9, 17, 25,
                                                 33, 41, 49, 57, 2, 10, 18, 26,
                                                 34, 42, 50, 58, 3, 11, 19, 27,
                                                 35, 43, 51, 59, 36, 44, 52, 60]

    // PC-2
    fileprivate let permutedChoice2: Array<UInt8> = [42, 39, 45, 32, 55, 51, 53, 28,
                                                 41, 50, 35, 46, 33, 37, 44, 52,
                                                 30, 48, 40, 49, 29, 36, 43, 54,
                                                 15, 4, 25, 19, 9, 1, 26, 16,
                                                 5, 11, 23, 8, 12, 7, 17, 0,
                                                 22, 3, 10, 14, 6, 20, 27, 24]


    // Key schedule number of Left Shifts
    fileprivate let ksRotations: Array<UInt8> = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

    fileprivate var feistelBox = Array<Array<UInt32>>(repeating: Array<UInt32>(repeating: 0, count: 8), count: 64)

    fileprivate var subkeys = Array<UInt64>()

    public init(key: Array<UInt8>) throws {
        self.subkeys = self.generateSubkeys(key: key)
    }

    /// The 64 bits of the input block to be enciphered are first subjected to the following permutation, called the initial permutation.
    ///
    /// - Parameter block: 8 bytes
    /// - Returns: block
    fileprivate func initialPermuation(block: inout UInt64) {
        // block = b7 b6 b5 b4 b3 b2 b1 b0
        var b1 = block >> 48
        var b2 = block << 48
        block ^= b1 ^ b2 ^ b1 << 48 ^ b2 >> 48

        // block = b1 b0 b5 b4 b3 b2 b7 b6
        b1 = block >> 32 & 0xff00ff
        b2 = (block & 0xff00ff00)
        block ^= (b1 << 32) ^ b2 ^ (b1 << 8) ^ (b2 << 24) // exchange b0 b4 with b3 b7


        // exchange 4,5,6,7 with 32,33,34,35 etc.
        b1 = block & 0x0f0f00000f0f0000
        b2 = block & 0x0000f0f00000f0f0
        block ^= b1 ^ b2 ^ (b1 >> 12) ^ (b2 << 12)

        // exchange 0,1,4,5 with 18,19,22,23
        b1 = block & 0x3300330033003300
        b2 = block & 0x00cc00cc00cc00cc
        block ^= b1 ^ b2 ^ (b1 >> 6) ^ (b2 << 6)

        // exchange 0,2,4,6 with 9,11,13,15
        b1 = block & 0xaaaaaaaa55555555
        block ^= b1 ^ (b1 >> 33) ^ (b1 << 33)
    }

    fileprivate func finalPermutaion(block: inout UInt64) {
        var b1 = block & 0xaaaaaaaa55555555
        block ^= b1 ^ (b1 >> 33) ^ (b1 << 33)

        b1 = block & 0x3300330033003300
        var b2 = block & 0x00cc00cc00cc00cc
        block ^= b1 ^ b2 ^ (b1 >> 6) ^ (b2 << 6)


        b1 = block & 0x0f0f00000f0f0000
        b2 = block & 0x0000f0f00000f0f0
        block ^= b1 ^ b2 ^ (b1 >> 12) ^ (b2 << 12)

        b1 = block >> 32 & 0xff00ff
        b2 = block & 0xff00ff00
        block ^= (b1 << 32) ^ b2 ^ (b1 << 8) ^ (b2 << 24)

        b1 = block >> 48
        b2 = block << 48
        block ^= b1 ^ b2 ^ (b1 << 48) ^ (b2 >> 48)
    }

    /// Expands an input block of 32 bits, producing an output block of 48 bits.
    fileprivate func expand(src: UInt32) -> UInt64 {
        var src = (src << 5) | (src >> 27)
        var result: UInt64 = 0
        for _ in 0 ..< 8 {
            result <<= 6
            result |= UInt64(src) & (1 << 6 - 1)
            src = (src << 4) | (src >> 28)
        }
        return result
    }

    /// General purpose function to perform block permutations
    fileprivate func permute(block: UInt64, permutation: Array<UInt8>) -> UInt64 {
        var result: UInt64 = 0
        for (idx,value) in permutation.enumerated() {
            let bit = (block >> UInt64(value)) & 1
            result |= bit << UInt64(permutation.count - 1 - idx)
        }
        return result
    }

    // 16 28-bit blocks rotated according to the rotation ksRotations schedule
    fileprivate func ksRotate(_ value: UInt32) -> Array<UInt32> {
        var result = Array<UInt32>(repeating: 0, count: 16)
        var last = value
        for i in 0 ..< 16 {
            let left = (last << UInt32(4 + ksRotations[i])) >> 4
            let right = (last << 4) >> 32 - UInt32(ksRotations[i])
            result[i] = left | right
            last = result[i]
        }
        return result
    }

    fileprivate func feistel(l: UInt32, r: UInt32, k0: UInt64, k1: UInt64) -> (UInt32, UInt32) {
        var t:UInt32 = 0
        var l = l
        var r = r

        t = r ^ UInt32(k0 >> 32)
        l ^= feistelBox[7][Int(t) & 0x3f] ^ feistelBox[5][Int(t >> 8) & 0x3f] ^ feistelBox[3][Int(t >> 16) & 0x3f] ^ feistelBox[1][Int(t >> 24) & 0x3f]

        t = ((r << 28) | (r >> 4)) ^ UInt32(truncatingBitPattern: k0)
        l ^= feistelBox[6][Int(t) & 0x3f] ^ feistelBox[4][Int(t >> 8) & 0x3f] ^ feistelBox[2][Int(t >> 16) & 0x3f] ^ feistelBox[0][Int(t >> 24) & 0x3f]

        t = l ^ UInt32(truncatingBitPattern: k1 >> 32)
        r ^= feistelBox[7][Int(t) & 0x3f] ^ feistelBox[5][Int(t >> 8) & 0x3f] ^ feistelBox[3][Int(t >> 16) & 0x3f] ^ feistelBox[1][Int(t >> 24) & 0x3f]

        t = ((l << 28) | (l >> 4)) ^ UInt32(truncatingBitPattern: k1)
        r ^= feistelBox[6][Int(t) & 0x3f] ^ feistelBox[4][Int(t >> 8) & 0x3f] ^ feistelBox[2][Int(t >> 16) & 0x3f] ^ feistelBox[0][Int(t >> 24) & 0x3f]

        return (l, r)
    }

    fileprivate func generateSubkeys(key: Array<UInt8>) -> Array<UInt64> {
        //TODO: check endianess of UInt64
        var subkeys = Array<UInt64>(repeating: 0, count: 16)

        let permutedKey = self.permute(block: UInt64(bytes: key), permutation: permutedChoice1)

        // rotate halves of permuted key
        let leftRotations = ksRotate(UInt32(permutedKey >> 28))
        let rightRotations = ksRotate(UInt32(permutedKey << 4) >> 4)

        for i in 0 ..< 16 {
            let pc2Input = UInt64(leftRotations[i])<<28 | uint64(rightRotations[i])
            // apply PC2 permutation to 7 byte input
            subkeys[i] = self.permute(block: pc2Input, permutation: permutedChoice2)
        }
        return subkeys
    }
}


extension DES: Cipher {
    public func encrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int, C.SubSequence: Collection, C.SubSequence.Iterator.Element == C.Iterator.Element, C.SubSequence.Index == C.Index, C.SubSequence.IndexDistance == C.IndexDistance {
        for chunk in bytes.batched(by: DES.blockSize) {
            var b = UInt64(bytes: chunk) //TODO: check endianess
            self.initialPermuation(block: &b)

            var left = UInt32(b >> 32)
            left = (left << 1) | (left >> 31)

            var right = UInt32(truncatingBitPattern: b)
            right = (right << 1) | (right >> 31)

            for i in 0 ..< 8 {
                (left, right) = feistel(l: left, r: right, k0: self.subkeys[2 * i], k1: self.subkeys[2 * i + 1])
            }

            left = (left << 31) | (left >> 1)
            right = (right << 31) | (right >> 1)

            var preOutput = UInt64(right) << 32 | UInt64(left)
            finalPermutaion(block: &preOutput)
        }
        return []
    }

    public func decrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int {
        return []
    }
}
