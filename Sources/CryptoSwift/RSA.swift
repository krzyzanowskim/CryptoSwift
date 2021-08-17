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

public final class RSA {
  
  public enum Error: Swift.Error {
    /// Invalid key
    case invalidKey
  }
  
  let publicKey: Key?
  let privateKey: Key?
  
  public var keySize: Int = 0
  
  public init(publicKey: Array<UInt8>?, privateKey: Array<UInt8>?) throws {
    if let publicKey = publicKey {
      self.publicKey = Key(bytes: publicKey)
      self.keySize = self.publicKey!.count
    } else {
      self.publicKey = nil
    }
    if let privateKey = privateKey {
      self.privateKey = Key(bytes: privateKey)
      self.keySize = self.privateKey!.count
    } else {
      self.privateKey = nil
    }
    if keySize == 0 {
      throw RSA.Error.invalidKey
    }
  }
  
}

// MARK: Cipher

extension RSA: Cipher {
  
  @inlinable
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    // TODO
    return []
  }

  @inlinable
  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    // TODO
    return []
  }
  
}
