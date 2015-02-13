//
//  ChaCha20.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 25/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public class ChaCha20 {
    
    private let blockSizeBytes = 512 / 8
    private let stateSize = 16
    private var context:Context?
    
    private class Context {
        var input:[UInt32] = [UInt32](count: 16, repeatedValue: 0)
        
        deinit {
            for (var i = 0; i < input.count; i++) {
                input[i] = 0x00;
            }
        }
    }
    
    init?(key:NSData, iv:NSData) {
        if let c = contextSetup(iv: iv, key: key) {
            context = c
        } else {
            return nil
        }
    }
    
    func encrypt(message:NSData) -> NSData? {
        if (context == nil) {
            return nil
        }
        
        if let output = encryptBytes(message.bytes()) {
            return NSData.withBytes(output)
        }
        
        return nil
    }
    
    func decrypt(message:NSData) -> NSData? {
        return encrypt(message)
    }
    
    private func wordToByte(input:[UInt32] /* 64 */) -> [UInt8]? /* 16 */ {
        if (input.count != stateSize) {
            return nil;
        }
        
        var x = input
        
        var i = 10
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

        var output = [UInt8]()

        for i in 0..<16 {
            x[i] = x[i] &+ input[i]
            output += x[i].bytes().reverse()
        }

        return output;
    }
    
    private func contextSetup(# iv:NSData, key:NSData) -> Context? {
        return contextSetup(iv: iv.bytes(), key: key.bytes())
    }
    
    private func contextSetup(# iv:[UInt8], key:[UInt8]) -> Context? {
        var ctx = Context()
        let kbits = key.count * 8
        
        if (kbits != 128 && kbits != 256) {
            return nil
        }
        
        // 4 - 8
        for (var i = 0; i < 4; i++) {
            let start = i * 4
            ctx.input[i + 4] = UInt32.withBytes(key[start..<(start + 4)]).bigEndian
        }
        
        var addPos = 0;
        switch (kbits) {
        case 256:
            addPos += 16
            // sigma
            ctx.input[0] = 0x61707865 //apxe
            ctx.input[1] = 0x3320646e //3 dn
            ctx.input[2] = 0x79622d32 //yb-2
            ctx.input[3] = 0x6b206574 //k et
        default:
            // tau
            ctx.input[0] = 0x61707865 //apxe
            ctx.input[1] = 0x3620646e //6 dn
            ctx.input[2] = 0x79622d31 //yb-1
            ctx.input[3] = 0x6b206574 //k et
        break;
        }
        
        // 8 - 11
        for (var i = 0; i < 4; i++) {
            let start = addPos + (i*4)
            ctx.input[i + 8] = UInt32.withBytes(key[start..<(start + 4)]).bigEndian
        }

        // iv
        ctx.input[12] = 0
        ctx.input[13] = 0
        ctx.input[14] = UInt32.withBytes(iv[0..<4]).bigEndian
        ctx.input[15] = UInt32.withBytes(iv[4..<8]).bigEndian
        
        return ctx
    }
    
    private func encryptBytes(message:[UInt8]) -> [UInt8]? {
        
        if let ctx = context {
            var c:[UInt8] = [UInt8](count: message.count, repeatedValue: 0)
            
            var cPos:Int = 0
            var mPos:Int = 0
            var bytes = message.count
            
            while (true) {
                if let output = wordToByte(ctx.input) {
                    ctx.input[12] = ctx.input[12] &+ 1
                    if (ctx.input[12] == 0) {
                        ctx.input[13] = ctx.input[13] &+ 1
                        /* stopping at 2^70 bytes per nonce is user's responsibility */
                    }
                    if (bytes <= blockSizeBytes) {
                        for (var i = 0; i < bytes; i++) {
                            c[i + cPos] = message[i + mPos] ^ output[i]
                        }
                        return c
                    }
                    for (var i = 0; i < blockSizeBytes; i++) {
                        c[i + cPos] = message[i + mPos] ^ output[i]
                    }
                    bytes -= blockSizeBytes
                    cPos += blockSizeBytes
                    mPos += blockSizeBytes
                }
            }
        }
        return nil;
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
