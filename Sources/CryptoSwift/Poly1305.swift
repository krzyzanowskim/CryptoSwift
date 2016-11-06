//
//  Poly1305.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  http://tools.ietf.org/html/draft-agl-tls-chacha20poly1305-04#section-4
//  nacl/crypto_onetimeauth/poly1305/ref/auth.c
//
///  Poly1305 takes a 32-byte, one-time key and a message and produces a 16-byte tag that authenticates the
///  message such that an attacker has a negligible chance of producing a valid tag for an inauthentic message.

public final class Poly1305: Authenticator {

    public enum Error: Swift.Error {
        case authenticateError
    }

    public static let blockSize: Int = 16

    private let key: SecureBytes

    /// - parameter key: 32-byte key
    public init(key: Array<UInt8>) {
        self.key = SecureBytes(bytes: key)
    }

    private func squeeze(h: inout Array<UInt32>) {
        assert(h.count == 17)
        var u: UInt32 = 0
        for j in 0..<16 {
            u = u &+ h[j]
            h[j] = u & 255
            u = u >> 8
        }

        u = u &+ h[16]
        h[16] = u & 3
        u = 5 * (u >> 2)

        for j in 0..<16 {
            u = u &+ h[j]
            h[j] = u & 255
            u = u >> 8
        }

        u = u &+ h[16]
        h[16] = u
    }

    private func add(h: inout Array<UInt32>, c: Array<UInt32>) {
        assert(h.count == 17 && c.count == 17)

        var u: UInt32 = 0
        for j in 0..<17 {
            u = u &+ (h[j] &+ c[j])
            h[j] = u & 255
            u = u >> 8
        }
    }

    private func mulmod(h: inout Array<UInt32>, r: Array<UInt32>) {
        var hr = Array<UInt32>(repeating: 0, count: 17)
        var u: UInt32 = 0
        for i in 0..<17 {
            u = 0
            for j in 0...i {
                u = u &+ (h[j] * r[i &- j])
            }
            for j in (i + 1)..<17 {
                u = u &+ (320 * h[j] * r[i &+ 17 &- j])
            }
            hr[i] = u
        }
        h = hr
        self.squeeze(h: &h)
    }

    private func freeze(h: inout Array<UInt32>) {
        let horig = h
        add(h: &h, c: [5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 252])
        let negative = UInt32(bitPattern: -Int32(h[16] >> 7))
        for j in 0..<17 {
            h[j] ^= negative & (horig[j] ^ h[j])
        }
    }

    /// the key is partitioned into two parts, called "r" and "s"
    fileprivate func onetimeauth(message input: Array<UInt8>, key k: Array<UInt8>) -> Array<UInt8> {
        // clamp
        var r = Array<UInt32>(repeating: 0, count: 17)
        var h = Array<UInt32>(repeating: 0, count: 17)
        var c = Array<UInt32>(repeating: 0, count: 17)

        r[0] = UInt32(k[0])
        r[1] = UInt32(k[1])
        r[2] = UInt32(k[2])
        r[3] = UInt32(k[3] & 15)
        r[4] = UInt32(k[4] & 252)
        r[5] = UInt32(k[5])
        r[6] = UInt32(k[6])
        r[7] = UInt32(k[7] & 15)
        r[8] = UInt32(k[8] & 252)
        r[9] = UInt32(k[9])
        r[10] = UInt32(k[10])
        r[11] = UInt32(k[11] & 15)
        r[12] = UInt32(k[12] & 252)
        r[13] = UInt32(k[13])
        r[14] = UInt32(k[14])
        r[15] = UInt32(k[15] & 15)
        r[16] = 0


        var inlen = input.count
        var inpos = 0
        while inlen > 0 {
            for j in 0..<c.count {
                c[j] = 0
            }

            let maxj = min(inlen, 16)
            for j in 0..<maxj {
                c[j] = UInt32(input[inpos + j])
            }
            c[maxj] = 1
            inpos = inpos + maxj
            inlen = inlen - maxj
            self.add(h: &h, c: c)
            self.mulmod(h: &h, r: r)
        }

        self.freeze(h: &h)

        for j in 0..<16 {
            c[j] = UInt32(k[j + 16])
        }
        c[16] = 0
        add(h: &h, c: c)

        return h[0..<16].map {
            UInt8($0 & 0xFF)
        }
    }

    // MARK: - Authenticator

    /**
     Calculate Message Authentication Code (MAC) for message.
     Calculation context is discarder on instance deallocation.

     - parameter bytes: Message

     - returns: 16-byte tag that authenticates the message
     */
    public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
        return onetimeauth(message: bytes, key: Array(self.key))
    }
}
