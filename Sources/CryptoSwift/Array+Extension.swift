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
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer:UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                self.removeAll()
                return
            }
            let v:UInt8
            let c:UInt8 = UInt8(char.value)
            switch c{
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                self.removeAll()
                return
            }
            if let b = buffer {
                self.append(b << 4 | v as! Element)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer{
            self.append(b as! Element)
        }
    }
    
}
