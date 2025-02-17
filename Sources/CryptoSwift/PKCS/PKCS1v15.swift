//
//  CryptoSwift
//
//  Copyright (C) 2014-2025 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

//  PKCS is a group of public-key cryptography standards devised
//  and published by RSA Security Inc, starting in the early 1990s.
//

/// EMSA PKCS1 v1.5 Padding Scheme
///
/// The EMSA Version of the PKCS1 v1.5 padding scheme is **deterministic** (it pads the messages contents with 255 value bytes)
/// ```
/// // The returned structure
/// // - PS is the applied padding
/// // - M is your original Message
/// EM = 0x00 || 0x01 || PS || 0x00 || M.
/// ```
/// - Note: This Padding scheme is intended to be used for encoding RSA Signatures
///
/// [EMSA-PKCS1v1_5 IETF Spec](https://datatracker.ietf.org/doc/html/rfc8017#section-9.2)
struct EMSAPKCS1v15Padding: PaddingProtocol {

  init() {
  }

  @inlinable
  func add(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
    var r = blockSize - ((bytes.count + 3) % blockSize)
    if r <= 0 { r = blockSize - 3 }

    return [0x00, 0x01] + Array<UInt8>(repeating: 0xFF, count: r) + [0x00] + bytes
  }

  @inlinable
  func remove(from bytes: Array<UInt8>, blockSize _: Int?) -> Array<UInt8> {
    assert(!bytes.isEmpty, "Need bytes to remove padding")

    assert(bytes.prefix(2) == [0x00, 0x01], "Invalid padding prefix")

    guard let paddingLength = bytes.dropFirst(2).firstIndex(of: 0x00) else { return bytes }

    guard (paddingLength + 1) <= bytes.count else { return bytes }

    return Array(bytes[(paddingLength + 1)...])
  }
}

/// EME PKCS1 v1.5 Padding Scheme
///
/// The EME Version of the PKCS1 v1.5 padding scheme is **non deterministic** (it pads the messages contents with psuedo-random bytes)
/// ```
/// // The returned structure
/// // - PS is the applied padding
/// // - M is your original Message
/// EM = 0x00 || 0x02 || PS || 0x00 || M.
/// ```
/// - Note: This Padding scheme is intended to be used for encoding messages before RSA Encryption
///
/// [EME-PKCS1v1_5 IETF Spec](https://datatracker.ietf.org/doc/html/rfc8017#section-7.2.1)
struct EMEPKCS1v15Padding: PaddingProtocol {

  init() {
  }

  @inlinable
  func add(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
    var r = blockSize - ((bytes.count + 3) % blockSize)
    if r <= 0 { r = blockSize - 3 }

    return [0x00, 0x02] + (0..<r).map { _ in UInt8.random(in: 1...UInt8.max) } + [0x00] + bytes
  }

  @inlinable
  func remove(from bytes: Array<UInt8>, blockSize _: Int?) -> Array<UInt8> {
    assert(!bytes.isEmpty, "Need bytes to remove padding")

    assert(bytes.prefix(2) == [0x00, 0x02], "Invalid padding prefix")

    guard let paddingLength = bytes.dropFirst(2).firstIndex(of: 0x00) else { return bytes }

    guard (paddingLength + 1) <= bytes.count else { return bytes }

    return Array(bytes[(paddingLength + 1)...])
  }
}
