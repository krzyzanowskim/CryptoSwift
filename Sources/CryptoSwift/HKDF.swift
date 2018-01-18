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

//  https://www.ietf.org/rfc/rfc5869.txt
//

#if os(Linux) || os(Android) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif
    
/// A key derivation function.
///
/// HKDF   - HMAC-based Extract-and-Expand Key Derivation Function.
public struct HKDF {
    
    public enum Error: Swift.Error {
        case invalidInput
        case derivedKeyTooLong
    }
    
    private let numBlocks: Int // l
    private let dkLen: Int
    private let info: Array<UInt8>
    fileprivate let prk: Array<UInt8>
    fileprivate let variant: HMAC.Variant
    
    /// - parameters:
    ///   - variant: hash variant
    ///   - salt: optional salt (if not provided, it is set to a sequence of variant.digestLength zeros)
    ///   - info: optional context and application specific information
    ///   - keyLength: intended length of derived key
    public init(password: Array<UInt8>, salt: Array<UInt8>? = nil, info: Array<UInt8>? = nil, keyLength: Int? = nil /* dkLen */, variant: HMAC.Variant = .sha256) throws {
        guard !password.isEmpty else {
            throw Error.invalidInput
        }
        
        let dkLen = keyLength ?? variant.digestLength
        let keyLengthFinal = Double(dkLen)
        let hLen = Double(variant.digestLength)
        let numBlocks = Int(ceil(keyLengthFinal / hLen)) // l = ceil(keyLength / hLen)
        guard numBlocks <= 255 else {
            throw Error.derivedKeyTooLong
        }
        
        /// HKDF-Extract(salt, password) -> PRK
        ///  - PRK - a pseudo-random key; it is used by calculate()
        self.prk = try HMAC(key: salt ?? [], variant: variant).authenticate(password)
        self.info = info ?? []
        self.variant = variant
        self.dkLen = dkLen
        self.numBlocks = numBlocks
    }
    
    public func calculate() throws -> Array<UInt8> {
        let hmac = HMAC(key: self.prk, variant: self.variant)
        var ret = Array<UInt8>()
        ret.reserveCapacity(self.numBlocks * self.variant.digestLength)
        var value = Array<UInt8>()
        for i in 1...self.numBlocks {
            value.append(contentsOf: self.info)
            value.append(UInt8(i))
            
            let bytes = try hmac.authenticate(value)
            ret.append(contentsOf: bytes)
            
            /// update value to use it as input for next iteration
            value = bytes
        }
        return Array(ret.prefix(dkLen))
    }
}

