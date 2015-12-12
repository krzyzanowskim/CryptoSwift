//
//  SHA1.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 16/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

final class SHA1 : HashProtocol {
    static let size:Int = 20 // 160 / 8
    let message: [UInt8]
    
    init(_ message: [UInt8]) {
        self.message = message
    }
    
    private let h:[UInt32] = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]
        
    func calculate() -> [UInt8] {
        var tmpMessage = self.prepare(64)
        
        // hash values
        var hh = h
        
        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage += (self.message.count * 8).bytes(64 / 8)
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 32-bit words into eighty 32-bit words:
            var M:[UInt32] = [UInt32](count: 80, repeatedValue: 0)
            for x in 0..<M.count {
                switch (x) {
                case 0...15:
                    let start = chunk.startIndex + (x * sizeofValue(M[x]))
                    let end = start + sizeofValue(M[x])
                    let le = toUInt32Array(chunk[start..<end])[0]
                    M[x] = le.bigEndian
                    break
                default:
                    M[x] = rotateLeft(M[x-3] ^ M[x-8] ^ M[x-14] ^ M[x-16], 1) //FIXME: n:
                    break
                }
            }
            
            var A = hh[0]
            var B = hh[1]
            var C = hh[2]
            var D = hh[3]
            var E = hh[4]
            
            // Main loop
            for j in 0...79 {
                var f: UInt32 = 0;
                var k: UInt32 = 0
                
                switch (j) {
                case 0...19:
                    f = (B & C) | ((~B) & D)
                    k = 0x5A827999
                    break
                case 20...39:
                    f = B ^ C ^ D
                    k = 0x6ED9EBA1
                    break
                case 40...59:
                    f = (B & C) | (B & D) | (C & D)
                    k = 0x8F1BBCDC
                    break
                case 60...79:
                    f = B ^ C ^ D
                    k = 0xCA62C1D6
                    break
                default:
                    break
                }
                
                let temp = (rotateLeft(A,5) &+ f &+ E &+ M[j] &+ k) & 0xffffffff
                E = D
                D = C
                C = rotateLeft(B, 30)
                B = A
                A = temp
            }
            
            hh[0] = (hh[0] &+ A) & 0xffffffff
            hh[1] = (hh[1] &+ B) & 0xffffffff
            hh[2] = (hh[2] &+ C) & 0xffffffff
            hh[3] = (hh[3] &+ D) & 0xffffffff
            hh[4] = (hh[4] &+ E) & 0xffffffff
        }
        
        // Produce the final hash value (big-endian) as a 160 bit number:
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        hh.forEach {
            let item = $0.bigEndian
            result += [UInt8(item & 0xff), UInt8((item >> 8) & 0xff), UInt8((item >> 16) & 0xff), UInt8((item >> 24) & 0xff)]
        }
        return result
    }
}