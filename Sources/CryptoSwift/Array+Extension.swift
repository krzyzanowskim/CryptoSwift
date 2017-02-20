//
//  ArrayExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 10/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

extension Array {
    init(reserveCapacity: Int) {
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }
}

extension Array {

    /** split in chunks with given chunk size */
    func chunks(size chunksize: Int) -> Array<Array<Element>> {
        var words = Array<Array<Element>>()
        words.reserveCapacity(self.count / chunksize)
        for idx in stride(from: chunksize, through: self.count, by: chunksize) {
            words.append(Array(self[idx - chunksize ..< idx])) // slow for large table
        }
        let remainder = self.suffix(self.count % chunksize)
        if !remainder.isEmpty {
            words.append(Array(remainder))
        }
        return words
    }
}

extension Array where Element: Integer, Element.IntegerLiteralType == UInt8 {

    public init(hex: String) {
        self.init()
        
        do{
            try hex.streamHexBytes { (byte) in
                self.append(byte as! Element)
            }
        } catch _ as NSError{
            self.removeAll()
        }
    }
}
