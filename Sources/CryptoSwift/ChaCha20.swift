//
//  ChaCha20.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 25/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

final public class ChaCha20: Salsa20 {
    
    public init?(key:[UInt8], iv:[UInt8]) {
        super.init(rounds: 20)
        if let c = contextSetup(iv: iv, key: key) {
            context = c
        } else {
            return nil
        }
    }
    
    override final func wordToByte(input:[UInt32] /* 64 */) -> [UInt8]? /* 16 */ {
        if (input.count != stateSize) {
            return nil;
        }
        
        var x = input

        for _ in 0..<rounds/2 {
            quarterround(&x[0], &x[4], &x[8], &x[12])
            quarterround(&x[1], &x[5], &x[9],  &x[13])
            quarterround(&x[2], &x[6], &x[10], &x[14])
            quarterround(&x[3], &x[7], &x[11], &x[15])
            quarterround(&x[0], &x[5], &x[10], &x[15])
            quarterround(&x[1], &x[6], &x[11], &x[12])
            quarterround(&x[2], &x[7], &x[8],  &x[13])
            quarterround(&x[3], &x[4], &x[9],  &x[14])
        }

        var output = [UInt8]()
        output.reserveCapacity(16)

        for i in 0..<16 {
            x[i] = x[i] &+ input[i]
            output.appendContentsOf(x[i].bytes().reverse())
        }

        return output;
    }
        
    override internal func contextSetup(iv  iv:[UInt8], key:[UInt8]) -> Context? {
        let ctx = Context()
        let kbits = key.count * 8
        
        if (kbits != 128 && kbits != 256) {
            return nil
        }
        
        // 4 - 8
        for i in 0..<4 {
            let start = i * 4
            ctx.input[i + 4] = wordNumber(key[start..<(start + 4)])
        }
        
        var addPos = 0;
        let constant: NSData;
        switch (kbits) {
        case 256:
            addPos += 16
            // sigma
            constant = SIGMA.dataUsingEncoding(NSUTF8StringEncoding)!
        default:
            // tau
            constant = TAU.dataUsingEncoding(NSUTF8StringEncoding)!
        break;
        }
        ctx.input[0] = littleEndian(constant, range: 0..<4)
        ctx.input[1] = littleEndian(constant, range: 4..<8)
        ctx.input[2] = littleEndian(constant, range: 8..<12)
        ctx.input[3] = littleEndian(constant, range: 12..<16)
        
        // 8 - 11
        for i in 0..<4 {
            let start = addPos + (i*4)
            
            let bytes = key[start..<(start + 4)]
            ctx.input[i + 8] = wordNumber(bytes)
        }

        // iv
        ctx.input[12] = 0
        ctx.input[13] = 0
        ctx.input[14] = wordNumber(iv[0..<4])
        ctx.input[15] = wordNumber(iv[4..<8])
        
        return ctx
    }
    
    override internal final func encryptBytes(message:[UInt8]) throws -> [UInt8] {
        
        guard let ctx = context else {
            throw Error.MissingContext
        }
        
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
                if (bytes <= ChaCha20.blockSize) {
                    for i in 0..<bytes {
                        c[i + cPos] = message[i + mPos] ^ output[i]
                    }
                    return c
                }
                for i in 0..<ChaCha20.blockSize {
                    c[i + cPos] = message[i + mPos] ^ output[i]
                }
                bytes -= ChaCha20.blockSize
                cPos += ChaCha20.blockSize
                mPos += ChaCha20.blockSize
            }
        }
    }
    
    private final func quarterround(inout a:UInt32, inout _ b:UInt32, inout _ c:UInt32, inout _ d:UInt32) {
        a = a &+ b
        d = rotateLeft((d ^ a), 16) //FIXME: WAT? n:
        
        c = c &+ d
        b = rotateLeft((b ^ c), 12);
        
        a = a &+ b
        d = rotateLeft((d ^ a), 8);

        c = c &+ d
        b = rotateLeft((b ^ c), 7);
    }
    
    override public func reset() {
        //reset position
        context?.input[12] = 0
        context?.input[13] = 0
    }
}



