//
//  PKCS7.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 28/02/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//
//  PKCS is a group of public-key cryptography standards devised
//  and published by RSA Security Inc, starting in the early 1990s.
//

public struct PKCS7: Padding {

    public enum Error: Swift.Error {
        case invalidPaddingValue
    }
    
    public init() {
        
    }
    
    public func add(to bytes: Array<UInt8> , blockSize:Int) -> Array<UInt8> {
        let padding = UInt8(blockSize - (bytes.count % blockSize))
        var withPadding = bytes
        if (padding == 0) {
            // If the original data is a multiple of N bytes, then an extra block of bytes with value N is added.
            for _ in 0..<blockSize {
                withPadding += [UInt8(blockSize)]
            }
        } else {
            // The value of each added byte is the number of bytes that are added
            for _ in 0..<padding {
                withPadding += [UInt8(padding)]
            }
        }
        return withPadding
    }

    public func remove(from bytes: Array<UInt8>, blockSize:Int?) -> Array<UInt8> {
        guard !bytes.isEmpty, let lastByte = bytes.last else {
            return bytes
        }

        assert(!bytes.isEmpty, "Need bytes to remove padding")

        let padding = Int(lastByte) // last byte
        let finalLength = bytes.count - padding

        if finalLength < 0 {
            return bytes
        }

        if padding >= 1 {
            return Array(bytes[0..<finalLength])
        }
        return bytes
    }
}
