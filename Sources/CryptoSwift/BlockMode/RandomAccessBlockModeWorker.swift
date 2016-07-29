//
//  RandomAccessBlockModeWorker.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 29/07/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

protocol RandomAccessBlockModeWorker: BlockModeWorker {
    var counter: UInt { set get }
}
