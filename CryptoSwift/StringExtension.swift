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
        var stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if let hash = stringData!.md5() {
            return hash.hexString
        }
        return nil
    }
    
    public func sha1() -> String? {
        var stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if let hash = stringData!.sha1() {
            return hash.hexString
        }
        return nil
    }
}