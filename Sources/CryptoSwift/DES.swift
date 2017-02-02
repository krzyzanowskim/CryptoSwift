//
//  DES.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 21/01/2017.
//  Copyright © 2017 Marcin Krzyzanowski. All rights reserved.
//
//  http://csrc.nist.gov/publications/fips/fips46-3/fips46-3.pdf
//

///  Data Encryption Standard (DES)
public final class DES: BlockCipher {
    public static let blockSize: Int = 8

    let permutedChoice1:Array<UInt8> = [7, 15, 23, 31, 39, 47, 55, 63,
                                        6, 14, 22, 30, 38, 46, 54, 62,
                                        5, 13, 21, 29, 37, 45, 53, 61,
                                        4, 12, 20, 28, 1, 9, 17, 25,
                                        33, 41, 49, 57, 2, 10, 18, 26,
                                        34, 42, 50, 58, 3, 11, 19, 27,
                                        35, 43, 51, 59, 36, 44, 52, 60]

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
        block ^= b1 << 32 ^ b2 ^ b1 << 8 ^ b2 << 24 // exchange b0 b4 with b3 b7


        // exchange 4,5,6,7 with 32,33,34,35 etc.
        b1 = block & 0x0f0f00000f0f0000
        b2 = block & 0x0000f0f00000f0f0
        block ^= b1 ^ b2 ^ b1 >> 12 ^ b2 << 12

        // exchange 0,1,4,5 with 18,19,22,23
        b1 = block & 0x3300330033003300
        b2 = block & 0x00cc00cc00cc00cc
        block ^= b1 ^ b2 ^ b1 >> 6 ^ b2 << 6

        // exchange 0,2,4,6 with 9,11,13,15
        b1 = block & 0xaaaaaaaa55555555
        block ^= b1 ^ b1 >> 33 ^ b1 << 33
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

    fileprivate func generateSubkeys(key: Array<UInt8>) {
        //TODO: check endianess of UInt64
        let permutedKey = self.permute(block: UInt64(bytes: key), permutation: permutedChoice1)
    }
}


extension DES: Cipher {
    public func encrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int, C.SubSequence: Collection, C.SubSequence.Iterator.Element == C.Iterator.Element, C.SubSequence.Index == C.Index, C.SubSequence.IndexDistance == C.IndexDistance {
        for chunk in bytes.batched(by: DES.blockSize) {
            var b = UInt64(bytes: chunk) //TODO: check endianess
            self.initialPermuation(block: &b)
            let left = UInt32(b >> 32)
            let right = UInt32(truncatingBitPattern: b)

            let subKey: UInt64
            for i in 0..<16 {
                // need generateSubkeys
            }
        }
        return []
    }

    public func decrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int {
        return []
    }
}
