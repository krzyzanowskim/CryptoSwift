//
//  Digest.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 17/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

internal protocol DigestType {
    func calculate(for bytes: Array<UInt8>) -> Array<UInt8>
}
