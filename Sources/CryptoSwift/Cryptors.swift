//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

  /// Generate array of random bytes. Helper function.
  static func randomIV(_ blockSize: Int) -> Array<UInt8>
}

extension Cryptors {
  /// Generate array of random values.
  /// Convenience helper that uses `Swift.RandomNumberGenerator`.
  /// - Parameter count: Length of array
  public static func randomIV(_ count: Int) -> Array<UInt8> {
    (0..<count).map({ _ in UInt8.random(in: 0...UInt8.max) })
  }
}
