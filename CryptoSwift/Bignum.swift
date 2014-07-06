//
//  Bignum.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class Bignum {
    var bignumPointer:UnsafePointer<BIGNUM>;
    
    var numberOfBytes:Int {
        get {
            return Int((BN_num_bits(self.bignumPointer)+7)/8);
        }
    }
    
    init() {
        self.bignumPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
        BN_init(bignumPointer)
    }
    
    convenience init(bignum: Bignum) {
        self.init();
        self.bignumPointer = BN_dup(bignum.bignumPointer);
    }
    
    convenience init(data: NSData) {
        self.init();
        var constPointerToBytes = CConstPointer<CUnsignedChar>(data, data.bytes.value)
        var bn:UnsafePointer<BIGNUM> = BN_bin2bn(constPointerToBytes, CInt(data.length), nil);
        self.bignumPointer = bn;
    }
    
    func data() -> NSData {
        let len = self.numberOfBytes;
        var buf = UnsafePointer<Byte>.alloc(len);
        let bytesCount = Int(BN_bn2bin(self.bignumPointer, buf))
        return NSData(bytes: buf, length: bytesCount);
    }
    
    func copy() -> AnyObject! {
        let copied:Bignum = Bignum(bignum: self)
        return copied
    }
    
    deinit {
        BN_clear_free(bignumPointer);
        bignumPointer.destroy()
    }
}