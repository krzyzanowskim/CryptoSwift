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
        var stringData = self.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
        if var data = stringData!.md5() {
            return data.hexString
        }
        return nil
    }
}