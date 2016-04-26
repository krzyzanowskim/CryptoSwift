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
    public func decryptBase64ToString(cipher: CipherProtocol) throws -> String {
        guard let decodedData = NSData(base64EncodedString: self, options: []) else {
            throw CipherError.Decrypt
        }

        let decrypted = try decodedData.decrypt(cipher)

        if let decryptedString = String(data: decrypted, encoding: NSUTF8StringEncoding) {
            return decryptedString
        }

        throw CipherError.Decrypt
    }

    public func decryptBase64(cipher: CipherProtocol) throws -> [UInt8] {
        guard let decodedData = NSData(base64EncodedString: self, options: []) else {
            throw CipherError.Decrypt
        }

        return try decodedData.decrypt(cipher).arrayOfBytes()
    }

}