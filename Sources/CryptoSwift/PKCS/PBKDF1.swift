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

public extension PKCS5 {
  /// A key derivation function.
  ///
  /// PBKDF1 is recommended only for compatibility with existing
  /// applications since the keys it produces may not be large enough for
  /// some applications.
  struct PBKDF1 {
    public enum Error: Swift.Error {
      case invalidInput
      case derivedKeyTooLong
    }

    public enum Variant {
      case md5, sha1

      @usableFromInline
      var size: Int {
        switch self {
          case .md5:
            return MD5.digestLength
          case .sha1:
            return SHA1.digestLength
        }
      }

      @usableFromInline
      func calculateHash(_ bytes: Array<UInt8>) -> Array<UInt8> {
        switch self {
          case .sha1:
            return Digest.sha1(bytes)
          case .md5:
            return Digest.md5(bytes)
        }
      }
    }

    @usableFromInline
    let iterations: Int // c

    @usableFromInline
    let variant: Variant

    @usableFromInline
    let keyLength: Int

    @usableFromInline
    let t1: Array<UInt8>

    /// - parameters:
    ///   - salt: salt, an eight-bytes
    ///   - variant: hash variant
    ///   - iterations: iteration count, a positive integer
    ///   - keyLength: intended length of derived key
    public init(password: Array<UInt8>, salt: Array<UInt8>, variant: Variant = .sha1, iterations: Int = 4096 /* c */, keyLength: Int? = nil /* dkLen */ ) throws {
      precondition(iterations > 0)
      precondition(salt.count == 8)

      let keyLength = keyLength ?? variant.size

      if keyLength > variant.size {
        throw Error.derivedKeyTooLong
      }

      let t1 = variant.calculateHash(password + salt)

      self.iterations = iterations
      self.variant = variant
      self.keyLength = keyLength
      self.t1 = t1
    }

    /// Apply the underlying hash function Hash for c iterations
    @inlinable
    public func calculate() -> Array<UInt8> {
      var t = self.t1
      for _ in 2...self.iterations {
        t = self.variant.calculateHash(t)
      }
      return Array(t[0..<self.keyLength])
    }
  }
}
