//
//  ChaCha20.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 25/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

public final class ChaCha20: BlockCipher {

    public enum Error: Swift.Error {
        case invalidKeyOrInitializationVector
    }

    public static let blockSize = 64 // 512 / 8
    fileprivate let context: Context

    fileprivate struct Context {
        var input = Array<UInt32>(repeating: 0, count: 16)

        init(key: Array<UInt8>, iv: Array<UInt8>) throws {
            precondition(iv.count >= 8)

            let kbits = key.count * 8

            if (kbits != 128 && kbits != 256) {
                throw Error.invalidKeyOrInitializationVector
            }

            // 4 - 8
            for i in 0 ..< 4 {
                let start = i * 4
                input[i + 4] = wordNumber(key[start ..< (start + 4)])
            }

            var addPos = 0
            switch (kbits) {
            case 256:
                addPos += 16
                // sigma
                input[0] = 0x61707865 // apxe
                input[1] = 0x3320646e // 3 dn
                input[2] = 0x79622d32 // yb-2
                input[3] = 0x6b206574 // k et
            default:
                // tau
                input[0] = 0x61707865 // apxe
                input[1] = 0x3620646e // 6 dn
                input[2] = 0x79622d31 // yb-1
                input[3] = 0x6b206574 // k et
            }

            // 8 - 11
            for i in 0 ..< 4 {
                let start = addPos + (i * 4)

                let bytes = key[start ..< (start + 4)]
                input[i + 8] = wordNumber(bytes)
            }

            // iv
            input[12] = 0
            input[13] = 0
            input[14] = wordNumber(iv[0 ..< 4])
            input[15] = wordNumber(iv[4 ..< 8])
        }
    }

    public init(key: Array<UInt8>, iv: Array<UInt8>) throws {
        self.context = try Context(key: key, iv: iv)
    }

    fileprivate func wordToByte(_ input: Array<UInt32> /* 64 */ ) -> Array<UInt8>? /* 16 */ {
        precondition(input.count == 16)

        var x = input

        for _ in 0 ..< 10 {
            quarterround(&x[0], &x[4], &x[8], &x[12])
            quarterround(&x[1], &x[5], &x[9], &x[13])
            quarterround(&x[2], &x[6], &x[10], &x[14])
            quarterround(&x[3], &x[7], &x[11], &x[15])
            quarterround(&x[0], &x[5], &x[10], &x[15])
            quarterround(&x[1], &x[6], &x[11], &x[12])
            quarterround(&x[2], &x[7], &x[8], &x[13])
            quarterround(&x[3], &x[4], &x[9], &x[14])
        }

        var output = Array<UInt8>()
        output.reserveCapacity(16)

        for i in 0 ..< 16 {
            x[i] = x[i] &+ input[i]
            output.append(contentsOf: x[i].bytes().reversed())
        }

        return output
    }

    private final func quarterround(_ a: inout UInt32, _ b: inout UInt32, _ c: inout UInt32, _ d: inout UInt32) {
        a = a &+ b
        d = rotateLeft((d ^ a), by: 16) // FIXME: WAT? n:

        c = c &+ d
        b = rotateLeft((b ^ c), by: 12)

        a = a &+ b
        d = rotateLeft((d ^ a), by: 8)

        c = c &+ d
        b = rotateLeft((b ^ c), by: 7)
    }
}

// MARK: Cipher
extension ChaCha20: Cipher {

    public func encrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int {
        var ctx = context
        var c = Array<UInt8>(repeating: 0, count: bytes.count)

        var cPos: Int = 0
        var mPos: Int = 0
        var bytesCount = bytes.count

        while (true) {
            if let output = wordToByte(ctx.input) {
                ctx.input[12] = ctx.input[12] &+ 1
                if (ctx.input[12] == 0) {
                    ctx.input[13] = ctx.input[13] &+ 1
                    /* stopping at 2^70 bytes per nonce is user's responsibility */
                }
                if (bytesCount <= ChaCha20.blockSize) {
                    for i in 0 ..< bytesCount {
                        c[i + cPos] = bytes[i + mPos] ^ output[i]
                    }
                    return c
                }
                for i in 0 ..< ChaCha20.blockSize {
                    c[i + cPos] = bytes[i + mPos] ^ output[i]
                }
                bytesCount -= ChaCha20.blockSize
                cPos += ChaCha20.blockSize
                mPos += ChaCha20.blockSize
            }
        }
    }

    public func decrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int {
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

        mutating public func update<T: Collection>(withBytes bytes: T, isLast: Bool = false) throws -> Array<UInt8> where T.Iterator.Element == UInt8 {
            self.accumulated += bytes

            var encrypted = Array<UInt8>()
            encrypted.reserveCapacity(self.accumulated.count)
            for chunk in BytesSequence(chunkSize: ChaCha20.blockSize, data: self.accumulated) {
                if (isLast || self.accumulated.count >= ChaCha20.blockSize) {
                    encrypted += try chacha.encrypt(chunk)
                    self.accumulated.removeFirst(chunk.count)
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

        mutating public func update<T: Collection>(withBytes bytes: T, isLast: Bool = true) throws -> Array<UInt8> where T.Iterator.Element == UInt8 {
            // prepend "offset" number of bytes at the begining
            if self.offset > 0 {
                self.accumulated += Array<UInt8>(repeating: 0, count: offset) + bytes
                self.offsetToRemove = offset
                self.offset = 0
            } else {
                self.accumulated += bytes
            }

            var plaintext = Array<UInt8>()
            plaintext.reserveCapacity(self.accumulated.count)
            for chunk in BytesSequence(chunkSize: ChaCha20.blockSize, data: self.accumulated) {
                if (isLast || self.accumulated.count >= ChaCha20.blockSize) {
                    plaintext += try chacha.decrypt(chunk)

                    // remove "offset" from the beginning of first chunk
                    if self.offsetToRemove > 0 {
                        plaintext.removeFirst(self.offsetToRemove)
                        self.offsetToRemove = 0
                    }

                    self.accumulated.removeFirst(chunk.count)
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

// MARK: Helpers

/// Change array to number. It's here because arrayOfBytes is too slow
private func wordNumber<T: Collection>(_ bytes: T) -> UInt32 where T.Iterator.Element == UInt8, T.IndexDistance == Int {
    var value: UInt32 = 0
    for i: UInt32 in 0 ..< 4 {
        let j = bytes.index(bytes.startIndex, offsetBy: Int(i))
        value = value | UInt32(bytes[j]) << (8 * i)
    }

    return value
}
