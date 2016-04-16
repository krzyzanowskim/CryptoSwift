//
//  Salsa20.swift
//  CryptoSwift
//
//  Created by Dennis Michaelis on 27.03.16.
//  Copyright © 2016 Dennis Michaelis. All rights reserved.
//

final public class Salsa20 {
    
    public enum Error: ErrorType {
        case MissingContext
        case LimitOfNonceExceeded
    }
    
    static let blockSize = 64
    private let stateSize = 16
    private var rounds: UInt8
    private var context:Context?
    private var keyStream: [UInt8]?
    private var index: Int = 0
    
    
    final private class Context {
        var input:[UInt32] = [UInt32](count: 16, repeatedValue: 0)
        
        deinit {
            for i in 0..<input.count {
                input[i] = 0x00;
            }
        }
    }
    
    public init?(key:[UInt8], iv:[UInt8], rounds: UInt8) {
        self.rounds = rounds
        if let c = contextSetup(iv: iv, key: key) {
            context = c
            keyStream = wordToByte(c.input)
        } else {
            return nil
        }
    }
    
    public convenience init?(key:[UInt8], iv:[UInt8]) {
        self.init(key: key, iv: iv, rounds: 20)
    }
    
    public func encrypt(bytes:[UInt8]) throws -> [UInt8] {
        guard context != nil else {
            throw Error.MissingContext
        }
        
        return try encryptBytes(bytes)
    }
    
    public func decrypt(bytes:[UInt8]) throws -> [UInt8] {
        return try encrypt(bytes)
    }
    
    private final func wordToByte(input:[UInt32] /* 64 */) -> [UInt8]? /* 16 */ {
        if (input.count != stateSize) {
            return nil
        }
        
        if (self.rounds % 2 != 0) {
            return nil
        }
        
        var x = input
        
        for _ in 0..<rounds/2 {
            x[ 4] ^= quarterround(x[0], x[12], 7)
            x[ 8] ^= quarterround(x[4], x[0], 9)
            x[12] ^= quarterround(x[8], x[4], 13)
            x[ 0] ^= quarterround(x[12], x[8], 18)
            x[ 9] ^= quarterround(x[5], x[1], 7)
            x[13] ^= quarterround(x[9], x[5], 9)
            x[ 1] ^= quarterround(x[13], x[9], 13)
            x[ 5] ^= quarterround(x[1], x[13], 18)
            x[14] ^= quarterround(x[10], x[6], 7)
            x[ 2] ^= quarterround(x[14], x[10], 9)
            x[ 6] ^= quarterround(x[2], x[14], 13)
            x[10] ^= quarterround(x[6], x[2], 18)
            x[ 3] ^= quarterround(x[15], x[11], 7)
            x[ 7] ^= quarterround(x[3], x[15], 9)
            x[11] ^= quarterround(x[7], x[3], 13)
            x[15] ^= quarterround(x[11], x[7], 18)

            x[ 1] ^= quarterround(x[0], x[3], 7)
            x[ 2] ^= quarterround(x[1], x[0], 9)
            x[ 3] ^= quarterround(x[2], x[1], 13)
            x[ 0] ^= quarterround(x[3], x[2], 18)
            x[ 6] ^= quarterround(x[5], x[4], 7)
            x[ 7] ^= quarterround(x[6], x[5], 9)
            x[ 4] ^= quarterround(x[7], x[6], 13)
            x[ 5] ^= quarterround(x[4], x[7], 18)
            x[11] ^= quarterround(x[10], x[9], 7)
            x[ 8] ^= quarterround(x[11], x[10], 9)
            x[ 9] ^= quarterround(x[8], x[11], 13)
            x[10] ^= quarterround(x[9], x[8], 18)
            x[12] ^= quarterround(x[15], x[14], 7)
            x[13] ^= quarterround(x[12], x[15], 9)
            x[14] ^= quarterround(x[13], x[12], 13)
            x[15] ^= quarterround(x[14], x[13], 18)
        }
        
        var output = [UInt8]()
        output.reserveCapacity(16)
        
        for i in 0..<16 {
            x[i] = x[i] &+ input[i]
            output.appendContentsOf(x[i].bytes().reverse())
        }
        
        return output
    }
    
    private func contextSetup(iv  iv:[UInt8], key:[UInt8]) -> Context? {
        let ctx = Context()
        let kbits = key.count * 8
        
        if (kbits != 128 && kbits != 256) {
            return nil
        }
        
        // 1 - 4
        for i in 0..<4 {
            let start = i * 4
            ctx.input[i + 1] = wordNumber(key[start..<(start + 4)])
        }
        
        var addPos = 0;
        switch (kbits) {
        case 256:
            addPos += 16
            // sigma
            ctx.input[0] = 0x61707865 //apxe
            ctx.input[5] = 0x3320646e //3 dn
            ctx.input[10] = 0x79622d32 //yb-2
            ctx.input[15] = 0x6b206574 //k et
        default:
            // tau
            ctx.input[0] = 0x61707865 //apxe
            ctx.input[5] = 0x3120646e //1 dn
            ctx.input[10] = 0x79622d36 //yb-6
            ctx.input[15] = 0x6b206574 //k et
            break;
        }
        
        // 11 - 14
        for i in 0..<4 {
            let start = addPos + (i*4)
            
            let bytes = key[start..<(start + 4)]
            ctx.input[i + 11] = wordNumber(bytes)
        }
        
        // iv
        ctx.input[6] = wordNumber(iv[0..<4])
        ctx.input[7] = wordNumber(iv[4..<8])
        ctx.input[8] = 0
        ctx.input[9] = 0
        
        
        return ctx
    }
    
    private final func encryptBytes(message:[UInt8]) throws -> [UInt8] {
        
        guard let ctx = context else {
            throw Error.MissingContext
        }
        
        guard var keyStream = keyStream else {
            throw Error.MissingContext
        }
        
        var c:[UInt8] = [UInt8](count: message.count, repeatedValue: 0)
        
        let bytes = message.count
        
        while (true) {
            for i in 0..<bytes {
                c[i] = message[i] ^ keyStream[index]
                //reset index every 64 byte, regenerate keyStream
                index = (index + 1) & 0x3F
                if index == 0 {
                    ctx.input[8] = ctx.input[8] &+ 1
                    if (ctx.input[8] == 0) {
                        ctx.input[9] = ctx.input[9] &+ 1
                        /* stopping at 2^70 bytes per nonce is user's responsibility */
                        if (ctx.input[9] == 0) {
                            throw Error.LimitOfNonceExceeded
                        }
                    }
                    keyStream = wordToByte(ctx.input)!
                    self.keyStream = keyStream
                }
            }
            
            return c
        }
    }
    
    private final func quarterround(b:UInt32, _ c:UInt32, _ d:UInt32) -> UInt32 {
        return rotateLeft(b &+ c, d)
    }
    
    /**
     Reset keystream to start again
     */
    public func reset() {
        //reset index counter
        index = 0
        
        //reset position
        context?.input[8] = 0
        context?.input[9] = 0
        
        //reset stream key
        self.keyStream = wordToByte((context?.input)!)!
    }
}

// MARK: - Cipher

extension Salsa20: Cipher {
    public func cipherEncrypt(bytes:[UInt8]) throws -> [UInt8] {
        return try self.encrypt(bytes)
    }
    
    public func cipherDecrypt(bytes: [UInt8]) throws -> [UInt8] {
        return try self.decrypt(bytes)
    }
}

// MARK: Helpers

/// Change array to number. It's here because arrayOfBytes is too slow
private func wordNumber(bytes:ArraySlice<UInt8>) -> UInt32 {
    var value:UInt32 = 0
    for i:UInt32 in 0..<4 {
        let j = bytes.startIndex + Int(i)
        value = value | UInt32(bytes[j]) << (8 * i)
    }
    
    return value
}

