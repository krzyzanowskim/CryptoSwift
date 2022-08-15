//
//  RSA+Cipher.swift
//
//
//  Created by Brandon Toms on 7/7/22.
//

import Foundation

// MARK: Cipher

extension RSA: Cipher {

  @inlinable
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    return try self.encrypt(Array<UInt8>(bytes), variant: .pksc1v15)
  }

  @inlinable
  public func encrypt(_ bytes: Array<UInt8>, variant: RSAEncryptionVariant) throws -> Array<UInt8> {
    // Prepare the data for the specified variant
    let preparedData = try variant.prepare(bytes, blockSize: self.keySize / 8)

    // Encrypt the prepared data
    return try variant.formatEncryptedBytes(self.encryptPreparedBytes(preparedData), blockSize: self.keySize / 8)
  }

  @inlinable
  internal func encryptPreparedBytes(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    // Ensure our Key is large enough to safely encrypt the data
    //guard (self.keySize / 8) >= bytes.count else { throw RSA.Error.invalidMessageLengthForEncryption }

    // Calculate encrypted data
    return BigUInteger(Data(bytes)).power(self.e, modulus: self.n).serialize().bytes
  }

  @inlinable
  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    return try self.decrypt(Array<UInt8>(bytes), variant: .pksc1v15)
  }

  @inlinable
  public func decrypt(_ bytes: Array<UInt8>, variant: RSAEncryptionVariant) throws -> Array<UInt8> {
    // Decrypt the data
    let decrypted = try self.decryptPreparedBytes(bytes)

    // Remove padding / unstructure data and return the raw plaintext
    return variant.removePadding(decrypted, blockSize: self.keySize / 8)
  }

  @inlinable
  internal func decryptPreparedBytes(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    // Check for Private Exponent presence
    guard let d = d else { throw RSA.Error.noPrivateKey }

    // Calculate decrypted data
    return BigUInteger(Data(bytes)).power(d, modulus: self.n).serialize().bytes
  }
}

extension RSA {
  public enum RSAEncryptionVariant {
    /// The `unsafe` encryption variant, is fully deterministic and doesn't format the inbound data in any way.
    ///
    /// - Warning: This is considered an unsafe method of encryption.
    case unsafe
    /// The `raw` encryption variant formats the inbound data with a deterministic padding scheme.
    ///
    /// - Warning: This is also considered to be an unsafe method of encryption, but matches the `Security` frameworks functionality.
    case raw
    /// The `pkcs1v15` encryption variant formats the inbound data with a non deterministic psuedo random padding scheme.
    ///
    /// [EME PKCS1v1.5 Padding Scheme Spec](https://datatracker.ietf.org/doc/html/rfc2313#section-8.1)
    case pksc1v15

    @inlinable
    internal func prepare(_ bytes: Array<UInt8>, blockSize: Int) throws -> Array<UInt8> {
      switch self {
        case .unsafe:
          return bytes
        case .raw:
          // We need at least 11 bytes of random padding in order to safely encrypt messages
          guard blockSize >= bytes.count + 11 else { throw RSA.Error.invalidMessageLengthForEncryption }
          return Array(repeating: 0x00, count: blockSize - bytes.count) + bytes
        case .pksc1v15:
          guard !bytes.isEmpty else { throw RSA.Error.invalidMessageLengthForEncryption }
          // We need at least 11 bytes of random padding in order to safely encrypt messages
          guard blockSize >= bytes.count + 11 else { throw RSA.Error.invalidMessageLengthForEncryption }
          return Padding.eme_pkcs1v15.add(to: bytes, blockSize: blockSize)
      }
    }

    @inlinable
    internal func formatEncryptedBytes(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        case .unsafe:
          return bytes
        case .raw, .pksc1v15:
          // Format the encrypted bytes before returning
          var bytes = bytes
          if bytes.isEmpty {
            // Instead of returning an empty byte array, we return an array of zero's of length keySize bytes
            // This functionality matches that of Apple's `Security` framework
            return Array<UInt8>(repeating: 0, count: blockSize)
          } else {
            while bytes.count % 4 != 0 { bytes.insert(0x00, at: 0) }
            return bytes
          }
      }
    }

    @inlinable
    internal func removePadding(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        case .unsafe:
          return bytes
        case .raw:
          return bytes
        case .pksc1v15:
          // Convert the Octet String into an Integer Primitive using the BigInteger `serialize` method
          // (this effectively just prefixes the data with a 0x00 byte indicating that its a positive integer)
          return Padding.eme_pkcs1v15.remove(from: [0x00] + bytes, blockSize: blockSize)
      }
    }
  }
}
