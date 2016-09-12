//
//  RandomAccessCryptor.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 29/07/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

/// Random access cryptor
public protocol RandomAccessCryptor: Updatable {
    /// Seek to position in file, if block mode allows random access.
    ///
    /// - parameter to: new value of counter
    ///
    /// - returns: true if seek succeed
    @discardableResult mutating func seek(to: Int) -> Bool
}
