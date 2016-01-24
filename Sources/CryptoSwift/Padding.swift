//
//  Padding.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/02/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

public protocol Padding {
    func add(data: [UInt8], blockSize:Int) -> [UInt8]
    func remove(data: [UInt8], blockSize:Int?) -> [UInt8]
}