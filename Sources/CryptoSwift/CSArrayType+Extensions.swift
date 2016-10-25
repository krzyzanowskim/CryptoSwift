//
//  _ArrayType+Extensions.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/10/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

public protocol CSArrayType: Collection, RangeReplaceableCollection {
    func cs_arrayValue() -> [Iterator.Element]
}

extension Array: CSArrayType {

    public func cs_arrayValue() -> [Iterator.Element] {
        return self
    }
}

public extension CSArrayType where Iterator.Element == UInt8 {

    public func toHexString() -> String {
        return self.lazy.reduce("") {
            var s = String($1, radix: 16)
            if s.characters.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}

public extension CSArrayType where Iterator.Element == UInt8 {

    public func md5() -> [Iterator.Element] {
        return Digest.md5(cs_arrayValue())
    }

    public func sha1() -> [Iterator.Element] {
        return Digest.sha1(cs_arrayValue())
    }

    public func sha224() -> [Iterator.Element] {
        return Digest.sha224(cs_arrayValue())
    }

    public func sha256() -> [Iterator.Element] {
        return Digest.sha256(cs_arrayValue())
    }

    public func sha384() -> [Iterator.Element] {
        return Digest.sha384(cs_arrayValue())
    }

    public func sha512() -> [Iterator.Element] {
        return Digest.sha512(cs_arrayValue())
    }

    public func sha2(_ variant: SHA2.Variant) -> [Iterator.Element] {
        return Digest.sha2(cs_arrayValue(), variant: variant)
    }

    public func sha3(_ variant: SHA3.Variant) -> [Iterator.Element] {
        return Digest.sha3(cs_arrayValue(), variant: variant)
    }

    public func crc32(seed: UInt32? = nil, reflect: Bool = true) -> UInt32 {
        return Checksum.crc32(cs_arrayValue(), seed: seed, reflect: reflect)
    }

    public func crc16(seed: UInt16? = nil) -> UInt16 {
        return Checksum.crc16(cs_arrayValue(), seed: seed)
    }

    public func encrypt(cipher: Cipher) throws -> [Iterator.Element] {
        return try cipher.encrypt(cs_arrayValue())
    }

    public func decrypt(cipher: Cipher) throws -> [Iterator.Element] {
        return try cipher.decrypt(cs_arrayValue())
    }

    public func authenticate<A: Authenticator>(with authenticator: A) throws -> [Iterator.Element] {
        return try authenticator.authenticate(cs_arrayValue())
    }
}
