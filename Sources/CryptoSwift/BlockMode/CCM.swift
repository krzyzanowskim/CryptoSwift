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
    private let nonce: Array<UInt8>
    private let additionalAuthenticatedData: Array<UInt8>?

    public init(nonce: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil) {
        self.nonce = nonce
        self.additionalAuthenticatedData = additionalAuthenticatedData
    }

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
        if nonce.isEmpty {
            throw Error.invalidInitializationVector
        }

        return CCMModeWorker(blockSize: blockSize, nonce: nonce.slice, additionalAuthenticatedData: additionalAuthenticatedData, tagSize: 16, cipherOperation: cipherOperation)
    }
}

struct CCMModeWorker: BlockModeWorkerFinalizing {
    let cipherOperation: CipherOperationOnBlock
    let blockSize: Int
    let tagSize: Int
    lazy var S0: Array<UInt8> = {
        let ctr = try! format(counter: counter, nonce: Array(nonce), q: q) // ???? q = 3
        return cipherOperation(ctr.slice)!
    }()
    var counter: Int = 0
    let q: UInt8

    let additionalBufferSize: Int = 0
    private let nonce: ArraySlice<UInt8>
    private var prev: ArraySlice<UInt8>

    public enum Error: Swift.Error {
        case invalidParameter
    }

    init(blockSize: Int, nonce: ArraySlice<UInt8>, additionalAuthenticatedData: [UInt8]?, tagSize: Int, cipherOperation: @escaping CipherOperationOnBlock) {
        self.blockSize = blockSize
        self.tagSize = tagSize
        self.cipherOperation = cipherOperation
        self.nonce = nonce
        self.q = UInt8(15 - nonce.count) // n = 15-q

        // For the very first time setup new IV (aka y0) from the block0
        let block0 = try! format(nonce: Array(nonce), Q: UInt32(blockSize), q: q, t: UInt8(tagSize), hasAssociatedData: false).slice
        let encodedAAD: [UInt8]
        if let aad = additionalAuthenticatedData {
            encodedAAD = format(aad: aad)
        } else {
            encodedAAD = []
        }
        prev = cipherOperation(block0 + encodedAAD)!.slice // y0
    }

    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        guard let y_i = cipherOperation(xor(prev, plaintext)) else {
            return Array(plaintext)
        }

        guard let ctr_j = try? format(counter: counter, nonce: Array(nonce), q: q), let S_j = cipherOperation(ctr_j.slice) else {
            return Array(plaintext)
        }

        prev = y_i.slice
        counter = counter + 1
        return xor(y_i, S_j) // P xor MSBplen(S)
    }

    // TODO
    mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        guard let plaintext = cipherOperation(ciphertext) else {
            return Array(ciphertext)
        }
        let result: Array<UInt8> = xor(prev, plaintext)
        prev = ciphertext
        return result
    }

    mutating func finalize(encrypt ciphertext: ArraySlice<UInt8>) throws -> Array<UInt8> {
        // contatenate T at the end
        let T = ciphertext.prefix(tagSize) // T
        let tag = xor(T, S0.prefix(tagSize)) as Array<UInt8> // T xor MSBtlen(S0)
        return Array(ciphertext) + tag
    }

    func willDecryptLast(block ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
        return ciphertext
    }

    func didDecryptLast(block plaintext: ArraySlice<UInt8>) throws -> Array<UInt8> {
        return Array(plaintext)
    }
}

// Q - octet length of P
// q - octet length of Q. Maximum length (in octets) of payload. An element of {2,3,4,5,6,7,8}
// t - octet length of T (MAC length). An element of {4,6,8,10,12,14,16}
private func format(nonce N: [UInt8], Q: UInt32, q: UInt8, t: UInt8, hasAssociatedData: Bool) throws -> [UInt8] {
    var flags0: UInt8 = 0

    if hasAssociatedData {
        // 7 bit
        flags0 |= (1 << 6)
    }

    // 6,5,4 bit is t in 3 bits
    flags0 |= (((t-2)/2) & 0x07) << 3

    // 3,2,1 bit is q in 3 bits
    flags0 |= ((q-1) & 0x07) << 0

    var block0: [UInt8] = Array<UInt8>(repeating: 0, count: 16) // block[0]
    block0[0] = flags0

    // N in 1...(15-q) octets, n = 15-q
    // n is an element of {7,8,9,10,11,12,13}
    let n = 15-Int(q)
    guard (n + Int(q)) == 15 else {
        // n+q == 15
        throw CCMModeWorker.Error.invalidParameter
    }
    block0[1...n] = N[0...(n-1)]

    // Q in (16-q)...15 octets
    block0[(16-Int(q))...15] = Q.bytes(totalBytes: Int(q)).slice

    return block0
}

/// Formatting of the Counter Blocks. Ctr[i]
/// The counter generation function.
/// Q - octet length of P
/// q - octet length of Q. Maximum length (in octets) of payload. An element of {2,3,4,5,6,7,8}
private func format(counter i: Int, nonce N: [UInt8], q: UInt8) throws -> [UInt8] {
    var flags0: UInt8 = 0

    // bit 8,7 is Reserved
    // bit 4,5,6 shall be set to 0
    // 3,2,1 bit is q in 3 bits
    flags0 |= ((q-1) & 0x07) << 0

    var block = Array<UInt8>(repeating: 0, count: 16) // block[0]
    block[0] = flags0

    // N in 1...(15-q) octets, n = 15-q
    // n is an element of {7,8,9,10,11,12,13}
    let n = 15-Int(q)
    guard (n + Int(q)) == 15 else {
        // n+q == 15
        throw CCMModeWorker.Error.invalidParameter
    }
    block[1...n] = N[0...(n-1)]

    // [i]8q in (16-q)...15 octets
    block[(16-Int(q))...15] = i.bytes(totalBytes: Int(q)).slice

    return block
}

private func format(aad: [UInt8]) -> [UInt8] {
    let a = aad.count

    switch Double(a) {
    case 0..<65280: // 2^16-2^8
        // [a]16
        return a.bytes(totalBytes: 2)
    case 65280..<4_294_967_296: // 2^32
        // [a]32
        return [0xFF, 0xFE] + a.bytes(totalBytes: 4)
    case 4_294_967_296..<pow(2,64): // 2^64
        // [a]64
        return [0xFF, 0xFF] + a.bytes(totalBytes: 8)
    default:
        // Reserved
        return aad
    }
}
