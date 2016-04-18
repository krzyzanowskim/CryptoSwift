//
//  String+LinuxFoundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

extension String {
#if !os(Linux)
    
    // Workaround:
    // https://github.com/krzyzanowskim/CryptoSwift/issues/177
    func bridge() -> NSString {
        return self as NSString
    }
    
#endif
}

