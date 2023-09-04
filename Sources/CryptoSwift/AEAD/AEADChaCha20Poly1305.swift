//
//  AEADChaCha20Poly1305.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2022 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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
//  https://tools.ietf.org/html/rfc7539#section-2.8.1

/// AEAD_CHACHA20_POLY1305
public final class AEADChaCha20Poly1305: AEAD {
  public static let kLen = 32 // key length
  public static var ivRange = Range<Int>(12...12)

  /// Authenticated encryption
  public static func encrypt(_ plainText: Array<UInt8>, key: Array<UInt8>, iv: Array<UInt8>, authenticationHeader: Array<UInt8>) throws -> (cipherText: Array<UInt8>, authenticationTag: Array<UInt8>) {
    let cipher = try ChaCha20(key: key, iv: iv)
    return try self.encrypt(cipher: cipher, plainText, key: key, iv: iv, authenticationHeader: authenticationHeader)
  }

  public static func encrypt(cipher: Cipher, _ plainText: Array<UInt8>, key: Array<UInt8>, iv: Array<UInt8>, authenticationHeader: Array<UInt8>) throws -> (cipherText: Array<UInt8>, authenticationTag: Array<UInt8>) {
    var polykey = Array<UInt8>(repeating: 0, count: kLen)
    var toEncrypt = polykey
    polykey = try cipher.encrypt(polykey)
    toEncrypt += polykey
    toEncrypt += plainText

    let fullCipherText = try cipher.encrypt(toEncrypt)
    let cipherText = Array(fullCipherText.dropFirst(64))

    let tag = try calculateAuthenticationTag(authenticator: Poly1305(key: polykey), cipherText: cipherText, authenticationHeader: authenticationHeader)
    return (cipherText, tag)
  }

  /// Authenticated decryption
  public static func decrypt(_ cipherText: Array<UInt8>, key: Array<UInt8>, iv: Array<UInt8>, authenticationHeader: Array<UInt8>, authenticationTag: Array<UInt8>) throws -> (plainText: Array<UInt8>, success: Bool) {
    let cipher = try ChaCha20(key: key, iv: iv)
    return try self.decrypt(cipher: cipher, cipherText: cipherText, key: key, iv: iv, authenticationHeader: authenticationHeader, authenticationTag: authenticationTag)
  }

  static func decrypt(cipher: Cipher, cipherText: Array<UInt8>, key: Array<UInt8>, iv: Array<UInt8>, authenticationHeader: Array<UInt8>, authenticationTag: Array<UInt8>) throws -> (plainText: Array<UInt8>, success: Bool) {

    let polykey = try cipher.encrypt(Array<UInt8>(repeating: 0, count: self.kLen))
    let mac = try calculateAuthenticationTag(authenticator: Poly1305(key: polykey), cipherText: cipherText, authenticationHeader: authenticationHeader)
    guard mac == authenticationTag else {
      return (cipherText, false)
    }

    var toDecrypt = Array<UInt8>(reserveCapacity: cipherText.count + 64)
    toDecrypt += polykey
    toDecrypt += polykey
    toDecrypt += cipherText
    let fullPlainText = try cipher.decrypt(toDecrypt)
    let plainText = Array(fullPlainText.dropFirst(64))
    return (plainText, true)
  }
}
