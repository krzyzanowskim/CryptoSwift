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
//  ASN1 Code inspired by Asn1Parser.swift from SwiftyRSA

import Foundation

extension ASN1 {
  enum Encoder {
    /// Encodes an ASN1Node into it's byte representation
    ///
    /// - Parameter node: The Node to encode
    /// - Returns: The encoded bytes as a UInt8 array
    ///
    /// - Warning: This ASN.1 encoder has only been tested to work on certain ASN.1 data structures such as DER and PEM files. Before using this encoder for another application, ensure you test it's behavior accordingly.
    /// - Warning: This encoder makes no assumptions regarding Integer bit layout and signage. The proper serialization of Integers is left up to the user.
    public static func encode(_ node: ASN1.Node) -> [UInt8] {
      switch node {
        case .integer(let integer):
          return IDENTIFIERS.INTERGER.bytes + self.asn1LengthPrefixed(integer.bytes)
        case .bitString(let bits):
          return IDENTIFIERS.BITSTRING.bytes + self.asn1LengthPrefixed([0x00] + bits.bytes)
        case .octetString(let octet):
          return IDENTIFIERS.OCTETSTRING.bytes + self.asn1LengthPrefixed(octet.bytes)
        case .null:
          return IDENTIFIERS.NULL.bytes
        case .objectIdentifier(let oid):
          return IDENTIFIERS.OBJECTID.bytes + self.asn1LengthPrefixed(oid.bytes)
        case .sequence(let nodes):
          return IDENTIFIERS.SEQUENCE.bytes + self.asn1LengthPrefixed( nodes.reduce(into: Array<UInt8>(), { partialResult, node in
            partialResult += encode(node)
          }))
      }
    }

    /// Calculates and returns the ASN.1 length Prefix for a chunk of data
    ///
    /// - Parameter bytes: The bytes to be length prefixed
    /// - Returns: The ASN.1 length Prefix for this chuck of data (excluding the passed in data)
    private static func asn1LengthPrefix(_ bytes: [UInt8]) -> [UInt8] {
      if bytes.count >= 0x80 {
        var lengthAsBytes = withUnsafeBytes(of: bytes.count.bigEndian, Array<UInt8>.init)
        while lengthAsBytes.first == 0 { lengthAsBytes.removeFirst() }
        return [0x80 + UInt8(lengthAsBytes.count)] + lengthAsBytes
      } else {
        return [UInt8(bytes.count)]
      }
    }

    /// Prefixes the provided bytes with the appropriate ASN.1 length prefix
    ///
    /// - Parameter bytes: The bytes to be length prefixed
    /// - Returns: The provided bytes with the appropriate ASN.1 length prefix prepended
    private static func asn1LengthPrefixed(_ bytes: [UInt8]) -> [UInt8] {
      self.asn1LengthPrefix(bytes) + bytes
    }
  }
}
