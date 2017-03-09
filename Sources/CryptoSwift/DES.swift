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
    fileprivate let permutedChoice1: Array<UInt8> = [
        7, 15, 23, 31, 39, 47, 55, 63,
        6, 14, 22, 30, 38, 46, 54, 62,
        5, 13, 21, 29, 37, 45, 53, 61,
        4, 12, 20, 28, 1, 9, 17, 25,
        33, 41, 49, 57, 2, 10, 18, 26,
        34, 42, 50, 58, 3, 11, 19, 27,
        35, 43, 51, 59, 36, 44, 52, 60,
    ]

    // PC-2
    fileprivate let permutedChoice2: Array<UInt8> = [
        42, 39, 45, 32, 55, 51, 53, 28,
        41, 50, 35, 46, 33, 37, 44, 52,
        30, 48, 40, 49, 29, 36, 43, 54,
        15, 4, 25, 19, 9, 1, 26, 16,
        5, 11, 23, 8, 12, 7, 17, 0,
        22, 3, 10, 14, 6, 20, 27, 24,
    ]

    fileprivate var permutationFunction: Array<UInt8> = [
        16, 25, 12, 11, 3, 20, 4, 15,
        31, 17, 9, 6, 27, 14, 1, 22,
        30, 24, 8, 18, 0, 5, 29, 23,
        13, 19, 2, 26, 10, 21, 28, 7,
    ]

    fileprivate var sBoxes: Array<Array<Array<UInt8>>> = [
        // S-box 1
        [
            [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
            [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8],
            [4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0],
            [15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13],
        ],
        // S-box 2
        [
            [15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10],
            [3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5],
            [0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15],
            [13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9],
        ],
        // S-box 3
        [
            [10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8],
            [13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1],
            [13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7],
            [1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12],
        ],
        // S-box 4
        [
            [7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15],
            [13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9],
            [10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4],
            [3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14],
        ],
        // S-box 5
        [
            [2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9],
            [14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6],
            [4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14],
            [11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3],
        ],
        // S-box 6
        [
            [12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11],
            [10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8],
            [9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6],
            [4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13],
        ],
        // S-box 7
        [
            [4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1],
            [13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6],
            [1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2],
            [6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12],
        ],
        // S-box 8
        [
            [13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7],
            [1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2],
            [7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8],
            [2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11],
        ],
    ]

    // Key schedule number of Left Shifts
    fileprivate let ksRotations: Array<UInt8> = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]
    fileprivate var feistelBox = Array<Array<UInt32>>(repeating: Array<UInt32>(repeating: 0, count: 64), count: 8)
    fileprivate var subkeys = Array<UInt64>()

    public init(key: Array<UInt8>) throws {
        self.subkeys = self.generateSubkeys(key: key)
        self.generateFeistelBox()
    }

    fileprivate func generateFeistelBox() {
        for s in 0 ..< 8 {
            for i in 0 ..< 4 {
                for j in 0 ..< 16 {
                    var f = UInt64(sBoxes[s][i][j]) << UInt64(4 * (7 - s))
                    f = permute(block: f, permutation: permutationFunction)

                    // Row is determined by the 1st and 6th bit.
                    // Column is the middle four bits.
                    let row = ((i & 2) << 4) | (i & 1)
                    let col = j << 1
                    let t = row | col

                    f = (f << 1) | (f >> 31)
                    feistelBox[s][t] = UInt32(truncatingBitPattern: f)
                }
            }
        }
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
        b1 = block >> 32 & 0xFF00FF
        b2 = (block & 0xFF00_FF00)
        block ^= (b1 << 32) ^ b2 ^ (b1 << 8) ^ (b2 << 24) // exchange b0 b4 with b3 b7

        // exchange 4,5,6,7 with 32,33,34,35 etc.
        b1 = block & 0x0F0F_0000_0F0F_0000
        b2 = block & 0x0000_F0F0_0000_F0F0
        block ^= b1 ^ b2 ^ (b1 >> 12) ^ (b2 << 12)

        // exchange 0,1,4,5 with 18,19,22,23
        b1 = block & 0x3300_3300_3300_3300
        b2 = block & 0x00CC_00CC_00CC_00CC
        block ^= b1 ^ b2 ^ (b1 >> 6) ^ (b2 << 6)

        // exchange 0,2,4,6 with 9,11,13,15
        b1 = block & 0xAAAA_AAAA_5555_5555
        block ^= b1 ^ (b1 >> 33) ^ (b1 << 33)
    }

    fileprivate func finalPermutation(block: inout UInt64) {
        var b1 = block & 0xAAAA_AAAA_5555_5555
        block ^= b1 ^ (b1 >> 33) ^ (b1 << 33)

        b1 = block & 0x3300_3300_3300_3300
        var b2 = block & 0x00CC_00CC_00CC_00CC
        block ^= b1 ^ b2 ^ (b1 >> 6) ^ (b2 << 6)

        b1 = block & 0x0F0F_0000_0F0F_0000
        b2 = block & 0x0000_F0F0_0000_F0F0
        block ^= b1 ^ b2 ^ (b1 >> 12) ^ (b2 << 12)

        b1 = block >> 32 & 0xFF00FF
        b2 = block & 0xFF00_FF00
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
        for (idx, value) in permutation.enumerated() {
            let bit = (block >> UInt64(value)) & 1
            result |= bit << (UInt64(permutation.count - 1 - idx))
        }
        return result
    }

    // 16 28-bit blocks rotated according to the rotation ksRotations schedule
    fileprivate func ksRotate(_ value: UInt32) -> Array<UInt32> {
        var last = value
        let result = ksRotations.map { (rotation) -> UInt32 in
            let left = (last << UInt32(4 + rotation)) >> 4
            let right = (last << 4) >> (32 - UInt32(rotation))
            last = left | right
            return last
        }

        //        var result = Array<UInt32>(repeating: 0, count: 16)
        //        var last = value
        //        for i in 0 ..< 16 {
        //            let left = (last << UInt32(4 + ksRotations[i])) >> 4
        //            let right = (last << 4) >> 32 - UInt32(ksRotations[i])
        //            result[i] = left | right
        //            last = result[i]
        //        }
        return result
    }

    fileprivate func feistel(l: UInt32, r: UInt32, k0: UInt64, k1: UInt64) -> (UInt32, UInt32) {
        var t: UInt32 = 0
        var l = l
        var r = r

        t = r ^ UInt32(k0 >> 32)
        l ^= feistelBox[7][Int(t) & 0x3F] ^ feistelBox[5][Int(t >> 8) & 0x3F] ^ feistelBox[3][Int(t >> 16) & 0x3F] ^ feistelBox[1][Int(t >> 24) & 0x3F]

        t = ((r << 28) | (r >> 4)) ^ UInt32(truncatingBitPattern: k0)
        l ^= feistelBox[6][Int(t) & 0x3F] ^ feistelBox[4][Int(t >> 8) & 0x3F] ^ feistelBox[2][Int(t >> 16) & 0x3F] ^ feistelBox[0][Int(t >> 24) & 0x3F]

        t = l ^ UInt32(truncatingBitPattern: k1 >> 32)
        r ^= feistelBox[7][Int(t) & 0x3F] ^ feistelBox[5][Int(t >> 8) & 0x3F] ^ feistelBox[3][Int(t >> 16) & 0x3F] ^ feistelBox[1][Int(t >> 24) & 0x3F]

        t = ((l << 28) | (l >> 4)) ^ UInt32(truncatingBitPattern: k1)
        r ^= feistelBox[6][Int(t) & 0x3F] ^ feistelBox[4][Int(t >> 8) & 0x3F] ^ feistelBox[2][Int(t >> 16) & 0x3F] ^ feistelBox[0][Int(t >> 24) & 0x3F]

        return (l, r)
    }

    fileprivate func generateSubkeys(key: Array<UInt8>) -> Array<UInt64> {
        typealias UInt48 = UInt64
        // Expand 48-bit input to 64-bit, with each 6-bit block padded by extra two bits at the top.
        func expand(_ x: UInt48) -> UInt64 {
            return ((x >> (6 * 1)) & 0xFF) << (8 * 0) |
                ((x >> (6 * 3)) & 0xFF) << (8 * 1) |
                ((x >> (6 * 5)) & 0xFF) << (8 * 2) |
                ((x >> (6 * 7)) & 0xFF) << (8 * 3) |
                ((x >> (6 * 0)) & 0xFF) << (8 * 4) |
                ((x >> (6 * 2)) & 0xFF) << (8 * 5) |
                ((x >> (6 * 4)) & 0xFF) << (8 * 6) |
                ((x >> (6 * 6)) & 0xFF) << (8 * 7)
        }

        // TODO: check endianess of UInt64
        var subkeys = Array<UInt64>(repeating: 0, count: 16)

        let permutedKey = self.permute(block: UInt64(bytes: key), permutation: permutedChoice1)

        // rotate halves of permuted key
        let leftRotations = ksRotate(UInt32(permutedKey >> 28))
        let rightRotations = ksRotate(UInt32(truncatingBitPattern: permutedKey << 4) >> 4)

        for i in 0 ..< 16 {
            let pc2Input = (UInt64(leftRotations[i]) << 28) | UInt64(rightRotations[i])
            // apply PC2 permutation to 7 byte input
            print(pc2Input)
            subkeys[i] = expand(self.permute(block: pc2Input, permutation: permutedChoice2))
        }
        return subkeys
    }
}

extension DES: Cipher {
    public func encrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int, C.SubSequence: Collection, C.SubSequence.Iterator.Element == C.Iterator.Element, C.SubSequence.Index == C.Index, C.SubSequence.IndexDistance == C.IndexDistance {
        for chunk in bytes.batched(by: DES.blockSize) {
            var b = UInt64(bytes: chunk)
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
            self.finalPermutation(block: &preOutput)
        }
        return []
    }

    public func decrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int {
        return []
    }
}
