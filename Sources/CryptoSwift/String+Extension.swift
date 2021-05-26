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

/** String extension */
extension String {

  @inlinable
  public var bytes: Array<UInt8> {
    data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
  }

  @inlinable
  public func md5() -> String {
    self.bytes.md5().toHexString()
  }

  @inlinable
  public func sha1() -> String {
    self.bytes.sha1().toHexString()
  }

  @inlinable
  public func sha224() -> String {
    self.bytes.sha224().toHexString()
  }

  @inlinable
  public func sha256() -> String {
    self.bytes.sha256().toHexString()
  }

  @inlinable
  public func sha384() -> String {
    self.bytes.sha384().toHexString()
  }

  @inlinable
  public func sha512() -> String {
    self.bytes.sha512().toHexString()
  }

  @inlinable
  public func sha3(_ variant: SHA3.Variant) -> String {
    self.bytes.sha3(variant).toHexString()
  }

  @inlinable
  public func crc32(seed: UInt32? = nil, reflect: Bool = true) -> String {
    self.bytes.crc32(seed: seed, reflect: reflect).bytes().toHexString()
  }

  @inlinable
  public func crc32c(seed: UInt32? = nil, reflect: Bool = true) -> String {
    self.bytes.crc32c(seed: seed, reflect: reflect).bytes().toHexString()
  }

  @inlinable
  public func crc16(seed: UInt16? = nil) -> String {
    self.bytes.crc16(seed: seed).bytes().toHexString()
  }

  /// - parameter cipher: Instance of `Cipher`
  /// - returns: hex string of bytes
  @inlinable
  public func encrypt(cipher: Cipher) throws -> String {
    try self.bytes.encrypt(cipher: cipher).toHexString()
  }

  /// - parameter cipher: Instance of `Cipher`
  /// - returns: base64 encoded string of encrypted bytes
  @inlinable
  public func encryptToBase64(cipher: Cipher) throws -> String {
    try self.bytes.encrypt(cipher: cipher).toBase64()
  }

  // decrypt() does not make sense for String

  /// - parameter authenticator: Instance of `Authenticator`
  /// - returns: hex string of string
  @inlinable
  public func authenticate<A: Authenticator>(with authenticator: A) throws -> String {
    try self.bytes.authenticate(with: authenticator).toHexString()
  }
}
