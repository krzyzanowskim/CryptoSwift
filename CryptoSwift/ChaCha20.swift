//
//  ChaCha20.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 25/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public class ChaCha20 {
    let keySize = 32
    let nonceSize = 8
    let stateSize = 16
    let blockSize = 16 * 4
    
    public init() {
    }
    
    public func wordToByte(input:[UInt32] /* 64 */) -> [Byte]? /* 16 */ {
        if (input.count != stateSize) {
            return nil;
        }
        
        var x:[UInt32] = [UInt32]()
        for val in input[0...15] {
            x.append(val)
        }
        
        for (var i = 8; i > 0; i -= 2) {
            quarterround(&x[0], &x[4], &x[8], &x[12])
            quarterround(&x[1], &x[5], &x[9],  &x[13])
            quarterround(&x[2], &x[6], &x[10], &x[14])
            quarterround(&x[3], &x[7], &x[11], &x[15])
            quarterround(&x[0], &x[5], &x[10], &x[15])
            quarterround(&x[1], &x[6], &x[11], &x[12])
            quarterround(&x[2], &x[7], &x[8],  &x[13])
            quarterround(&x[3], &x[4], &x[9],  &x[14])
        }
        
        for (idx,val) in enumerate(input[0...15]) {
            x[idx] = plus(x[idx],val)
        }

        var output:[Byte] = [Byte](count: 64, repeatedValue: 0)
        for (i,xval) in enumerate(x[0...15]) {
            let bytes = x[i].bytes()
            let start = (i * 4)
            for o in start..<(start + 4) {
                output[o] = bytes[o - start]
            }
        }
        
        return output;
    }
    
    private func UInt32To8Little(p:UInt32, _ v:UInt32) -> UInt8 {
        var tmp1 = (v >> 0)  & 0xff | (v >> 8)  & 0xff
        var tmp2 = (v >> 16) & 0xff | (v >> 24) & 0xff
        return UInt8(tmp1 | tmp2)
    }
    
    // rotate left
    private func rotate(v:UInt32, _ c:UInt32) -> UInt32 {
        return ((v << c) & 0xFFFFFFFF) | (v >> (32 - c))
    }
    
    private func u32v(x:UInt32) -> UInt32 {
        return x & 0xFFFFFFFF
    }
    
    private func plusone(v:UInt32) -> UInt32 {
        return plus(v, 1)
    }
    
    private func plus(v:UInt32, _ w:UInt32) -> UInt32 {
        return v &+ w
    }

    private func quarterround(inout a:UInt32, inout _ b:UInt32, inout _ c:UInt32, inout _ d:UInt32) {
        a = plus(a,b);
        d = rotate((d ^ a), 16)
        
        c = plus(c,d);
        b = rotate((b ^ c), 12);
        
        a = plus(a,b);
        d = rotate((d ^ a), 8);

        c = plus(c,d);
        b = rotate((b ^ c), 7);
    }
}
