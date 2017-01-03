//
//  Error+Extension.swift
//  CryptoSwift
//
//  Created by Michael Ledin on 22.08.16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

#if !_runtime(_ObjC)

    extension Error {
        var localizedDescription: String {
            return "\(self)"
        }
    }
#endif
