//
//  AEAD.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2025 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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
//

// https://www.iana.org/assignments/aead-parameters/aead-parameters.xhtml

/// Authenticated Encryption with Associated Data (AEAD)
public protocol AEAD {
  static var kLen: Int { get } // key length
  static var ivRange: Range<Int> { get } // nonce length
}

extension AEAD {
  static func calculateAuthenticationTag(authenticator: Authenticator, cipherText: Array<UInt8>, authenticationHeader: Array<UInt8>) throws -> Array<UInt8> {
    let headerPadding = ((16 - (authenticationHeader.count & 0xf)) & 0xf)
    let cipherPadding = ((16 - (cipherText.count & 0xf)) & 0xf)

    var mac = authenticationHeader
    mac += Array<UInt8>(repeating: 0, count: headerPadding)
    mac += cipherText
    mac += Array<UInt8>(repeating: 0, count: cipherPadding)
    mac += UInt64(bigEndian: UInt64(authenticationHeader.count)).bytes()
    mac += UInt64(bigEndian: UInt64(cipherText.count)).bytes()

    return try authenticator.authenticate(mac)
  }
}
