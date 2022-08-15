//
//  RSA+Signature.swift
//
//
//  Created by Brandon Toms on 7/7/22.
//

import Foundation

// MARK: Signatures & Verification

extension RSA: Signature {
  public func sign(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    try self.sign(Array(bytes), variant: .message_pkcs1v15_SHA256)
  }

  public func sign(_ bytes: Array<UInt8>, variant: SignatureVariant) throws -> Array<UInt8> {
    // Check for Private Exponent presence
    guard let d = d else {
      throw RSA.Error.noPrivateKey
    }

    // Hash & Encode Message
    let hashedAndEncoded = try RSA.hashedAndEncoded(bytes, variant: variant, keySizeInBytes: self.keySize / 8)

    /// Calculate the Signature
    let signedData = BigUInteger(Data(hashedAndEncoded)).power(d, modulus: self.n).serialize().bytes

    return signedData
  }

  public func verify(signature: ArraySlice<UInt8>, for expectedData: ArraySlice<UInt8>) throws -> Bool {
    try self.verify(signature: Array(signature), for: Array(expectedData), variant: .message_pkcs1v15_SHA256)
  }

  /// https://datatracker.ietf.org/doc/html/rfc8017#section-8.2.2
  public func verify(signature: Array<UInt8>, for bytes: Array<UInt8>, variant: SignatureVariant) throws -> Bool {
    /// Step 1: Ensure the signature is the same length as the key's modulus
    guard signature.count == (self.keySize / 8) || (signature.count - 1) == (self.keySize / 8) else { throw Error.invalidSignatureLength }

    let expectedData = try Array<UInt8>(RSA.hashedAndEncoded(bytes, variant: variant, keySizeInBytes: self.keySize / 8).dropFirst())

    /// Step 2: 'Decrypt' the signature
    let signatureResult = BigUInteger(Data(signature)).power(self.e, modulus: self.n).serialize().bytes

    /// Step 3: Compare the 'decrypted' signature with the prepared / encoded expected message....
    guard signatureResult == expectedData else { return false }

    return true
  }

  /// Hashes and Encodes a message for signing and verifying
  ///
  /// - Note: [EMSA-PKCS1-v1_5](https://datatracker.ietf.org/doc/html/rfc8017#section-9.2)
  fileprivate static func hashedAndEncoded(_ bytes: [UInt8], variant: SignatureVariant, keySizeInBytes: Int) throws -> Array<UInt8> {
    /// 1.  Apply the hash function to the message M to produce a hash
    let hashedMessage = variant.calculateHash(bytes)

    guard variant.enforceLength(hashedMessage) else { throw RSA.Error.invalidMessageLengthForSigning }

    /// 2. Encode the algorithm ID for the hash function and the hash value into an ASN.1 value of type DigestInfo
    /// PKCS#1_15 DER Structure (OID == sha256WithRSAEncryption)
    let asn: ASN1.Node = .sequence(nodes: [
      .sequence(nodes: [
        .objectIdentifier(data: Data(variant.identifier)),
        .null
      ]),
      .octetString(data: Data(hashedMessage))
    ])

    let t = ASN1.Encoder.encode(asn)

    /// 3.  If emLen < tLen + 11, output "intended encoded message length too short" and stop
    //print("Checking Key Size: \(keySizeInBytes) < \(t.count + 11)")
    if keySizeInBytes < t.count + 11 { throw RSA.Error.invalidMessageLengthForSigning }

    /// 4.  Generate an octet string PS consisting of emLen - tLen - 3
    /// octets with hexadecimal value 0xff. The length of PS will be
    /// at least 8 octets.
    /// 5.  Concatenate PS, the DER encoding T, and other padding to form
    /// the encoded message EM as EM = 0x00 || 0x01 || PS || 0x00 || T.
    let padded = variant.pad(bytes: t, to: keySizeInBytes)

    /// Ensure the signature is of the correct length
    guard padded.count == keySizeInBytes else { throw RSA.Error.invalidMessageLengthForSigning }

    return padded
  }
}

extension RSA {
  public enum SignatureVariant {
    case message_pkcs1v15_MD5
    case message_pkcs1v15_SHA1
    case message_pkcs1v15_SHA224
    case message_pkcs1v15_SHA256
    case message_pkcs1v15_SHA384
    case message_pkcs1v15_SHA512
    case message_pkcs1v15_SHA512_224
    case message_pkcs1v15_SHA512_256
    case digest_pkcs1v15_RAW
    case digest_pkcs1v15_MD5
    case digest_pkcs1v15_SHA1
    case digest_pkcs1v15_SHA224
    case digest_pkcs1v15_SHA256
    case digest_pkcs1v15_SHA384
    case digest_pkcs1v15_SHA512
    case digest_pkcs1v15_SHA512_224
    case digest_pkcs1v15_SHA512_256

    var identifier: Array<UInt8> {
      switch self {
        case .digest_pkcs1v15_RAW: return []
        case .message_pkcs1v15_MD5, .digest_pkcs1v15_MD5: return Array<UInt8>(arrayLiteral: 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05)
        case .message_pkcs1v15_SHA1, .digest_pkcs1v15_SHA1: return Array<UInt8>(arrayLiteral: 0x2b, 0x0e, 0x03, 0x02, 0x1a)
        case .message_pkcs1v15_SHA256, .digest_pkcs1v15_SHA256: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01)
        case .message_pkcs1v15_SHA384, .digest_pkcs1v15_SHA384: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02)
        case .message_pkcs1v15_SHA512, .digest_pkcs1v15_SHA512: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03)
        case .message_pkcs1v15_SHA224, .digest_pkcs1v15_SHA224: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04)
        case .message_pkcs1v15_SHA512_224, .digest_pkcs1v15_SHA512_224: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x05)
        case .message_pkcs1v15_SHA512_256, .digest_pkcs1v15_SHA512_256: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x06)
      }
    }

    func calculateHash(_ bytes: Array<UInt8>) -> Array<UInt8> {
      switch self {
        case .message_pkcs1v15_MD5:
          return Digest.md5(bytes)
        case .message_pkcs1v15_SHA1:
          return Digest.sha1(bytes)
        case .message_pkcs1v15_SHA224:
          return Digest.sha224(bytes)
        case .message_pkcs1v15_SHA256:
          return Digest.sha256(bytes)
        case .message_pkcs1v15_SHA384:
          return Digest.sha384(bytes)
        case .message_pkcs1v15_SHA512:
          return Digest.sha512(bytes)
        case .message_pkcs1v15_SHA512_224:
          return Digest.sha2(bytes, variant: .sha224)
        case .message_pkcs1v15_SHA512_256:
          return Digest.sha2(bytes, variant: .sha256)
        case .digest_pkcs1v15_RAW,
             .digest_pkcs1v15_MD5,
             .digest_pkcs1v15_SHA1,
             .digest_pkcs1v15_SHA224,
             .digest_pkcs1v15_SHA256,
             .digest_pkcs1v15_SHA384,
             .digest_pkcs1v15_SHA512,
             .digest_pkcs1v15_SHA512_224,
             .digest_pkcs1v15_SHA512_256:
          return bytes
      }
    }

    func enforceLength(_ bytes: Array<UInt8>) -> Bool {
      switch self {
        case .digest_pkcs1v15_MD5:
          return bytes.count <= 16
        case .digest_pkcs1v15_SHA1:
          return bytes.count <= 20
        case .digest_pkcs1v15_SHA224:
          return bytes.count <= 28
        case .digest_pkcs1v15_SHA256:
          return bytes.count <= 32
        case .digest_pkcs1v15_SHA384:
          return bytes.count <= 48
        case .digest_pkcs1v15_SHA512:
          return bytes.count <= 64
        case .digest_pkcs1v15_SHA512_224:
          return bytes.count <= 28
        case .digest_pkcs1v15_SHA512_256:
          return bytes.count <= 32
        case .message_pkcs1v15_MD5,
             .message_pkcs1v15_SHA1,
             .message_pkcs1v15_SHA224,
             .message_pkcs1v15_SHA256,
             .message_pkcs1v15_SHA384,
             .message_pkcs1v15_SHA512,
             .message_pkcs1v15_SHA512_224,
             .message_pkcs1v15_SHA512_256:
          return true
        default:
          return false
      }
    }

    /// Right now the only Padding Scheme supported is [EMCS-PKCS1v15](https://www.rfc-editor.org/rfc/rfc8017#section-9.2) (others include [EMSA-PSS](https://www.rfc-editor.org/rfc/rfc8017#section-9.1))
    func pad(bytes: Array<UInt8>, to blockSize: Int) -> Array<UInt8> {
      return Padding.emsa_pkcs1v15.add(to: bytes, blockSize: blockSize)
    }
  }
}
