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
    
    /** A */
    var a0: UInt32 = 0x67452301
    /** B */
    var a1: UInt32 = 0xefcdab89
    /** C */
    var a2: UInt32 = 0x98badcfe
    /** D */
    var a3: UInt32 = 0x10325476
    
    var message: NSData
    
    init(_ message: NSData) {
        self.message = message;
    }
    
    class func calculate(message: NSData) -> NSData?
    {
        return MD5(message).calculate();
    }
    
    func paddedBuffer() -> NSData {
        var tmpMessage: NSMutableData = NSMutableData(data: message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit to message
        
        // "0" bits are appended
        while tmpMessage.length % 64 != 56 {
            tmpMessage.appendBytes([0x00])
        }
        
        // Step 2. Append Length
        let lengthInBits: Int = (message.length * 8)
        // A 64-bit representation of b
//        for i in stride(from: 0, through: 56, by: 8) {
//            let byte = (Byte)(lengthInBits >> i)
//            tmpMessage.appendBytes([byte])
//        }
        
//        let temp: Int = (448 - (message.length * 8) % 512)
//        var pad: Int = (temp + 512) % 512 // no of bits to be pad
//        
//        if (pad == 0) {
//            pad = 512
//        }
//        
//        // buffer size in multiple of bytes
//        let sizeMsgBuff = message.length + (pad / 8) + 8
//        // 64 bit size pad
//        let sizeMsg = message.length * 8
        
        var buf: NSMutableData = NSMutableData();
        return buf.copy() as NSData;
    }
    
    //TODO
    func calculate() -> NSData?
    {
        let paddedData = self.paddedBuffer();
        return paddedBuffer();
    }
    
}