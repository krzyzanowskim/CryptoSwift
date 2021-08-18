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
    /// No private key specified
    case noPrivateKey
  }
  
  /// RSA Modulus
  public let n: GiantUInt
  
  /// RSA Public Exponent
  public let e: GiantUInt
  
  /// RSA Private Exponent
  public let d: GiantUInt?
  
  /// The size of the modulus, in bits
  public let keySize: Int
  
  /// Initialize with RSA parameters
  /// - Parameters:
  ///   - n: The RSA Modulus
  ///   - e: The RSA Public Exponent
  ///   - d: The RSA Private Exponent (or nil if unknown, e.g. if only public key is known)
  public init(n: GiantUInt, e: GiantUInt, d: GiantUInt? = nil) {
    self.n = n
    self.e = e
    self.d = d
    
    self.keySize = n.bytes.count * 8
  }
  
  /// Initialize with RSA parameters
  /// - Parameters:
  ///   - n: The RSA Modulus
  ///   - e: The RSA Public Exponent
  ///   - d: The RSA Private Exponent (or nil if unknown, e.g. if only public key is known)
  public convenience init(n: Array<UInt8>, e: Array<UInt8>, d: Array<UInt8>? = nil) {
    if let d = d {
      self.init(n: GiantUInt(n), e: GiantUInt(e), d: GiantUInt(d))
    } else {
      self.init(n: GiantUInt(n), e: GiantUInt(e))
    }
  }
  
  // TODO: Add initializer from PEM (ASN.1 with DER header)
  
  // TODO: Add export to PEM (ASN.1 with DER header)
  
}

// MARK: Cipher

extension RSA: Cipher {
  
  @inlinable
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    // Calculate encrypted data
    return GiantUInt.exponentiateWithModulus(rhs: GiantUInt(Array(bytes)), lhs: e, modulus: n).bytes
  }

  @inlinable
  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    // Check for Private Exponent presence
    guard let d = d else {
      throw RSA.Error.noPrivateKey
    }
    
    // Calculate decrypted data
    return GiantUInt.exponentiateWithModulus(rhs: GiantUInt(Array(bytes)), lhs: d, modulus: n).bytes
  }
  
}
