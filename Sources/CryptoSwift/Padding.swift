//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

public protocol PaddingProtocol {
    func add(to: Array<UInt8>, blockSize: Int) -> Array<UInt8>
    func remove(from: Array<UInt8>, blockSize: Int?) -> Array<UInt8>
}

public enum Padding: PaddingProtocol {
    case noPadding, zeroPadding, pkcs7, pkcs5

    public func add(to: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
        switch self {
        case .noPadding:
            return to // NoPadding().add(to: to, blockSize: blockSize)
        case .zeroPadding:
            return ZeroPadding().add(to: to, blockSize: blockSize)
        case .pkcs7:
            return PKCS7.Padding().add(to: to, blockSize: blockSize)
        case .pkcs5:
            return PKCS5.Padding().add(to: to, blockSize: blockSize)
        }
    }

    public func remove(from: Array<UInt8>, blockSize: Int?) -> Array<UInt8> {
        switch self {
        case .noPadding:
            return from //NoPadding().remove(from: from, blockSize: blockSize)
        case .zeroPadding:
            return ZeroPadding().remove(from: from, blockSize: blockSize)
        case .pkcs7:
            return PKCS7.Padding().remove(from: from, blockSize: blockSize)
        case .pkcs5:
            return PKCS5.Padding().remove(from: from, blockSize: blockSize)
        }
    }
}
