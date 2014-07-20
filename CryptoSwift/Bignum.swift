//
//  Bignum.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class Bignum {
    var bignumPointer:UnsafePointer<BIGNUM> {
        willSet {
            BN_clear(self.bignumPointer);
            self.bignumPointer.destroy()
        }
    }
    
    var numberOfBytes:Int {
        get {
            return Int((BN_num_bits(self.bignumPointer)+7)/8);
        }
    }
    
    init() {
        self.bignumPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
        BN_init(bignumPointer)
    }
    
    convenience init(_ bignum: Bignum?) {
        self.init();
        if (bignum) {
            self.bignumPointer = BN_dup(bignum!.bignumPointer);
        }
    }
    
    class func bignumWithBignum (bignum: Bignum?) -> Bignum? {
        var newBignum = Bignum();
        if let bb = bignum {
            newBignum.bignumPointer = BN_dup(bb.bignumPointer);
        }
        return nil;
    }
    
    class func bignumWithPointer (pointer: UnsafePointer<BIGNUM>) -> Bignum? {
        var newBignum = Bignum();
        newBignum.bignumPointer = BN_dup(pointer)
        return newBignum
    }
    
    class func bignumWithData(data: NSData?) -> Bignum? {
        var newBignum = Bignum();
        if let d = data {
            newBignum.initWithData(d);
            return newBignum
        }
        return nil
    }
    
    func initWithData(data: NSData?) -> Bool {
        if (!data) {
            return false;
        }
        
        let constPointerToBytes = ConstUnsafePointer<CUnsignedChar>(data!.bytes)
        var bn:UnsafePointer<BIGNUM> = BN_bin2bn(constPointerToBytes, CInt(data!.length), nil);
        if (bn == nil) {
            return false;
        }
        self.bignumPointer = bn;
        return true;
    }
    
    func data() -> NSData? {
        let len = self.numberOfBytes;
        var buf = UnsafePointer<Byte>.alloc(len);
        
        let convertResult = BN_bn2bin(self.bignumPointer, buf);
        if (convertResult == nil) {
            return nil;
        }
        
        var returnData:NSData = NSData(bytes: buf, length: Int(convertResult))
        buf.destroy()
        return returnData
    }
    
    func copy() -> AnyObject! {
        let copied:Bignum = Bignum(self)
        return copied
    }
    
    deinit {
        BN_clear(self.bignumPointer);
        self.bignumPointer.destroy()
    }
}

@infix func + (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    BN_add(resultPointer,left.bignumPointer, right.bignumPointer);
    var result = Bignum.bignumWithPointer(resultPointer)
    resultPointer.destroy()
    return result!
}

@infix func - (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    BN_sub(resultPointer,left.bignumPointer, right.bignumPointer);
    var result = Bignum.bignumWithPointer(resultPointer)
    resultPointer.destroy()
    return result!
}

@infix func * (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    var ctx:COpaquePointer = BN_CTX_new();
    BN_CTX_init(ctx)
    
    BN_mul(resultPointer,left.bignumPointer, right.bignumPointer, ctx);
    BN_CTX_free(ctx)
    var result:Bignum! = Bignum.bignumWithPointer(resultPointer)
    resultPointer.destroy()
    return result
}

@infix func / (left: Bignum, right: Bignum) -> Bignum {
    var resultPointer = UnsafePointer<BIGNUM>.alloc(sizeof(BIGNUM))
    var ctx:COpaquePointer = BN_CTX_new();
    BN_CTX_init(ctx)
    
    BN_div(resultPointer, nil, left.bignumPointer, right.bignumPointer, ctx);
    BN_CTX_free(ctx)
    
    var result:Bignum! = Bignum.bignumWithPointer(resultPointer)
    resultPointer.destroy()
    return result
}
