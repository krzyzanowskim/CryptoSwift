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

import Foundation

extension Data {
    /// Two octet checksum as defined in RFC-4880. Sum of all octets, mod 65536
    public func checksum() -> UInt16 {
        var s: UInt32 = 0
        let bytesArray = bytes
        for i in 0 ..< bytesArray.count {
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536
        return UInt16(s)
    }

    public func md5() -> Data {
        return Data( Digest.md5(bytes))
    }

    public func sha1() -> Data {
        return Data( Digest.sha1(bytes))
    }

    public func sha224() -> Data {
        return Data( Digest.sha224(bytes))
    }

    public func sha256() -> Data {
        return Data( Digest.sha256(bytes))
    }

    public func sha384() -> Data {
        return Data( Digest.sha384(bytes))
    }

    public func sha512() -> Data {
        return Data( Digest.sha512(bytes))
    }

    public func sha3(_ variant: SHA3.Variant) -> Data {
        return Data( Digest.sha3(bytes, variant: variant))
    }

    public func crc32(seed: UInt32? = nil, reflect: Bool = true) -> Data {
        return Data( Checksum.crc32(bytes, seed: seed, reflect: reflect).bytes())
    }

    public func crc32c(seed: UInt32? = nil, reflect: Bool = true) -> Data {
        return Data( Checksum.crc32c(bytes, seed: seed, reflect: reflect).bytes())
    }

    public func crc16(seed: UInt16? = nil) -> Data {
        return Data( Checksum.crc16(bytes, seed: seed).bytes())
    }

    public func encrypt(cipher: Cipher) throws -> Data {
        return Data( try cipher.encrypt(bytes.slice))
    }

    public func decrypt(cipher: Cipher) throws -> Data {
        return Data( try cipher.decrypt(bytes.slice))
    }

    public func authenticate(with authenticator: Authenticator) throws -> Data {
        return Data( try authenticator.authenticate(bytes))
    }
}

extension Data {
    public init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }

    public var bytes: Array<UInt8> {
        return Array(self)
    }

    public func toHexString() -> String {
        return bytes.toHexString()
    }
}
