//
//  String+LinuxFoundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

// Workaround:
// https://github.com/krzyzanowskim/CryptoSwift/issues/177
extension String {
#if !os(Linux)
    func bridge() -> NSString {
        return self as NSString
    }
#endif
}