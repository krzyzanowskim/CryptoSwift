//
//  NoPadding.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public struct NoPadding: Padding {
    
    public func add(_ data: [UInt8], blockSize:Int) -> [UInt8] {
        return data;
    }

    public func remove(_ data: [UInt8], blockSize:Int?) -> [UInt8] {
        return data;
    }
    
    public init() { }
}
