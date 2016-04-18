//
//  Testable.swift
//  CryptoSwift
//
//  Created by Alsey Coleman Miller on 4/18/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

/// Makes public internal functions / methods for testing purposes since `@testable` is not availible on Linux.

public struct Testable {
    
    @inline(__always)
    public static func toUInt32Array(_ slice: ArraySlice<UInt8>) -> Array<UInt32>  {
        
        return CryptoSwift.toUInt32Array(slice)
    }
}
