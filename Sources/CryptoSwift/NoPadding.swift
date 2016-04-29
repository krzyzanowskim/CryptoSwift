//
//  NoPadding.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public struct NoPadding: Padding {
    public init() {
    
    }
    
    public func add(data: [UInt8], blockSize:Int) -> [UInt8] {
        return data;
    }

    public func remove(data: [UInt8], blockSize:Int?) -> [UInt8] {
        return data;
    }
}
