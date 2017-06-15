//
//  CSArrayType+Foundation.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

import Foundation

public extension CSArrayType where Iterator.Element == UInt8 {

    public func toBase64() -> String? {
        guard let bytesArray = self as? Array<UInt8> else {
            return nil
        }

        return Data(bytes: bytesArray).base64EncodedString()
    }

    public init(base64: String) {
        self.init()

        guard let decodedData = Data(base64Encoded: base64) else {
            return
        }

        self.append(contentsOf: decodedData.bytes)
    }
}
