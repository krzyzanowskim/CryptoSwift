//
//  Salsa.swift
//  scrypt-cryptoswift
//
//  Created by Alexander Vlasov on 08.08.2018.
//  Copyright © 2018 Alexander Vlasov. All rights reserved.
//

import Foundation

fileprivate extension Array where Element == UInt8 {
    func cast<T>() -> Array<T> {
        let tSize = MemoryLayout<T>.size
        let (numElements, remainder) = self.count.quotientAndRemainder(dividingBy: tSize)
        precondition(remainder == 0)
        var result = Array<T>()
        result.reserveCapacity(numElements)
        self.withUnsafeBytes { (bytes) -> Void in
            for i in 0 ..< numElements {
                let t = bytes.load(fromByteOffset: i*tSize, as: T.self)
                result.append(t)
            }
        }
        return result
    }
}

fileprivate extension Array where Element == UInt8 {
    func castToUInt32LE() -> Array<UInt32> {
        let tSize = 4
        let (numElements, remainder) = self.count.quotientAndRemainder(dividingBy: tSize)
        precondition(remainder == 0)
        var result = Array<UInt32>(repeating: 0, count: numElements)
        self.withUnsafeBytes { (bytes) -> Void in
            for i in 0 ..< numElements {
                result[i] = bytes.load(fromByteOffset: i*tSize, as: UInt32.self).littleEndian
            }
        }
        return result
    }
}

fileprivate extension Array where Element == UInt32 {
    func castToBytes() -> Array<UInt8> {
        let numElements = self.count * 4
        var result = Array<UInt8>(repeating: 0, count: numElements)
        self.withUnsafeBytes { (bytes) -> Void in
            for i in 0 ..< numElements {
                result[i] = bytes.load(fromByteOffset: i, as: UInt8.self)
            }
        }
        return result
    }
}

public struct Salsa {
    private static func R(_ a: UInt32, _ b: UInt32) -> UInt32 {
        return (a << b) | (a >> (32 - b))
    }
    
    public static func salsa20(_ B: inout Array<UInt8>, rounds: Int) {
        var x = B.castToUInt32LE()
        salsa20(&x, rounds: rounds)
        B = x.castToBytes()
    }
    
    static func quarterround(_ B: inout Array<UInt32>) {
        B[1] ^= R(B[0] &+ B[3], 7);
        B[2] ^= R(B[1] &+ B[0], 9);
        B[3] ^= R(B[2] &+ B[1], 13);
        B[0] ^= R(B[3] &+ B[2], 18);
    }
    
    static func doubleround(_ x: inout Array<UInt32>) {
        // column rounds
        x[4] ^= R(x[0] &+ x[12], 7);
        x[8] ^= R(x[4] &+ x[0], 9);
        x[12] ^= R(x[8] &+ x[4], 13);
        x[0] ^= R(x[12] &+ x[8], 18);
        
        x[9] ^= R(x[5] &+ x[1], 7);
        x[13] ^= R(x[9] &+ x[5], 9);
        x[1] ^= R(x[13] &+ x[9], 13);
        x[5] ^= R(x[1] &+ x[13], 18);
        
        x[14] ^= R(x[10] &+ x[6], 7);
        x[2] ^= R(x[14] &+ x[10], 9);
        x[6] ^= R(x[2] &+ x[14], 13);
        x[10] ^= R(x[6] &+ x[2], 18);
        
        x[3] ^= R(x[15] &+ x[11], 7);
        x[7] ^= R(x[3] &+ x[15], 9);
        x[11] ^= R(x[7] &+ x[3], 13);
        x[15] ^= R(x[11] &+ x[7], 18);
        
        // row rounds
        x[1] ^= R(x[0] &+ x[3], 7);
        x[2] ^= R(x[1] &+ x[0], 9);
        x[3] ^= R(x[2] &+ x[1], 13);
        x[0] ^= R(x[3] &+ x[2], 18);
        
        x[6] ^= R(x[5] &+ x[4], 7);
        x[7] ^= R(x[6] &+ x[5], 9);
        x[4] ^= R(x[7] &+ x[6], 13);
        x[5] ^= R(x[4] &+ x[7], 18);
        
        x[11] ^= R(x[10] &+ x[9], 7);
        x[8] ^= R(x[11] &+ x[10], 9);
        x[9] ^= R(x[8] &+ x[11], 13);
        x[10] ^= R(x[9] &+ x[8], 18);
        
        x[12] ^= R(x[15] &+ x[14], 7);
        x[13] ^= R(x[12] &+ x[15], 9);
        x[14] ^= R(x[13] &+ x[12], 13);
        x[15] ^= R(x[14] &+ x[13], 18);
    }
    
    public static func salsa20(_ B: inout Array<UInt32>, rounds: Int) {
        var x = B
        for _ in stride(from: 0, to: rounds, by: 2) {
            doubleround(&x)
        }
        for i in 0 ..< 16 {
            B[i] = B[i] &+ x[i]
        }
    }
}
