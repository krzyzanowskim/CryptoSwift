//
//  String+Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 13/10/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
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
