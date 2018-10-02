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

import Foundation

extension String {
    /// Return Base64 back to String
    public func decryptBase64ToString(cipher: Cipher) throws -> String {
        guard let decodedData = Data(base64Encoded: self, options: []) else {
            throw CipherError.decrypt
        }

        let decrypted = try decodedData.decrypt(cipher: cipher)

        if let decryptedString = String(data: decrypted, encoding: String.Encoding.utf8) {
            return decryptedString
        }

        throw CipherError.decrypt
    }

    public func decryptBase64(cipher: Cipher) throws -> Array<UInt8> {
        guard let decodedData = Data(base64Encoded: self, options: []) else {
            throw CipherError.decrypt
        }

        return try decodedData.decrypt(cipher: cipher).bytes
    }
}
