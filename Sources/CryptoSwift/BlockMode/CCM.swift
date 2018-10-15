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
    private let tagLength: Int
    private let messageLength: Int // total message length. need to know in advance

    public init(nonce: Array<UInt8>, tagSize: Int, messageLength: Int, additionalAuthenticatedData: Array<UInt8>? = nil) {
        self.nonce = nonce
        self.tagLength = tagSize
        self.additionalAuthenticatedData = additionalAuthenticatedData
        self.messageLength = messageLength
    }

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
        if nonce.isEmpty {
            throw Error.invalidInitializationVector
        }

        return CCMModeWorker(blockSize: blockSize, nonce: nonce.slice, messageLength: messageLength, additionalAuthenticatedData: additionalAuthenticatedData, tagSize: tagLength, cipherOperation: cipherOperation)
    }
}

struct CCMModeWorker: BlockModeWorkerFinalizing {
    let cipherOperation: CipherOperationOnBlock
    let blockSize: Int
    private let tagLength: Int
    private let messageLength: Int // total message length. need to know in advance
    private var counter = 0
    private let q: UInt8

    let additionalBufferSize: Int = 0
    private let nonce: Array<UInt8>
    private var prev: ArraySlice<UInt8>

    public enum Error: Swift.Error {
        case invalidParameter
    }

    init(blockSize: Int, nonce: ArraySlice<UInt8>, messageLength: Int,  additionalAuthenticatedData: [UInt8]?, tagSize: Int, cipherOperation: @escaping CipherOperationOnBlock) {
        self.blockSize = blockSize
        self.tagLength = tagSize
        self.messageLength = messageLength
        self.cipherOperation = cipherOperation
        self.nonce = Array(nonce)
        self.q = UInt8(15 - nonce.count) // n = 15-q

        // For the very first time setup new IV (aka y0) from the block0
        let hasAssociatedData = additionalAuthenticatedData != nil && !additionalAuthenticatedData!.isEmpty
        let block0 = try! format(nonce: self.nonce, Q: UInt32(messageLength), q: q, t: UInt8(tagSize), hasAssociatedData: hasAssociatedData).slice
        let y0 = cipherOperation(block0)!.slice
        prev = y0

        if let aad = additionalAuthenticatedData {
            process(aad: aad)
        }
    }

    private mutating func process(aad: [UInt8]) {
        let encodedAAD = format(aad: aad)

        for block_i in encodedAAD.batched(by: 16) {
            let y_i = cipherOperation(xor(block_i, prev))!.slice
            prev = y_i
            counter += 1
        }
    }

    private func S(i: Int) throws -> [UInt8] {
        let ctr = try format(counter: i, nonce: nonce, q: q)
        return cipherOperation(ctr.slice)!
    }

    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        // y[i], where i is the counter
        guard let y = cipherOperation(xor(prev, plaintext)),
              let S = try? S(i: counter)
        else {
            return Array(plaintext)
        }

        let result = xor(plaintext, S) as Array<UInt8> // P xor MSBplen(S)

        prev = y.slice
        counter += 1

        return result
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
        guard let S0 = try? S(i: 0) else {
            return Array(ciphertext)
        }

        let tag = prev.prefix(tagLength)

        return Array(ciphertext) + (xor(tag, S0) as Array<UInt8>)
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

    var block0: [UInt8] = Array<UInt8>(repeating: 0, count: 16)
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

/// Resulting can be partitioned into 16-octet blocks
private func format(aad: [UInt8]) -> [UInt8] {
    let a = aad.count

    switch Double(a) {
    case 0..<65280: // 2^16-2^8
        // [a]16
        return ZeroPadding().add(to: a.bytes(totalBytes: 2) + aad, blockSize: 16)
    case 65280..<4_294_967_296: // 2^32
        // [a]32
        return ZeroPadding().add(to: [0xFF, 0xFE] + a.bytes(totalBytes: 4) + aad, blockSize: 16)
    case 4_294_967_296..<pow(2,64): // 2^64
        // [a]64
        return ZeroPadding().add(to: [0xFF, 0xFF] + a.bytes(totalBytes: 8) + aad, blockSize: 16)
    default:
        // Reserved
        return ZeroPadding().add(to: aad, blockSize: 16)
    }
}
