//
//  MAC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 03/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

public protocol Authenticator {
    /// Generates an authenticator for message using a one-time key and returns the 16-byte result
    func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8>
}
