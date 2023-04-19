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

extension XChaCha20 {
  /// Convenience initializer that creates an XChaCha20 instance with the given key and IV
  /// represented as hex-encoded strings.
  ///
  /// - Parameters:
  ///   - key: The encryption/decryption key as a hex-encoded string.
  ///   - iv: The initialization vector as a hex-encoded string.
  /// - Throws: An error if the provided key or IV are of invalid length, format, or not hex-encoded.
  public convenience init(key: String, iv: String) throws {
    try self.init(key: key.bytes, iv: iv.bytes)
  }
}
