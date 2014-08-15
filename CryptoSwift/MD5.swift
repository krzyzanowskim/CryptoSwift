//
//  MD5.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class MD5 {

    /** specifies the per-round shift amounts */
    let s: [UInt32] = [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
                       5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
                       4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
                       6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21]
    
    /** binary integer part of the sines of integers (Radians) */
    let K: [UInt32] = [0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,
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
    
    var a0: UInt32 = 0x67452301
    var b0: UInt32 = 0xefcdab89
    var c0: UInt32 = 0x98badcfe
    var d0: UInt32 = 0x10325476
    
    var message: NSData
    
    init(_ message: NSData) {
        self.message = message;
    }
    
    func calculate() -> NSData? {
        var tmpMessage: NSMutableData = NSMutableData(data: message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (Byte with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.length % 64 != 56 {
            tmpMessage.appendBytes([0x00])
        }
        
        // Step 2. Append Length a 64-bit representation of lengthInBits
        let lengthInBits:Int = (message.length * 8).bigEndian
        tmpMessage.appendBytes(lengthInBits.bytes(64 / 8));
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8
        var leftMessageBytes = tmpMessage.length
        for var i = 0; i < tmpMessage.length; i = i + chunkSizeBytes, leftMessageBytes -= chunkSizeBytes {
            var chunk = tmpMessage.subdataWithRange(NSRange(location: i, length: min(chunkSizeBytes,leftMessageBytes)))
            
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            var M:[UInt32] = [UInt32]()
            for x in 0...15 {
                var word:UInt32 = 0;
                var range:NSRange = NSRange(location:x * sizeof(UInt32), length: sizeof(UInt32));
                chunk.getBytes(&word, range: range);
                M.append(word)
            }
            
            // Initialize hash value for this chunk:
            var A:UInt32 = a0
            var B:UInt32 = b0
            var C:UInt32 = c0
            var D:UInt32 = d0
            
            var dTemp:UInt32
            
            // Main loop
            for i in 0...63 {
                var g:Int = 0
                var F:UInt32 = 0
                
                switch (i) {
                case 0...15:
                    F = (B & C) | ((~B) & D)
                    //F = D ^ (B & (C ^ D))
                    g = i
                    break
                case 16...31:
                    F = (D & B) | (~D & C)
                    g = (5 * i + 1) % 16
                    break
                case 32...47:
                    F = B ^ C ^ D
                    g = (3 * i + 5) % 16
                    break
                case 48...63:
                    F = C ^ (B | (~D))
                    g = (7 * i) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ rotateLeft((A &+ F &+ K[i] &+ M[g]), s[i])
                A = dTemp
            }
            a0 = a0 &+ A
            b0 = b0 &+ B
            c0 = c0 &+ C
            d0 = d0 &+ D
        }

        var buf: NSMutableData = NSMutableData();
        buf.appendBytes(&a0, length: sizeof(UInt32))
        buf.appendBytes(&b0, length: sizeof(UInt32))
        buf.appendBytes(&c0, length: sizeof(UInt32))
        buf.appendBytes(&d0, length: sizeof(UInt32))
        
        return buf.copy() as? NSData;
    }
    
    class func calculate(message: NSData) -> NSData?
    {
        return MD5(message).calculate();
    }
    
    private func rotateLeft(x:UInt32, _ n:UInt32) -> UInt32 {
        return (x << n) | (x >> (32 - n))
    }
}

/** String extension */
extension String {
    
    /** Calculate MD5 hash */
    public func md5() -> String? {
        var stringData:NSData? = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        if let data = stringData {
            let md5Data = MD5.calculate(data)
            return md5Data?.toHexString()
        }
        return nil
    }
}

