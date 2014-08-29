//
//  ChaCha20.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 25/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public class ChaCha20 {
    let stateSize = 16
    let blockSize = 16 * 4
    
    public class Context {
        var input:[UInt32] = [UInt32](count: 16, repeatedValue: 0)
    }
    
    public init() {
    }
    
    private func wordToByte(input:[UInt32] /* 64 */) -> [Byte]? /* 16 */ {
        if (input.count != stateSize) {
            return nil;
        }
        
        var x = input
        
        var i = 20
        while (i  > 0) {
            quarterround(&x[0], &x[4], &x[8], &x[12])
            quarterround(&x[1], &x[5], &x[9],  &x[13])
            quarterround(&x[2], &x[6], &x[10], &x[14])
            quarterround(&x[3], &x[7], &x[11], &x[15])
            quarterround(&x[0], &x[5], &x[10], &x[15])
            quarterround(&x[1], &x[6], &x[11], &x[12])
            quarterround(&x[2], &x[7], &x[8],  &x[13])
            quarterround(&x[3], &x[4], &x[9],  &x[14])
            i -= 2
        }

        var output = [Byte]()

        for i in 0..<16 {
            x[i] = x[i] &+ input[i]
            output += x[i].bytes().reverse()
        }

        return output;
    }
    
    public func keySetup(# iv:NSData, key:NSData, kbits:UInt32 = 256) -> Context {
        return keySetup(iv: iv.arrayOfBytes(), key: key.arrayOfBytes(), kbits: kbits)
    }
    
    private func keySetup(# iv:[Byte], key:[Byte], kbits:UInt32 = 256) -> Context {
        var context = Context()
        
        // 4 - 8
        for (var i = 0; i < 4; i++) {
            let start = i * 4
            context.input[i + 4] = UInt32.withBytes(key[start..<(start + 4)]).bigEndian
        }
        
        var addPos = 0;
        switch (kbits) {
        case 256:
            addPos += 16
            // sigma
            context.input[0] = 0x61707865 //apxe
            context.input[1] = 0x3320646e //3 dn
            context.input[2] = 0x79622d32 //yb-2
            context.input[3] = 0x6b206574 //k et
        default:
            // tau
            context.input[0] = 0x61707865 //apxe
            context.input[1] = 0x3620646e //6 dn
            context.input[2] = 0x79622d31 //yb-1
            context.input[3] = 0x6b206574 //k et
        break;
        }
        
        // 8 - 11
        for (var i = 0; i < 4; i++) {
            let start = addPos + (i*4)
            context.input[i + 8] = UInt32.withBytes(key[start..<(start + 4)]).bigEndian
        }

        // iv
        context.input[12] = 0
        context.input[13] = 0
        context.input[14] = UInt32.withBytes(iv[0..<4]).bigEndian
        context.input[15] = UInt32.withBytes(iv[4..<8]).bigEndian
        
        return context
    }
    
    public func encrypt(context:Context, message:NSData) -> NSData {
        let output = encryptBytes(context, message: message.arrayOfBytes())
        return NSData(bytes: output, length: output.count)
    }
    
    private func encryptBytes(context:Context, message:[Byte]) -> [Byte] {
        var cPos:Int = 0
        var mPos:Int = 0
        var bytes = message.count
        
        var c:[Byte] = [Byte](count: message.count, repeatedValue: 0)
        
        while (true) {
            if let output = wordToByte(context.input) {
                context.input[12] = context.input[12] &+ 1
                if (context.input[12] == 0) {
                    context.input[13] = context.input[13] &+ 1
                    /* stopping at 2^70 bytes per nonce is user's responsibility */
                }
                if (bytes <= blockSize) {
                    for (var i = 0; i < bytes; i++) {
                        c[i + cPos] = message[i + mPos] ^ output[i]
                    }
                    return c
                }
                for (var i = 0; i < blockSize; i++) {
                    c[i + cPos] = message[i + mPos] ^ output[i]
                }
                bytes -= blockSize
                cPos += blockSize
                mPos += blockSize
            }
        }
    }
    
    private func quarterround(inout a:UInt32, inout _ b:UInt32, inout _ c:UInt32, inout _ d:UInt32) {
        a = a &+ b
        d = rotateLeft((d ^ a), 16)
        
        c = c &+ d
        b = rotateLeft((b ^ c), 12);
        
        a = a &+ b
        d = rotateLeft((d ^ a), 8);

        c = c &+ d
        b = rotateLeft((b ^ c), 7);
    }
}
