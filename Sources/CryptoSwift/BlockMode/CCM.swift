////  CryptoSwift
//
//  Copyright (C) 2014-__YEAR__ Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

// CCM mode combines the well known CBC-MAC with the well known counter mode of encryption.
// https://tools.ietf.org/html/rfc3610
// https://csrc.nist.gov/publications/detail/sp/800-38c/final


public struct CCM: BlockMode {
    public enum Error: Swift.Error {
        /// Invalid IV
        case invalidInitializationVector
        case invalidParameter
    }

    public let options: BlockModeOption = [.initializationVectorRequired, .paddingRequired]
    private let iv: Array<UInt8>

    public init(iv: Array<UInt8>) {
        self.iv = iv
    }

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
        if iv.count != blockSize {
            throw Error.invalidInitializationVector
        }

        return CBCModeWorker(blockSize: blockSize, iv: iv.slice, cipherOperation: cipherOperation)
    }


    // Apply the formatting function to (N, A, P) to produce blocks [B0, ..., Br]
    private func format(N: [UInt8], A: [UInt8], P: [UInt8]) throws -> [UInt8] {
        let block0 = try formatNonce(N: N, Q: 512, q: 3, t: 12, hasAssociatedData: false) // mock
        return []
    }

    // Q - octet length of P
    // q - octet length of Q. Maximum length (in octets) of payload. An element of {2,3,4,5,6,7,8}
    // t - octet length of T (MAC length). An element of {4,6,8,10,12,14,16}
    private func formatNonce(N: [UInt8], Q: UInt32, q: UInt8, t: UInt8, hasAssociatedData: Bool) throws -> [UInt8] {
        var flags0: UInt8 = 0

        if hasAssociatedData {
            // 6 bit
            flags0 |= (1 << 6)
        }

        // 5,4,3 is t in 3 bits
        flags0 |= (((t-2)/2) & 0x07) << 3

        // 2,1,0 is q in 3 bits
        flags0 |= ((q-1) & 0x07) << 0

        var block0: [UInt8] = Array<UInt8>(repeating: 0, count: 16) // block[0]
        block0[0] = flags0

        // N in 1...(15-q) octets, n = 15-q
        // n is an element of {7,8,9,10,11,12,13}
        let n = 15-Int(q)
        guard (n + Int(q)) == 15 else {
            // n+q == 15
            throw Error.invalidParameter
        }
        block0[1...n] = N[0...(n-1)]

        // Q in (16-q)...15 octets
        block0[(16-Int(q))...15] = Q.bytes(totalBytes: Int(q)).slice

        return block0
    }
}

struct CCMModeWorker: BlockModeWorker {
    let cipherOperation: CipherOperationOnBlock
    var blockSize: Int
    let additionalBufferSize: Int = 0
    private let iv: ArraySlice<UInt8>
    private var prev: ArraySlice<UInt8>?

    init(blockSize: Int, iv: ArraySlice<UInt8>, cipherOperation: @escaping CipherOperationOnBlock) {
        self.blockSize = blockSize
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        guard let ciphertext = cipherOperation(xor(prev ?? iv, plaintext)) else {
            return Array(plaintext)
        }
        prev = ciphertext.slice
        return ciphertext
    }

    mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        guard let plaintext = cipherOperation(ciphertext) else {
            return Array(ciphertext)
        }
        let result: Array<UInt8> = xor(prev ?? iv, plaintext)
        prev = ciphertext
        return result
    }
}
