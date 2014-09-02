//
//  UInt64Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** array of bytes */
extension UInt64 {
    public func bytes(_ totalBytes: Int = sizeof(UInt64)) -> [Byte] {
        return bytesArray(self, totalBytes)
    }
}