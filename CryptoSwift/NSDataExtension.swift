//
//  PGPDataExtension.swift
//  SwiftPGP
//
//  Created by Marcin Krzyzanowski on 05/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension NSMutableData {
    
    /** Convenient way to append bytes */
    internal func appendBytes(arrayOfBytes: Array<Byte>) {
        self.appendBytes(arrayOfBytes, length: arrayOfBytes.count)
    }
    
}

extension NSData {
    
    public var hexString: String {
        return self.toHexString()
    }
    
    public func checksum() -> UInt16 {
        var s:UInt32 = 0;
        
        var bytesArray = self.arrayOfBytes();
        
        for (var i = 0; i < bytesArray.count; i++) {
            var b = bytesArray[i]
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536;
        return UInt16(s);
    }
    
    public func md5() -> NSData? {
        return MD5.calculate(self);
    }
    
    internal func toHexString() -> String {
        let count = self.length / sizeof(Byte)
        var bytesArray = [Byte](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        
        var s:String = "";
        for(var i = 0; i < bytesArray.count; i++) {
            var st: String = NSString(format:"%02X", bytesArray[i])
            NSLog("\(bytesArray[i]) -> \(st)")
            s = s + st
        }
        return s;
    }
    
    internal func arrayOfBytes() -> Array<Byte> {
        let count = self.length / sizeof(Byte)
        var bytesArray = [Byte](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        return bytesArray
    }
}

