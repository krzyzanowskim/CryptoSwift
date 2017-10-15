//
//  ChaCha20.swift
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

//  https://tools.ietf.org/html/rfc7539
//

public final class ChaCha20: BlockCipher {

    public enum Error: Swift.Error {
        case invalidKeyOrInitializationVector
    }

    public static let blockSize = 64 // 512 / 8

    fileprivate let key: Key
    fileprivate var counter: Array<UInt8>

    public init(key: Array<UInt8>, iv nonce: Array<UInt8>) throws {
        precondition(nonce.count == 12 || nonce.count == 8)

        if key.count != 32 {
            throw Error.invalidKeyOrInitializationVector
        }

        self.key = Key(bytes: key)

        if nonce.count == 8 {
            counter = [0, 0, 0, 0, 0, 0, 0, 0] + nonce
        } else {
            counter = [0, 0, 0, 0] + nonce
        }

        assert(counter.count == 16)
    }

    /// https://tools.ietf.org/html/rfc7539#section-2.3.
    fileprivate func core(block: inout Array<UInt8>, counter: Array<UInt8>, key: Array<UInt8>) {
        precondition(block.count == ChaCha20.blockSize)
        precondition(counter.count == 16)
        precondition(key.count == 32)

        let j0: UInt32 = 0x61707865
        let j1: UInt32 = 0x3320646e // 0x3620646e sigma/tau
        let j2: UInt32 = 0x79622d32
        let j3: UInt32 = 0x6b206574
        let j4: UInt32 = UInt32(bytes: key[0..<4]).bigEndian
        let j5: UInt32 = UInt32(bytes: key[4..<8]).bigEndian
        let j6: UInt32 = UInt32(bytes: key[8..<12]).bigEndian
        let j7: UInt32 = UInt32(bytes: key[12..<16]).bigEndian
        let j8: UInt32 = UInt32(bytes: key[16..<20]).bigEndian
        let j9: UInt32 = UInt32(bytes: key[20..<24]).bigEndian
        let j10: UInt32 = UInt32(bytes: key[24..<28]).bigEndian
        let j11: UInt32 = UInt32(bytes: key[28..<32]).bigEndian
        let j12: UInt32 = UInt32(bytes: counter[0..<4]).bigEndian
        let j13: UInt32 = UInt32(bytes: counter[4..<8]).bigEndian
        let j14: UInt32 = UInt32(bytes: counter[8..<12]).bigEndian
        let j15: UInt32 = UInt32(bytes: counter[12..<16]).bigEndian

        var (x0, x1, x2, x3, x4, x5, x6, x7) = (j0, j1, j2, j3, j4, j5, j6, j7)
        var (x8, x9, x10, x11, x12, x13, x14, x15) = (j8, j9, j10, j11, j12, j13, j14, j15)

        for _ in 0..<10 { // 20 rounds
            x0 = x0 &+ x4
            x12 ^= x0
            x12 = (x12 << 16) | (x12 >> 16)
            x8 = x8 &+ x12
            x4 ^= x8
            x4 = (x4 << 12) | (x4 >> 20)
            x0 = x0 &+ x4
            x12 ^= x0
            x12 = (x12 << 8) | (x12 >> 24)
            x8 = x8 &+ x12
            x4 ^= x8
            x4 = (x4 << 7) | (x4 >> 25)
            x1 = x1 &+ x5
            x13 ^= x1
            x13 = (x13 << 16) | (x13 >> 16)
            x9 = x9 &+ x13
            x5 ^= x9
            x5 = (x5 << 12) | (x5 >> 20)
            x1 = x1 &+ x5
            x13 ^= x1
            x13 = (x13 << 8) | (x13 >> 24)
            x9 = x9 &+ x13
            x5 ^= x9
            x5 = (x5 << 7) | (x5 >> 25)
            x2 = x2 &+ x6
            x14 ^= x2
            x14 = (x14 << 16) | (x14 >> 16)
            x10 = x10 &+ x14
            x6 ^= x10
            x6 = (x6 << 12) | (x6 >> 20)
            x2 = x2 &+ x6
            x14 ^= x2
            x14 = (x14 << 8) | (x14 >> 24)
            x10 = x10 &+ x14
            x6 ^= x10
            x6 = (x6 << 7) | (x6 >> 25)
            x3 = x3 &+ x7
            x15 ^= x3
            x15 = (x15 << 16) | (x15 >> 16)
            x11 = x11 &+ x15
            x7 ^= x11
            x7 = (x7 << 12) | (x7 >> 20)
            x3 = x3 &+ x7
            x15 ^= x3
            x15 = (x15 << 8) | (x15 >> 24)
            x11 = x11 &+ x15
            x7 ^= x11
            x7 = (x7 << 7) | (x7 >> 25)
            x0 = x0 &+ x5
            x15 ^= x0
            x15 = (x15 << 16) | (x15 >> 16)
            x10 = x10 &+ x15
            x5 ^= x10
            x5 = (x5 << 12) | (x5 >> 20)
            x0 = x0 &+ x5
            x15 ^= x0
            x15 = (x15 << 8) | (x15 >> 24)
            x10 = x10 &+ x15
            x5 ^= x10
            x5 = (x5 << 7) | (x5 >> 25)
            x1 = x1 &+ x6
            x12 ^= x1
            x12 = (x12 << 16) | (x12 >> 16)
            x11 = x11 &+ x12
            x6 ^= x11
            x6 = (x6 << 12) | (x6 >> 20)
            x1 = x1 &+ x6
            x12 ^= x1
            x12 = (x12 << 8) | (x12 >> 24)
            x11 = x11 &+ x12
            x6 ^= x11
            x6 = (x6 << 7) | (x6 >> 25)
            x2 = x2 &+ x7
            x13 ^= x2
            x13 = (x13 << 16) | (x13 >> 16)
            x8 = x8 &+ x13
            x7 ^= x8
            x7 = (x7 << 12) | (x7 >> 20)
            x2 = x2 &+ x7
            x13 ^= x2
            x13 = (x13 << 8) | (x13 >> 24)
            x8 = x8 &+ x13
            x7 ^= x8
            x7 = (x7 << 7) | (x7 >> 25)
            x3 = x3 &+ x4
            x14 ^= x3
            x14 = (x14 << 16) | (x14 >> 16)
            x9 = x9 &+ x14
            x4 ^= x9
            x4 = (x4 << 12) | (x4 >> 20)
            x3 = x3 &+ x4
            x14 ^= x3
            x14 = (x14 << 8) | (x14 >> 24)
            x9 = x9 &+ x14
            x4 ^= x9
            x4 = (x4 << 7) | (x4 >> 25)
        }

        x0 = x0 &+ j0
        x1 = x1 &+ j1
        x2 = x2 &+ j2
        x3 = x3 &+ j3
        x4 = x4 &+ j4
        x5 = x5 &+ j5
        x6 = x6 &+ j6
        x7 = x7 &+ j7
        x8 = x8 &+ j8
        x9 = x9 &+ j9
        x10 = x10 &+ j10
        x11 = x11 &+ j11
        x12 = x12 &+ j12
        x13 = x13 &+ j13
        x14 = x14 &+ j14
        x15 = x15 &+ j15

        block.replaceSubrange(0..<4, with: x0.bigEndian.bytes())
        block.replaceSubrange(4..<8, with: x1.bigEndian.bytes())
        block.replaceSubrange(8..<12, with: x2.bigEndian.bytes())
        block.replaceSubrange(12..<16, with: x3.bigEndian.bytes())
        block.replaceSubrange(16..<20, with: x4.bigEndian.bytes())
        block.replaceSubrange(20..<24, with: x5.bigEndian.bytes())
        block.replaceSubrange(24..<28, with: x6.bigEndian.bytes())
        block.replaceSubrange(28..<32, with: x7.bigEndian.bytes())
        block.replaceSubrange(32..<36, with: x8.bigEndian.bytes())
        block.replaceSubrange(36..<40, with: x9.bigEndian.bytes())
        block.replaceSubrange(40..<44, with: x10.bigEndian.bytes())
        block.replaceSubrange(44..<48, with: x11.bigEndian.bytes())
        block.replaceSubrange(48..<52, with: x12.bigEndian.bytes())
        block.replaceSubrange(52..<56, with: x13.bigEndian.bytes())
        block.replaceSubrange(56..<60, with: x14.bigEndian.bytes())
        block.replaceSubrange(60..<64, with: x15.bigEndian.bytes())
    }

    // XORKeyStream
    func process(bytes: Array<UInt8>, counter: inout Array<UInt8>, key: Array<UInt8>) -> Array<UInt8> {
        precondition(counter.count == 16)
        precondition(key.count == 32)

        var block = Array<UInt8>(repeating: 0, count: ChaCha20.blockSize)
        var bytes = bytes // TODO: check bytes[bytes.indices]
        var out = Array<UInt8>(reserveCapacity: bytes.count)

        while bytes.count >= ChaCha20.blockSize {
            core(block: &block, counter: counter, key: key)
            for (i, x) in block.enumerated() {
                out.append(bytes[i] ^ x)
            }
            var u: UInt32 = 1
            for i in 0..<4 {
                u += UInt32(counter[i])
                counter[i] = UInt8(u)
                u >>= 8
            }
            bytes = Array(bytes[ChaCha20.blockSize..<bytes.endIndex])
        }

        if bytes.count > 0 {
            core(block: &block, counter: counter, key: key)
            for (i, v) in bytes.enumerated() {
                out.append(v ^ block[i])
            }
        }
        return out
    }
}

// MARK: Cipher
extension ChaCha20: Cipher {

    public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
        return process(bytes: Array(bytes), counter: &counter, key: Array(key))
    }

    public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
        return try encrypt(bytes)
    }
}

// MARK: Encryptor
extension ChaCha20 {

    public struct Encryptor: Updatable {
        private var accumulated = Array<UInt8>()
        private let chacha: ChaCha20

        init(chacha: ChaCha20) {
            self.chacha = chacha
        }

        public mutating func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool = false) throws -> Array<UInt8> {
            accumulated += bytes

            var encrypted = Array<UInt8>()
            encrypted.reserveCapacity(accumulated.count)
            for chunk in accumulated.batched(by: ChaCha20.blockSize) {
                if isLast || accumulated.count >= ChaCha20.blockSize {
                    encrypted += try chacha.encrypt(chunk)
                    accumulated.removeFirst(chunk.count) // TODO: improve performance
                }
            }
            return encrypted
        }
    }
}

// MARK: Decryptor
extension ChaCha20 {

    public struct Decryptor: Updatable {
        private var accumulated = Array<UInt8>()

        private var offset: Int = 0
        private var offsetToRemove: Int = 0
        private let chacha: ChaCha20

        init(chacha: ChaCha20) {
            self.chacha = chacha
        }

        public mutating func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool = true) throws -> Array<UInt8> {
            // prepend "offset" number of bytes at the begining
            if offset > 0 {
                accumulated += Array<UInt8>(repeating: 0, count: offset) + bytes
                offsetToRemove = offset
                offset = 0
            } else {
                accumulated += bytes
            }

            var plaintext = Array<UInt8>()
            plaintext.reserveCapacity(accumulated.count)
            for chunk in accumulated.batched(by: ChaCha20.blockSize) {
                if isLast || accumulated.count >= ChaCha20.blockSize {
                    plaintext += try chacha.decrypt(chunk)

                    // remove "offset" from the beginning of first chunk
                    if offsetToRemove > 0 {
                        plaintext.removeFirst(offsetToRemove) // TODO: improve performance
                        offsetToRemove = 0
                    }

                    accumulated.removeFirst(chunk.count)
                }
            }

            return plaintext
        }
    }
}

// MARK: Cryptors
extension ChaCha20: Cryptors {

    public func makeEncryptor() -> ChaCha20.Encryptor {
        return Encryptor(chacha: self)
    }

    public func makeDecryptor() -> ChaCha20.Decryptor {
        return Decryptor(chacha: self)
    }
}
