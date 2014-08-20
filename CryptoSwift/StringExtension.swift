//
//  StringExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** String extension */
extension String {
    
    /** Calculate MD5 hash */
    public func md5() -> String? {
        if let stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return stringData.md5().toHexString()
        }
        return nil
    }
    
    public func sha1() -> String? {
        if let stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return stringData.sha1().toHexString()
        }
        return nil
    }

    public func sha256() -> String? {
        if let stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return stringData.sha256().toHexString()
        }
        return nil
    }

}