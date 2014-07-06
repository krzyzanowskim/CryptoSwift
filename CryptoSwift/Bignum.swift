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
    
    convenience init(_ bignum: Bignum) {
        self.init();
        self.bignumPointer = BN_dup(bignum.bignumPointer);
    }
    
    convenience init(_ pointer: UnsafePointer<BIGNUM>) {
        self.init();
        self.bignumPointer = BN_dup(pointer);
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
        let copied:Bignum = Bignum(self)
        return copied
    }
    
    deinit {
        BN_clear_free(bignumPointer);
        bignumPointer.destroy()
    }
}

@infix func + (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    BN_add(resultPointer,left.bignumPointer, right.bignumPointer);
    return Bignum(resultPointer)
}

@infix func - (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    BN_sub(resultPointer,left.bignumPointer, right.bignumPointer);
    return Bignum(resultPointer)
}

@infix func * (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    var ctx:COpaquePointer = BN_CTX_new();
    BN_CTX_init(ctx)
    
    BN_mul(resultPointer,left.bignumPointer, right.bignumPointer, ctx);
    BN_CTX_free(ctx)
    
    return Bignum(resultPointer)
}

@infix func / (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    var ctx:COpaquePointer = BN_CTX_new();
    BN_CTX_init(ctx)
    
    BN_div(resultPointer, nil, left.bignumPointer, right.bignumPointer, ctx);
    BN_CTX_free(ctx)
    
    return Bignum(resultPointer)
}
