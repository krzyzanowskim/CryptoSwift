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
    
    public func addPadding(data:NSData, blockSizeBytes:Int) -> NSData {
        switch (self) {
        case PKCS_7:
            return PKCS7(data: data).addPadding(UInt8(blockSizeBytes))
        case None:
            return data
        }
    }
    
    public func removePadding(data:NSData) -> NSData {
        switch (self) {
        case PKCS_7:
            return PKCS7(data: data).removePadding()
        case None:
            return data
        }
    }

}