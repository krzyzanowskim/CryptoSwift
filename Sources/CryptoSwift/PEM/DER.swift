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

/// Conform to this protocol if your type can both be instantiated and expressed as an ASN1 DER representation.
internal protocol DERCodable: DERDecodable, DEREncodable { }

/// Conform to this protocol if your type can be instantiated from a ASN1 DER representation
internal protocol DERDecodable {
  /// Attempts to instantiate an instance of your Public Key when given a DER representation of your Public Key
  ///
  /// - Parameter publicDER: The ASN.1 DER representation of your Public Key
  init(publicDER: Array<UInt8>) throws

  /// Attempts to instantiate an instance of your Private Key when given a DER representation of your Private Key
  ///
  /// - Parameter privateDER: The ASN.1 DER representation of your Private Key
  init(privateDER: Array<UInt8>) throws

  /// Attempts to instantiate a Key when given the ASN1 DER encoded external representation of the Key
  ///
  /// - Parameter rawRepresentation: The ASN1 DER Encoded external representation (either public or private)
  /// - Note: The external representation is identical to that of `SecKeyCopyExternalRepresentation` function from Apple's `Security` framework
  init(rawRepresentation: Data) throws
}

/// Conform to this protocol if your type can be described in an ASN1 DER representation
internal protocol DEREncodable {
  /// Returns the DER encoded representation of the Public Key
  func publicKeyDER() throws -> Array<UInt8>

  /// Returns the DER encoded representation of the Private Key
  func privateKeyDER() throws -> Array<UInt8>

  /// A semantically similar function that mimics the `SecKeyCopyExternalRepresentation` function from Apple's `Security` framework
  /// - Note: If called on a Private Key, this method will return the Private Keys DER Representation. Likewise, if called on a Public Key, this method will return the Public Keys DER Representation
  /// - Note: If you'd like to export the Public Keys DER from a Private Key, use the `publicKeyExternalRepresentation()` function
  func externalRepresentation() throws -> Data

  /// A semantically similar function that mimics the `SecKeyCopyExternalRepresentation` function from Apple's `Security` framework
  /// - Note: This function only ever exports the Public Key's DER representation. If called on a Private Key, the corresponding Public Key will be extracted and exported.
  func publicKeyExternalRepresentation() throws -> Data
}

struct DER {
  internal enum Error: Swift.Error {
    /// We were provided invalid DER data
    case invalidDERFormat
  }

  /// Integer to Octet String Primitive
  /// - Parameters:
  ///   - x: nonnegative integer to be converted
  ///   - size: intended length of the resulting octet string
  /// - Returns: corresponding octet string of length xLen
  /// - Note: https://datatracker.ietf.org/doc/html/rfc3447#section-4.1
  internal static func i2osp(x: [UInt8], size: Int) -> [UInt8] {
    var modulus = x
    while modulus.count < size {
      modulus.insert(0x00, at: 0)
    }
    if modulus[0] >= 0x80 {
      modulus.insert(0x00, at: 0)
    }
    return modulus
  }

  /// Integer to Octet String Primitive
  /// - Parameters:
  ///   - x: nonnegative integer to be converted
  ///   - size: intended length of the resulting octet string
  /// - Returns: corresponding octet string of length xLen
  /// - Note: https://datatracker.ietf.org/doc/html/rfc3447#section-4.1
  internal static func i2ospData(x: [UInt8], size: Int) -> Data {
    return Data(DER.i2osp(x: x, size: size))
  }
}
