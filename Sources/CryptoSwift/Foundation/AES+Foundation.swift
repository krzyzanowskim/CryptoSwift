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

import Foundation

extension AES {
  /// Initialize with CBC block mode.
  ///
  /// - Parameters:
  ///   - key: Key as a String.
  ///   - iv: IV as a String.
  ///   - padding: Padding
  /// - Throws: Error
  ///
  /// The input is a String, that is treat as sequence of bytes made directly out of String.
  /// If input is Base64 encoded data (which is a String technically) it is not decoded automatically for you.
  public convenience init(key: String, iv: String, padding: Padding = .pkcs7) throws {
    try self.init(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: padding)
  }
}
