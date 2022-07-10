//
//  RSA+Cipher.swift
//
//
//  Created by Brandon Toms on 7/7/22.
//

import Foundation

// MARK: Cipher

extension RSA: Cipher {

  public enum RSAEncryptionVariant {
    case raw
    /// https://datatracker.ietf.org/doc/html/rfc2313#section-8.1
    // case pksc1v15

    @inlinable func prepare(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        case .raw:
          return bytes
//      case .pksc1v15:
      }
    }

    @inlinable func removePadding(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        case .raw:
          return bytes
//      case .pksc1v15:
      }
    }
  }

  @inlinable
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    // Calculate encrypted data
    return BigUInteger(Data(bytes)).power(self.e, modulus: self.n).serialize().bytes
  }

  @inlinable
  public func encrypt(_ bytes: Array<UInt8>, variant: RSAEncryptionVariant) throws -> Array<UInt8> {
    // prep the data for the specified variant
    return try self.encrypt(variant.prepare(bytes, blockSize: self.keySize))
  }

  @inlinable
  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    // Check for Private Exponent presence
    guard let d = d else {
      throw RSA.Error.noPrivateKey
    }

    // Calculate decrypted data
    return BigUInteger(Data(bytes)).power(d, modulus: self.n).serialize().bytes
  }

  public func decrypt(_ bytes: Array<UInt8>, variant: RSAEncryptionVariant) throws -> Array<UInt8> {
    // prep the data for the specified variant
    let decrypted = try self.decrypt(bytes)

    return variant.removePadding(decrypted, blockSize: self.keySize)
  }
}
