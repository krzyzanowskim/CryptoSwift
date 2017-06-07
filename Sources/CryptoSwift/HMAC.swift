//
//  HMAC.swift
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

public final class HMAC: Authenticator {

    public enum Error: Swift.Error {
        case authenticateError
        case invalidInput
    }

    public enum Variant {
        case sha1, sha256, sha384, sha512, md5

        var digestLength: Int {
            switch (self) {
            case .sha1:
                return SHA1.digestLength
            case .sha256:
                return SHA2.Variant.sha256.digestLength
            case .sha384:
                return SHA2.Variant.sha384.digestLength
            case .sha512:
                return SHA2.Variant.sha512.digestLength
            case .md5:
                return MD5.digestLength
            }
        }

        func calculateHash(_ bytes: Array<UInt8>) -> Array<UInt8>? {
            switch (self) {
            case .sha1:
                return Digest.sha1(bytes)
            case .sha256:
                return Digest.sha256(bytes)
            case .sha384:
                return Digest.sha384(bytes)
            case .sha512:
                return Digest.sha512(bytes)
            case .md5:
                return Digest.md5(bytes)
            }
        }

        func blockSize() -> Int {
            switch self {
            case .md5:
                return MD5.blockSize
            case .sha1, .sha256:
                return 64
            case .sha384, .sha512:
                return 128
            }
        }
    }

    var key: Array<UInt8>
    let variant: Variant

    public init(key: Array<UInt8>, variant: HMAC.Variant = .md5) {
        self.variant = variant
        self.key = key

        if key.count > variant.blockSize() {
            if let hash = variant.calculateHash(key) {
                self.key = hash
            }
        }

        if key.count < variant.blockSize() {
            self.key = ZeroPadding().add(to: key, blockSize: variant.blockSize())
        }
    }

    // MARK: Authenticator

    public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
        var opad = Array<UInt8>(repeating: 0x5c, count: variant.blockSize())
        for idx in key.indices {
            opad[idx] = key[idx] ^ opad[idx]
        }
        var ipad = Array<UInt8>(repeating: 0x36, count: variant.blockSize())
        for idx in key.indices {
            ipad[idx] = key[idx] ^ ipad[idx]
        }

        guard let ipadAndMessageHash = variant.calculateHash(ipad + bytes),
            let result = variant.calculateHash(opad + ipadAndMessageHash) else {
            throw Error.authenticateError
        }

        // return Array(result[0..<10]) // 80 bits
        return result
    }
}
