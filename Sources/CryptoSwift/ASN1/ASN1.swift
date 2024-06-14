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

/// A Partial ASN.1 (Abstract Syntax Notation 1) Encoder & Decoder Implementation.
///
/// - Note: This implementation is limited to a few core types and is not an exhaustive / complete ASN1 implementation
/// - Warning: This implementation has been developed for encoding and decoding DER & PEM files specifically. If you're using this Encoder/Decoder on other ASN1 structures, make sure you test the expected behavior appropriately.
enum ASN1 {
  internal enum IDENTIFIERS: UInt8, Equatable {
    case SEQUENCE = 0x30
    case INTERGER = 0x02
    case OBJECTID = 0x06
    case NULL = 0x05
    case BITSTRING = 0x03
    case OCTETSTRING = 0x04

    static func == (lhs: UInt8, rhs: IDENTIFIERS) -> Bool {
      lhs == rhs.rawValue
    }

    var bytes: [UInt8] {
      switch self {
        case .NULL:
          return [self.rawValue, 0x00]
        default:
          return [self.rawValue]
      }
    }
  }

  /// An ASN1 node
  internal enum Node: CustomStringConvertible {
    /// An array of more `ASN1.Node`s
    case sequence(nodes: [Node])
    /// An integer
    /// - Note: This ASN1 Encoder makes no assumptions about the sign and bit order of the integers passed in. The conversion from Integer to Data is your responsibility.
    case integer(data: Data)
    /// An objectIdentifier
    case objectIdentifier(data: Data)
    /// A null object
    case null
    /// A bitString
    case bitString(data: Data)
    /// An octetString
    case octetString(data: Data)

    var description: String {
      ASN1.printNode(self, level: 0)
    }
  }

  internal static func printNode(_ node: ASN1.Node, level: Int) -> String {
    var str: [String] = []
    let prefix = String(repeating: "\t", count: level)
    switch node {
      case .integer(let int):
        str.append("\(prefix)Integer: \(int.toHexString())")
      case .bitString(let bs):
        str.append("\(prefix)BitString: \(bs.toHexString())")
      case .null:
        str.append("\(prefix)NULL")
      case .objectIdentifier(let oid):
        str.append("\(prefix)ObjectID: \(oid.toHexString())")
      case .octetString(let os):
        str.append("\(prefix)OctetString: \(os.toHexString())")
      case .sequence(let nodes):
        str.append("\(prefix)Sequence:")
        nodes.forEach { str.append(printNode($0, level: level + 1)) }
    }
    return str.joined(separator: "\n")
  }
}
