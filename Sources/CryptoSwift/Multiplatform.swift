//
//  Multiplatform.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 03/12/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//
//  URandom originally from https://github.com/stormpath/Turnstile/blob/master/Sources/TurnstileCrypto/URandom.swift
//  

import Foundation

#if os(Linux) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

public class URandom {
    
    public static var shared = URandom()
    
    private let file = fopen("/dev/urandom", "r")
    
    /// Initialize URandom
    public init() {}
    
    deinit {
        fclose(file)
    }
    
    private func read(numBytes: Int) -> [Int8] {
        // Initialize an empty array with numBytes+1 for null terminated string
        var bytes = [Int8](repeating: 0, count: numBytes + 1)
        fgets(&bytes, numBytes + 1, file)
        
        bytes.removeLast()
        
        return bytes
    }
    
    /// Get a byte array of random UInt8s
    public func random(numBytes: Int) -> [UInt8] {
        return unsafeBitCast(read(numBytes: numBytes), to: [UInt8].self)
    }
    
    /// Get a random int8
    public var int8: Int8 {
        return Int8(read(numBytes: 1)[0])
    }
    
    /// Get a random uint8
    public var uint8: UInt8 {
        return UInt8(bitPattern: int8)
    }
    
    /// Get a random int16
    public var int16: Int16 {
        let bytes = read(numBytes: 2)
        return UnsafeMutableRawPointer(mutating: bytes).assumingMemoryBound(to: Int16.self).pointee
    }
    
    /// Get a random uint16
    public var uint16: UInt16 {
        return UInt16(bitPattern: int16)
    }
    
    /// Get a random int32
    public var int32: Int32 {
        let bytes = read(numBytes: 4)
        return UnsafeMutableRawPointer(mutating: bytes).assumingMemoryBound(to: Int32.self).pointee
    }
    
    /// Get a random uint32
    public var uint32: UInt32 {
        return UInt32(bitPattern: int32)
    }
    
    /// Get a random int64
    public var int64: Int64 {
        let bytes = read(numBytes: 8)
        return UnsafeMutableRawPointer(mutating: bytes).assumingMemoryBound(to: Int64.self).pointee
    }
    
    /// Get a random uint64
    public var uint64: UInt64 {
        return UInt64(bitPattern: int64)
    }
    
    /// Get a random int
    public var int: Int {
        let bytes = read(numBytes: MemoryLayout<Int>.size)
        return UnsafeMutableRawPointer(mutating: bytes).assumingMemoryBound(to: Int.self).pointee
    }
    
    /// Get a random uint
    public var uint: UInt {
        return UInt(bitPattern: int)
    }
}


