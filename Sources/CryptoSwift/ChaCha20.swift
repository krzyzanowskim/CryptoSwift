//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  Copyright (C) 2019      Roger Miret Giné    <roger.miret@gmail.com>
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

public final class ChaCha20: Salsa20 {

    override internal func qr(_ a: inout UInt32, _ b: inout UInt32, _ c: inout UInt32, _ d: inout UInt32) {
        a = a &+ b
        d ^= a
        d = rotl(d, 16)

        c = c &+ d
        b ^= c
        b = rotl(b, 12)

        a = a &+ b
        d ^= a
        d = rotl(d, 8)

        c = c &+ d
        b ^= c
        b = rotl(b, 7)
    }

    /// https://tools.ietf.org/html/rfc7539#section-2.3.
    override internal func core(block: inout Array<UInt8>, counter: Array<UInt8>, key: Array<UInt8>) {
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
            // Odd round
            qr(&x0, &x4, &x8, &x12)
            qr(&x1, &x5, &x9, &x13)
            qr(&x2, &x6, &x10, &x14)
            qr(&x3, &x7, &x11, &x15)
            // Even round
            qr(&x0, &x5, &x10, &x15)
            qr(&x1, &x6, &x11, &x12)
            qr(&x2, &x7, &x8, &x13)
            qr(&x3, &x4, &x9, &x14)
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
}
