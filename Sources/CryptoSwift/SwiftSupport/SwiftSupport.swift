//
//  SwiftSupport.swift
//  Rx
//
//  Created by Volodymyr  Gorbenko on 3/6/17.
//  Copyright © 2017 Krunoslav Zaher. All rights reserved.
//

import Foundation

#if swift(>=4.0)
    typealias UIntMax = UInt64
    public typealias Integer = FixedWidthInteger
#else
    extension UInt8 {
        public init(extendingOrTruncating source: Int) {
            self.init(truncatingBitPattern: source)
        }
    }
    extension UInt8 {
        public init(extendingOrTruncating source: UInt16) {
            self.init(truncatingBitPattern: source)
        }
    }
    extension UInt8 {
        public init(extendingOrTruncating source: Int16) {
            self.init(truncatingBitPattern: source)
        }
    }
    extension UInt16 {
        public init(extendingOrTruncating source: UInt32) {
            self.init(truncatingBitPattern: source)
        }
    }
    extension UInt16 {
        public init(extendingOrTruncating source: Int32) {
            self.init(truncatingBitPattern: source)
        }
    }
    extension UInt32 {
        public init(extendingOrTruncating source: UInt64) {
            self.init(truncatingBitPattern: source)
        }
    }
#endif
