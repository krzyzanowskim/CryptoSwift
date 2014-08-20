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
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.md5().toHexString()
    }
    
    public func sha1() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha1().toHexString()
    }

    public func sha256() -> String? {
        if let stringData = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return stringData.sha256().toHexString()
        }
        return nil
    }

}