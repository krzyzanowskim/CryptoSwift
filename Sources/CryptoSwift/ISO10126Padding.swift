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

/// Padding with random bytes, ending with the number of added bytes.
/// Read the [Wikipedia](https://en.wikipedia.org/wiki/Padding_(cryptography)#ISO_10126)
/// and [Crypto-IT](http://www.crypto-it.net/eng/theory/padding.html) articles for more info.
struct ISO10126Padding: PaddingProtocol {
  init() {
  }

  @inlinable
  func add(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
    let padding = UInt8(blockSize - (bytes.count % blockSize))
    var withPadding = bytes
    if padding > 0 {
      withPadding += (0..<(padding - 1)).map { _ in UInt8.random(in: 0...255) } + [padding]
    }
    return withPadding
  }

  @inlinable
  func remove(from bytes: Array<UInt8>, blockSize: Int?) -> Array<UInt8> {
    guard !bytes.isEmpty, let lastByte = bytes.last else {
      return bytes
    }

    assert(!bytes.isEmpty, "Need bytes to remove padding")

    let padding = Int(lastByte) // last byte
    let finalLength = bytes.count - padding

    if finalLength < 0 {
      return bytes
    }

    if padding >= 1 {
      return Array(bytes[0..<finalLength])
    }

    return bytes
  }
}
