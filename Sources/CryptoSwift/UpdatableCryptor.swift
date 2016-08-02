//
//  UpdatableCryptor.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public protocol UpdatableCryptor {
    /// Encrypt/Decrypt given bytes in chunks.
    ///
    /// - parameter bytes: Bytes to process
    /// - parameter isLast: (Optional) Given chunk is the last one. No more updates after this call.
    /// - returns: Processed data or empty array.
    mutating func update<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T, isLast: Bool) throws -> Array<UInt8>

    /// Encrypt/Decrypt given bytes in chunks.
    ///
    /// - parameter bytes: Bytes to process
    /// - parameter isLast: (Optional) Given chunk is the last one. No more updates after this call.
    /// - parameter output: Resulting data
    /// - returns: Processed data or empty array.
    mutating func update<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T, isLast: Bool, output: (Array<UInt8>) -> Void) throws

    /// Finish encryption/decryption. This may apply padding.
    /// - parameter bytes: Bytes to process
    /// - returns: Processed data.
    mutating func finish<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T) throws -> Array<UInt8>

    /// Finish encryption/decryption. This may apply padding.
    /// - parameter bytes: Bytes to process
    /// - parameter output: Resulting data
    /// - returns: Processed data.
    mutating func finish<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T, output: (Array<UInt8>) -> Void) throws
}

extension UpdatableCryptor {
    mutating public func update<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T, isLast: Bool = false, output: (Array<UInt8>) -> Void) throws {
        let processed = try self.update(withBytes: bytes, isLast: isLast)
        if (!processed.isEmpty) {
            output(processed)
        }
    }

    mutating public func finish<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T) throws -> Array<UInt8> {
        return try self.update(withBytes: bytes, isLast: true)
    }
    
    mutating public func finish() throws  -> Array<UInt8> {
        return try self.update(withBytes: [], isLast: true)
    }

    mutating public func finish<T: SequenceType where T.Generator.Element == UInt8>(withBytes bytes:T, output: (Array<UInt8>) -> Void) throws {
        let processed = try self.update(withBytes: bytes, isLast: true)
        if (!processed.isEmpty) {
            output(processed)
        }
    }
    
    mutating public func finish(output: (Array<UInt8>) -> Void) throws {
        try self.finish(withBytes: [], output: output)
    }
}