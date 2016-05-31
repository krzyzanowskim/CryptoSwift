//
//  Cryptor.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public protocol Cryptor {
    /// Decrypt given bytes in chunks.
    ///
    /// - parameter bytes: Ciphertext data
    /// - parameter isLast: Given chunk is the last one. No more updates after this call.
    /// - returns: Plaintext data
    mutating func update(withBytes bytes:[UInt8], isLast: Bool) throws -> [UInt8]
    mutating func finish(withBytes bytes:[UInt8]) throws  -> [UInt8]
}

extension Cryptor {
    mutating public func finish(withBytes bytes:[UInt8] = []) throws  -> [UInt8] {
        return try self.update(withBytes: bytes, isLast: true)
    }
}