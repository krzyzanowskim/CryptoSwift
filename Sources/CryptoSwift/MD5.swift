//
//  MD5.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

final class MD5 : HashProtocol  {
    static let size:Int = 16 // 128 / 8
    let message: Array<UInt8>
    
    init (_ message: Array<UInt8>) {
        self.message = message
    }

    /** specifies the per-round shift amounts */
    private let s: [UInt32] = [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
                       5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
                       4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
                       6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21]
    
    /** binary integer part of the sines of integers (Radians) */
    private let k: [UInt32] = [0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,
                       0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
                       0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,
                       0x6b901122,0xfd987193,0xa679438e,0x49b40821,
                       0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,
                       0xd62f105d,0x2441453,0xd8a1e681,0xe7d3fbc8,
                       0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,
                       0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
                       0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,
                       0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
                       0x289b7ec6,0xeaa127fa,0xd4ef3085,0x4881d05,
                       0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
                       0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,
                       0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
                       0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,
                       0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391]
    
    private let h:[UInt32] = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
    
    func calculate() -> [UInt8] {
        var tmpMessage = prepare(64)
        tmpMessage.reserveCapacity(tmpMessage.count + 4)

        // initialize hh with hash values
        var hh = h
        
        // Step 2. Append Length a 64-bit representation of lengthInBits
        let lengthInBits = (message.count * 8)
        let lengthBytes = lengthInBits.bytes(64 / 8)
        tmpMessage += lengthBytes.reversed()

        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            var M = toUInt32Array(chunk)
            assert(M.count == 16, "Invalid array")
            
            // Initialize hash value for this chunk:
            var A:UInt32 = hh[0]
            var B:UInt32 = hh[1]
            var C:UInt32 = hh[2]
            var D:UInt32 = hh[3]
            
            var dTemp:UInt32 = 0
            
            // Main loop
            for j in 0..<k.count {
                var g = 0
                var F:UInt32 = 0
                
                switch (j) {
                case 0...15:
                    F = (B & C) | ((~B) & D)
                    g = j
                    break
                case 16...31:
                    F = (D & B) | (~D & C)
                    g = (5 * j + 1) % 16
                    break
                case 32...47:
                    F = B ^ C ^ D
                    g = (3 * j + 5) % 16
                    break
                case 48...63:
                    F = C ^ (B | (~D))
                    g = (7 * j) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ rotateLeft((A &+ F &+ k[j] &+ M[g]), s[j])
                A = dTemp    
            }
            
            hh[0] = hh[0] &+ A
            hh[1] = hh[1] &+ B
            hh[2] = hh[2] &+ C
            hh[3] = hh[3] &+ D
        }

        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        
        hh.forEach {
            let itemLE = $0.littleEndian
            result += [UInt8(itemLE & 0xff), UInt8((itemLE >> 8) & 0xff), UInt8((itemLE >> 16) & 0xff), UInt8((itemLE >> 24) & 0xff)]
        }
        return result
    }
}

