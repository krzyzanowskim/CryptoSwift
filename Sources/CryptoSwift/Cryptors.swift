//
//  CryptoSwift
//
//  Copyright (C) 2014-2021 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(ucrt)
import ucrt
#endif

/// Worker cryptor/decryptor of `Updatable` types
public protocol Cryptors: AnyObject {

  /// Cryptor suitable for encryption
  func makeEncryptor() throws -> Cryptor & Updatable

  /// Cryptor suitable for decryption
  func makeDecryptor() throws -> Cryptor & Updatable
}

public extension Cryptors where Self: BlockCipher {
  /// Generates array of random bytes.
  /// Convenience helper that uses `Swift.SystemRandomNumberGenerator`.
  /// - Parameter count: Length of the result array
  @available(*, deprecated, message: "Please use `randomIV()`, which returns number of bytes equal to Self.blockSize.")
  static func randomIV(_ count: Int) -> [UInt8] {
    (0..<count).map({ _ in UInt8.random(in: 0...UInt8.max) })
  }

  /// Generates array of random bytes. `Self.blockSize` is used as length of the result array.
  /// Convenience helper that uses `Swift.SystemRandomNumberGenerator`.
  static func randomIV() -> [UInt8] {
    (0..<Self.blockSize).map({ _ in UInt8.random(in: 0...UInt8.max) })
  }
}
