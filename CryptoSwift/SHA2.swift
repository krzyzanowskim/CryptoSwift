//
//  SHA2.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 24/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class SHA2 : CryptoHashBase {
    
    enum variant {
        case sha224, sha256, sha384, sha512
        
        func h() -> [UInt32] {
            switch (self) {
            case .sha224:
                return [0xc1059ed8, 0x367cd507, 0x3070dd17, 0xf70e5939, 0xffc00b31, 0x68581511, 0x64f98fa7, 0xbefa4fa4]
            case .sha256:
                return [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
            default:
                return []
            }
        }
        
        func k() -> [UInt32] {
            switch (self) {
            case .sha224, .sha256:
                return [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
                    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
                    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
                    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
                    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
                    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
                    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
                    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]
            default:
                return []
            }
        }
        
        func resultingArray<T>(hh:[T]) -> [T] {
            var finalHH:[T] = hh;
            switch (self) {
            case .sha224:
                finalHH = Array(hh[0..<7])
                break;
            default:
                break;
            }
            return finalHH
        }
    }
    
    func calculate(variant: SHA2.variant) -> NSData {
        var tmpMessage = self.prepare()
        
        // hash values
        var hh = variant.h()
        
        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage.appendBytes((message.length * 8).bytes(64 / 8));
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        var leftMessageBytes = tmpMessage.length
        for var i = 0; i < tmpMessage.length; i = i + chunkSizeBytes, leftMessageBytes -= chunkSizeBytes {
            let chunk = tmpMessage.subdataWithRange(NSRange(location: i, length: min(chunkSizeBytes,leftMessageBytes)))
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 32-bit words into sixty-four 32-bit words:
            var M:[UInt32] = [UInt32](count: 64, repeatedValue: 0)
            for x in 0..<M.count {
                switch (x) {
                case 0...15:
                    var le:UInt32 = 0
                    chunk.getBytes(&le, range:NSRange(location:x * sizeofValue(le), length: sizeofValue(le)));
                    M[x] = le.bigEndian
                    break
                default:
                    let s0 = rotateRight(M[x-15], 7) ^ rotateRight(M[x-15], 18) ^ (M[x-15] >> 3)
                    let s1 = rotateRight(M[x-2], 17) ^ rotateRight(M[x-2], 19) ^ (M[x-2] >> 10)
                    M[x] = M[x-16] &+ s0 &+ M[x-7] &+ s1
                    break
                }
            }
            
            var A = hh[0]
            var B = hh[1]
            var C = hh[2]
            var D = hh[3]
            var E = hh[4]
            var F = hh[5]
            var G = hh[6]
            var H = hh[7]
            
            // Main loop
            for j in 0..<variant.k().count {
                let s0 = rotateRight(A,2) ^ rotateRight(A,13) ^ rotateRight(A,22)
                let maj = (A & B) ^ (A & C) ^ (B & C)
                let t2 = s0 &+ maj
                let s1 = rotateRight(E,6) ^ rotateRight(E,11) ^ rotateRight(E,25)
                let ch = (E & F) ^ ((~E) & G)
                let t1 = H &+ s1 &+ ch &+ variant.k()[j] &+ M[j]
                
                H = G
                G = F
                F = E
                E = D &+ t1
                D = C
                C = B
                B = A
                A = t1 &+ t2
            }
            
            hh[0] = (hh[0] &+ A) & 0xffffffff
            hh[1] = (hh[1] &+ B) & 0xffffffff
            hh[2] = (hh[2] &+ C) & 0xffffffff
            hh[3] = (hh[3] &+ D) & 0xffffffff
            hh[4] = (hh[4] &+ E) & 0xffffffff
            hh[5] = (hh[5] &+ F) & 0xffffffff
            hh[6] = (hh[6] &+ G) & 0xffffffff
            hh[7] = (hh[7] &+ H) & 0xffffffff
        }
        
        // Produce the final hash value (big-endian) as a 160 bit number:
        var buf: NSMutableData = NSMutableData();
        
        variant.resultingArray(hh).map({ (item) -> () in
            var i:UInt32 = item.bigEndian
            buf.appendBytes(&i, length: sizeofValue(i))
        })
        
        return buf.copy() as NSData;
    }
}