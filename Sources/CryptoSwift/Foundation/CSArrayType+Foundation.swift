//
//  CSArrayType+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public extension CSArrayType where Iterator.Element == UInt8 {
    public func toBase64() -> String? {
        guard let bytesArray = self as? Array<UInt8> else {
            return nil
        }

        return NSData(bytes: bytesArray).base64EncodedString([])
    }

    public init(base64: String) {
        self.init()

        guard let decodedData = NSData(base64Encoded: base64, options: []) else {
            return
        }

        self.append(contentsOf: decodedData.arrayOfBytes())
    }
}