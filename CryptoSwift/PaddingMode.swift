//
//  PaddingMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum PaddingMode:Int {
    case None, PKCS_7
    
    func addPadding(data:NSData, blockSizeBytes:UInt8) -> NSData {
        switch (self) {
        case PKCS_7:
            return PKCS7(data: data).addPadding(blockSizeBytes)
        case None:
            return data
        }
    }
}