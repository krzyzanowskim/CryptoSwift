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
  /// A simple ASN1 parser that will recursively iterate over a root node and return a Node tree.
  /// The root node can be any of the supported nodes described in `Node`. If the parser encounters a sequence
  /// it will recursively parse its children.
  enum Decoder {

    enum DecodingError: Error {
      case noType
      case invalidType(value: UInt8)
    }

    /// Parses ASN1 data and returns its root node.
    ///
    /// - Parameter data: ASN1 data to parse
    /// - Returns: Root ASN1 Node
    /// - Throws: A DecodingError if anything goes wrong, or if an unknown node was encountered
    static func decode(data: Data) throws -> Node {
      let scanner = ASN1.Scanner(data: data)
      let node = try decodeNode(scanner: scanner)
      return node
    }

    /// Parses an ASN1 given an existing scanner.
    /// @warning: this will modify the state (ie: position) of the provided scanner.
    ///
    /// - Parameter scanner: Scanner to use to consume the data
    /// - Returns: Parsed node
    /// - Throws: A DecodingError if anything goes wrong, or if an unknown node was encountered
    private static func decodeNode(scanner: ASN1.Scanner) throws -> Node {

      let firstByte = try scanner.consume(length: 1).firstByte

      switch firstByte {
        case IDENTIFIERS.SEQUENCE.rawValue:
          let length = try scanner.consumeLength()
          let data = try scanner.consume(length: length)
          let nodes = try decodeSequence(data: data)
          return .sequence(nodes: nodes)

        case IDENTIFIERS.INTERGER.rawValue:
          let length = try scanner.consumeLength()
          let data = try scanner.consume(length: length)
          return .integer(data: data)

        case IDENTIFIERS.OBJECTID.rawValue:
          let length = try scanner.consumeLength()
          let data = try scanner.consume(length: length)
          return .objectIdentifier(data: data)

        case IDENTIFIERS.NULL.rawValue:
          _ = try scanner.consume(length: 1)
          return .null

        case IDENTIFIERS.BITSTRING.rawValue:
          let length = try scanner.consumeLength()

          // There's an extra byte (0x00) after the bit string length in all the keys I've encountered.
          // I couldn't find a specification that referenced this extra byte, but let's consume it and discard it.
          _ = try scanner.consume(length: 1)

          let data = try scanner.consume(length: length - 1)
          return .bitString(data: data)

        case IDENTIFIERS.OCTETSTRING.rawValue:
          let length = try scanner.consumeLength()
          let data = try scanner.consume(length: length)
          return .octetString(data: data)

        default:
          throw DecodingError.invalidType(value: firstByte)
      }
    }

    /// Parses an ASN1 sequence and returns its child nodes
    ///
    /// - Parameter data: ASN1 data
    /// - Returns: A list of ASN1 nodes
    /// - Throws: A DecodingError if anything goes wrong, or if an unknown node was encountered
    private static func decodeSequence(data: Data) throws -> [Node] {
      let scanner = ASN1.Scanner(data: data)
      var nodes: [Node] = []
      while !scanner.isComplete {
        let node = try decodeNode(scanner: scanner)
        nodes.append(node)
      }
      return nodes
    }
  }
}
