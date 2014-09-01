//
//  Poly1305.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  http://tools.ietf.org/html/draft-agl-tls-chacha20poly1305-04#section-4
//
//  Poly1305 takes a 32-byte, one-time key and a message and produces a 16-byte tag that authenticates the
//  message such that an attacker has a negligible chance of producing a valid tag for an inauthentic message.

import Foundation

class Poly1305 {
    let blockSize = 16
    
    var buffer:[Byte] = [Byte](count: 16, repeatedValue: 0)
    var r:[Byte] = [Byte](count: 17, repeatedValue: 0)
    var h:[Byte] = [Byte](count: 17, repeatedValue: 0)
    var pad:[Byte] = [Byte](count: 17, repeatedValue: 0)
    var final:Byte = 0
    var leftover:Int = 0
    
    init (key: [Byte]) {
        if (key.count != 32) {
            return;
        }
        
        for i in 0..<17 {
            h[i] = 0
        }

        for i in 0..<16 {
            r[i] = key[i] & 0x0f
            pad[i] = key[i + 16]
        }

        h[16] = 0
        r[16] = 0
        pad[16] = 0
        
        leftover = 0
        final = 0
    }
    
    deinit {
        for i in 0...(r.count) {
            r[i] = 0
            h[i] = 0
            pad[i] = 0
            final = 0
        }
    }
    
    func add(inout h:[Byte], c:[Byte]) -> Bool {
        if (h.count != 17 && c.count != 17) {
            return false
        }
        
        var u:Byte = 0
        for i in 0..<h.count {
            u = u &+ h[i] &+ c[i]
            h[0] = u
            u >>= 8
        }
        return true
    }
    
    func squeeze(inout h:[Byte], hr:[UInt32]) -> Bool {
        if (h.count != 17 && hr.count != 17) {
            return false
        }

        var u:UInt32 = 0

        for i in 0..<16 {
            u = u &+ hr[i];
            h[i] = Byte(u) & 0xff;
            u >>= 8;
        }
        
        u = u &+ hr[16]
        h[16] = Byte(u) & 0x03
        u >>= 2
        u += (u << 2); /* u *= 5; */
        for i in 0..<16 {
            u = u &+ UInt32(h[i])
            h[i] = Byte(u) & 0xff
            u >>= 8
        }
        h[16] = h[16] &+ Byte(u);
        
        return true
    }
    
    func freeze(inout h:[Byte]) -> Bool {
        if (h.count != 17) {
            return false
        }
        
        let minusp:[Byte] = [0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xfc]
        var horig:[Byte] = [Byte](count: 17, repeatedValue: 0)
        
        /* compute h + -p */
        for i in 0..<17 {
            horig[i] = h[i]
        }
        
        add(&h, c: minusp)
        
        /* select h if h < p, or h + -p if h >= p */
        let bits:[Bit] = (h[16] >> 7).bits()
        let invertedBits = bits.map({ (bit) -> Bit in
            return bit.inverted()
        })
        
        let negative = Byte(bits: invertedBits)
        for i in 0..<17 {
            h[i] ^= negative & (horig[i] ^ h[i]);
        }
        
        return true;
    }
    
    func blocks(m:[Byte], startPos:Int = 0) -> Int {
        var bytes = m.count
        let hibit = final ^ 1 // 1 <<128
        var mPos = startPos
        
        while (bytes >= Int(blockSize)) {
            var hr:[UInt32] = [UInt32](count: 17, repeatedValue: 0)
            var u:UInt32 = 0
            var c:[Byte] = [Byte](count: 17, repeatedValue: 0)
            
            /* h += m */
            for i in 0..<16 {
                c[i] = m[mPos + i]
            }
            c[16] = hibit
            add(&h,c: c)
            
            /* h *= r */
            for i in 0..<17 {
                u = 0
                for j in 0...i {
                    u = u + UInt32(UInt16(h[j])) * UInt32(r[i - j]) // u += (unsigned short)st->h[j] * st->r[i - j];
                }
                for j in (i+1)..<17 {
                    var v:UInt32 = UInt32(UInt16(h[j])) * UInt32(r[i + 17 - j])  // unsigned long v = (unsigned short)st->h[j] * st->r[i + 17 - j];
                    v = ((v &<< 8) &+ (v &<< 6))
                    u = u &+ v
                }
                hr[i] = u
            }
            squeeze(&h, hr: hr)
            
            mPos += blockSize //m = m + blockSize
            bytes -= blockSize
        }
        return mPos
    }
    
    func finish(inout mac:[Byte]) -> Bool {
        if (h.count != 16) {
            return false
        }
        
        /* process the remaining block */
        if (leftover > 0) {
            var i = leftover
            buffer[i++] = 1
            for (; i < blockSize; i++) {
                buffer[i] = 0
            }
            final = 1
            blocks(buffer)
        }
        
        /* fully reduce h */
        freeze(&h)
        
        /* h = (h + pad) % (1 << 128) */
        add(&h, c: pad)
        for i in 0..<16 {
            mac[i] = h[i]
        }
        
        return true
    }
    
    func update(m:[Byte]) {
        var bytes = m.count
        var mPos = 0
        
        /* handle leftover */
        if (leftover > 0) {
            var want = blockSize - leftover
            if (want > bytes) {
                want = bytes
            }
            
            for i in 0..<want {
                buffer[leftover + i] = m[mPos + i]
            }
            
            bytes -= want
            mPos += want
            leftover += want
            
            if (leftover < blockSize) {
                return
            }
            
            blocks(buffer)
            leftover = 0
        }
        
        /* process full blocks */
        if (bytes >= blockSize) {
            var want = bytes & ~(blockSize - 1)
            blocks(m, startPos: mPos)
            mPos += want
            bytes -= want;
        }
        
        /* store leftover */
        if (bytes > 0) {
            for i in 0..<bytes {
                buffer[leftover + 1] = m[i]
            }
            
            leftover += bytes
        }
    }
    
    func auth(mac:[Byte], m:[Byte]) {
        update(m)
        var macLocal = mac
        finish(&macLocal)
    }
}