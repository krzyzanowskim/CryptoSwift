//
//  CryptoSwift
//
//  Copyright (C) Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

/// Fernet provides support for the [fernet](https://github.com/fernet/spec) encryption format.
public struct Fernet {
  let makeDate: () -> Date
  let makeIV: (Int) -> [UInt8]
  let signingKey: Data
  let encryptionKey: Data

  /// Initialize Fernet with a Base64URL encoded key.
  public init(
    encodedKey: Data,
    makeDate: @escaping () -> Date = Date.init,
    makeIV: @escaping (Int) -> [UInt8] = AES.randomIV
  ) throws {
    guard let fernetKey = Data(base64URLData: encodedKey) else { throw KeyError.invalidFormat }
    try self.init(key: fernetKey, makeDate: makeDate, makeIV: makeIV)
  }

  /// Initialize Fernet with raw, unencoded key.
  public init(
    key: Data,
    makeDate: @escaping () -> Date = Date.init,
    makeIV: @escaping (Int) -> [UInt8] = AES.randomIV
  ) throws {
    guard key.count == 32 else { throw KeyError.invalidLength }
    self.makeDate = makeDate
    self.makeIV = makeIV
    signingKey = key.prefix(16)
    encryptionKey = key.suffix(16)
  }

  /// Decode fernet data.
  public func decode(_ encoded: Data) throws -> DecodeOutput {
    guard let fernetToken = Data(base64URLData: encoded) else { throw DecodingError.tokenDecodingFailed }

    guard fernetToken.count >= 73 && (fernetToken.count - 57) % 16 == 0 else {
      throw DecodingError.invalidTokenFormat
    }
    let version = fernetToken[0]
    let timestamp = fernetToken[1..<9]
    let iv = fernetToken[9..<25]
    let ciphertext = fernetToken[25..<fernetToken.count - 32]
    let hmac = fernetToken[fernetToken.count - 32..<fernetToken.count]

    guard version == 128 else { throw DecodingError.unknownVersion }
    let plaintext = try decrypt(ciphertext: ciphertext, key: encryptionKey, iv: iv)
    let hmacMatches = try verifyHMAC(
      hmac,
      authenticating: Data([version]) + timestamp + iv + ciphertext,
      using: signingKey
    )

    return DecodeOutput(data: plaintext, hmacSuccess: hmacMatches)
  }

  /// Encode data in the fernet format.
  public func encode(_ data: Data) throws -> Data {
    let timestamp: [UInt8] = {
      let now = self.makeDate()
      let timestamp = Int(now.timeIntervalSince1970).bigEndian
      return withUnsafeBytes(of: timestamp, Array.init)
    }()
    guard case let iv = makeIV(16), iv.count == 16 else { throw EncodingError.invalidIV }
    let ciphertext: [UInt8]
    do {
      let aes = try AES(key: encryptionKey.bytes, blockMode: CBC(iv: iv), padding: .pkcs7)
      ciphertext = try aes.encrypt(data.bytes)
    } catch {
      throw EncodingError.aesError(error)
    }
    let version: [UInt8] = [0x80]
    let hmac = try makeVerificationHMAC(data: Data(version + timestamp + iv + ciphertext), key: signingKey)
    let fernetToken = (version + timestamp + iv + ciphertext + hmac).base64URLEncodedData()
    return fernetToken
  }
}

extension Fernet {
  /// Errors encountered while processing the fernet key.
  public enum KeyError: Error {
    case invalidFormat
    case invalidLength
  }

  /// Errors encountered while decoding data.
  public enum DecodingError: Error {
    case aesError(any Error)
    case hmacError(any Error)
    case invalidTokenFormat
    case keyDecodingFailed
    case tokenDecodingFailed
    case unknownVersion
  }

  /// Errors encountered while encoding data.
  public enum EncodingError: Error {
    case aesError(any Error)
    case hmacError(any Error)
    case invalidIV
  }

  /// Decoding result.
  public struct DecodeOutput {
    /// Decoded data.
    var data: Data
    /// A boolean indicating if HMAC verification was successful.
    var hmacSuccess: Bool
  }
}

private func computeHMAC(data: Data, key: Data) throws -> Data {
  Data(try HMAC(key: key.bytes, variant: .sha2(.sha256)).authenticate(data.bytes))
}

private func decrypt(ciphertext: Data, key: Data, iv: Data) throws -> Data {
  do {
    let aes = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7)
    let decryptedData = try aes.decrypt(ciphertext.bytes)
    return Data(decryptedData)
  } catch {
    throw Fernet.DecodingError.aesError(error)
  }
}

private func makeVerificationHMAC(data: Data, key: Data) throws -> Data {
  do {
    return try computeHMAC(data: data, key: key)
  } catch {
    throw Fernet.EncodingError.hmacError(error)
  }
}

private func verifyHMAC(_ mac: Data, authenticating data: Data, using key: Data) throws -> Bool {
  do {
    let auth = try computeHMAC(data: data, key: key)
    return constantTimeEquals(auth, mac)
  } catch {
    throw Fernet.DecodingError.hmacError(error)
  }
}

// Who knows how the compiler will optimize this but at least try to be constant time.
private func constantTimeEquals<C1, C2>(_ lhs: C1, _ rhs: C2) -> Bool
  where C1: Collection,
  C2: Collection,
  C1.Element == UInt8,
  C2.Element == UInt8 {
  guard lhs.count == rhs.count else { return false }
  return zip(lhs, rhs).reduce(into: 0) { output, pair in output |= pair.0 ^ pair.1 } == 0
}

private extension Data {
  init?(base64URLData base64: Data) {
    var decoded = base64.map { b in
      switch b {
        case ASCII.dash.rawValue: ASCII.plus.rawValue
        case ASCII.underscore.rawValue: ASCII.slash.rawValue
        default: b
      }
    }
    while decoded.count % 4 != 0 {
      decoded.append(ASCII.equals.rawValue)
    }
    self.init(base64Encoded: Data(decoded))
  }

  func base64URLEncodedData() -> Data {
    let bytes = base64EncodedData()
      .compactMap { b in
        switch b {
          case ASCII.plus.rawValue: ASCII.dash.rawValue
          case ASCII.slash.rawValue: ASCII.underscore.rawValue
          case ASCII.equals.rawValue: nil
          default: b
        }
      }
    return Data(bytes)
  }
}

private enum ASCII: UInt8 {
  case plus = 43
  case dash = 45
  case slash = 47
  case equals = 61
  case underscore = 95
}
