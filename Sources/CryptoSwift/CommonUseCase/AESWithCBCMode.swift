////  CryptoSwift
//
//  Copyright (C) 2014-2020 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

public func encryptAESWithCBCMode(plainText: String, secretKey: String, iv: String?, padding: Padding) -> String? {
  do {
    let ivToUse = getConvertedIV(iv: iv, blockSize: secretKey.count)
    let aes = try AES(key: Array(secretKey.utf8), blockMode: CBC(iv: ivToUse), padding: padding)
    let encrypted = try aes.encrypt(Array(plainText.utf8))
    let value = String(bytes: encrypted, encoding: .utf8)
    return value
  } catch {
    print("Failed to encrypt with error:", error.localizedDescription)
    return nil
  }
}

public func decryptAESWithCBCMode(cipherText: String, secretKey: String, iv: String?, padding: Padding) -> String? {
  do {
    let ivToUse = getConvertedIV(iv: iv, blockSize: secretKey.count)
    let aes = try AES(key: Array(secretKey.utf8), blockMode: CBC(iv: ivToUse), padding: padding)
    let decrypted = try aes.decrypt(Array(cipherText.utf8))
    let value = String(bytes: decrypted, encoding: .utf8)
    return value
  } catch {
    print("Failed to decrypt with error:", error.localizedDescription)
    return nil
  }
}

private func getConvertedIV(iv: String?, blockSize: Int) -> [UInt8] {
  if let iv = iv {
    return .init(iv.utf8)
  } else {
    return .init(repeating: 0x00, count: blockSize)
  }
}
