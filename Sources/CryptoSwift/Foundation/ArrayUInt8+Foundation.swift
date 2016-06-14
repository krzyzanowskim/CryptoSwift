//
//  Array+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Array where Element: _UInt8Type {
    public init(_ data: Data) {
        self = Array<Element>(repeating: Element.Zero(), count: data.count)
        (data as NSData).getBytes(&self, length: self.count)
    }
}
