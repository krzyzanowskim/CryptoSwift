//
//  MAC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 03/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/// Message authentication code.
public protocol Authenticator {
    /// Calculate Message Authentication Code (MAC) for message.
    func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8>
}
