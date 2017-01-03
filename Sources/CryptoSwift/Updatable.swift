//
//  Updatable.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

/// A type that supports incremental updates. For example Digest or Cipher may be updatable
/// and calculate result incerementally.
public protocol Updatable {
    /// Update given bytes in chunks.
    ///
    /// - parameter bytes: Bytes to process
    /// - parameter isLast: (Optional) Given chunk is the last one. No more updates after this call.
    /// - returns: Processed data or empty array.
    mutating func update<T: Collection>(withBytes bytes: T, isLast: Bool) throws -> Array<UInt8> where T.Iterator.Element == UInt8

    /// Update given bytes in chunks.
    ///
    /// - parameter bytes: Bytes to process
    /// - parameter isLast: (Optional) Given chunk is the last one. No more updates after this call.
    /// - parameter output: Resulting data
    /// - returns: Processed data or empty array.
    mutating func update<T: Collection>(withBytes bytes: T, isLast: Bool, output: (Array<UInt8>) -> Void) throws where T.Iterator.Element == UInt8

    /// Finish updates. This may apply padding.
    /// - parameter bytes: Bytes to process
    /// - returns: Processed data.
    mutating func finish<T: Collection>(withBytes bytes: T) throws -> Array<UInt8> where T.Iterator.Element == UInt8

    /// Finish updates. This may apply padding.
    /// - parameter bytes: Bytes to process
    /// - parameter output: Resulting data
    /// - returns: Processed data.
    mutating func finish<T: Collection>(withBytes bytes: T, output: (Array<UInt8>) -> Void) throws where T.Iterator.Element == UInt8
}

extension Updatable {

    mutating public func update<T: Collection>(withBytes bytes: T, isLast: Bool = false, output: (Array<UInt8>) -> Void) throws where T.Iterator.Element == UInt8 {
        let processed = try self.update(withBytes: bytes, isLast: isLast)
        if (!processed.isEmpty) {
            output(processed)
        }
    }

    mutating public func finish<T: Collection>(withBytes bytes: T) throws -> Array<UInt8> where T.Iterator.Element == UInt8 {
        return try self.update(withBytes: bytes, isLast: true)
    }

    mutating public func finish() throws -> Array<UInt8> {
        return try self.update(withBytes: [], isLast: true)
    }

    mutating public func finish<T: Collection>(withBytes bytes: T, output: (Array<UInt8>) -> Void) throws where T.Iterator.Element == UInt8 {
        let processed = try self.update(withBytes: bytes, isLast: true)
        if (!processed.isEmpty) {
            output(processed)
        }
    }

    mutating public func finish(output: (Array<UInt8>) -> Void) throws {
        try self.finish(withBytes: [], output: output)
    }
}
