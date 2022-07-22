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
//  ASN1 Scanner code is from Asn1Parser.swift from SwiftyRSA

import Foundation

extension ASN1 {
  /// Simple data scanner that consumes bytes from a raw data and keeps an updated position.
  internal class Scanner {

    enum ScannerError: Error {
      case outOfBounds
    }

    let data: Data
    var index: Int = 0

    /// Returns whether there is no more data to consume
    var isComplete: Bool {
      return self.index >= self.data.count
    }

    /// Creates a scanner with provided data
    ///
    /// - Parameter data: Data to consume
    init(data: Data) {
      self.data = data
    }

    /// Consumes data of provided length and returns it
    ///
    /// - Parameter length: length of the data to consume
    /// - Returns: data consumed
    /// - Throws: ScannerError.outOfBounds error if asked to consume too many bytes
    func consume(length: Int) throws -> Data {

      guard length > 0 else {
        return Data()
      }

      guard self.index + length <= self.data.count else {
        throw ScannerError.outOfBounds
      }

      let subdata = self.data.subdata(in: self.index..<self.index + length)
      self.index += length
      return subdata
    }

    /// Consumes a primitive, definite ASN1 length and returns its value.
    ///
    /// See http://luca.ntop.org/Teaching/Appunti/asn1.html,
    ///
    /// - Short form. One octet. Bit 8 has value "0" and bits 7-1 give the length.
    /// - Long form. Two to 127 octets. Bit 8 of first octet has value "1" and
    ///   bits 7-1 give the number of additional length octets.
    ///   Second and following octets give the length, base 256, most significant digit first.
    ///
    /// - Returns: Length that was consumed
    /// - Throws: ScannerError.outOfBounds error if asked to consume too many bytes
    func consumeLength() throws -> Int {

      let lengthByte = try consume(length: 1).firstByte

      // If the first byte's value is less than 0x80, it directly contains the length
      // so we can return it
      guard lengthByte >= 0x80 else {
        return Int(lengthByte)
      }

      // If the first byte's value is more than 0x80, it indicates how many following bytes
      // will describe the length. For instance, 0x85 indicates that 0x85 - 0x80 = 0x05 = 5
      // bytes will describe the length, so we need to read the 5 next bytes and get their integer
      // value to determine the length.
      let nextByteCount = lengthByte - 0x80
      let length = try consume(length: Int(nextByteCount))

      return length.integer
    }
  }
}

internal extension Data {

  /// Returns the first byte of the current data
  var firstByte: UInt8 {
    var byte: UInt8 = 0
    copyBytes(to: &byte, count: MemoryLayout<UInt8>.size)
    return byte
  }

  /// Returns the integer value of the current data.
  /// - Warning: This only supports data up to 4 bytes, as we can only extract 32-bit integers.
  var integer: Int {

    guard count > 0 else {
      return 0
    }

    var int: UInt32 = 0
    var offset: Int32 = Int32(count - 1)
    forEach { byte in
      let byte32 = UInt32(byte)
      let shifted = byte32 << (UInt32(offset) * 8)
      int = int | shifted
      offset -= 1
    }

    return Int(int)
  }
}
