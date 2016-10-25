//
//  BlockModeOptions.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

struct BlockModeOptions: OptionSet {
    let rawValue: Int

    static let None = BlockModeOptions(rawValue: 0)
    static let InitializationVectorRequired = BlockModeOptions(rawValue: 1)
    static let PaddingRequired = BlockModeOptions(rawValue: 2)
}
