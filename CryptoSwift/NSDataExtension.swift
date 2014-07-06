//
//  PGPDataExtension.swift
//  SwiftPGP
//
//  Created by Marcin Krzyzanowski on 05/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

enum CryptoHash: Int {
    case md5 = 1
    case sha1 = 2
    case sha224 = 3
    case sha256 = 4
    case sha384 = 5
    case sha512 = 6
    case ripemd160 = 7
    
    func hash(data: NSData) -> NSData! {
        switch self {
        case md5:
            return data.md5()
        case sha1:
            return data.sha1()
        case sha224:
            return data.sha224()
        case sha256:
            return data.sha256()
        case sha384:
            return data.sha384()
        case sha512:
            return data.sha512()
        case ripemd160:
            return data.ripemd160()
        }
    }
}

extension NSData {
    
    func arrayOfBytes() -> Array<Byte> {
        let count = self.length / sizeof(Byte)
        var bytesArray = Byte[](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        return bytesArray
    }
    
    func checksum() -> UInt16 {
        var s:UInt32 = 0;
        
        var bytesArray = self.arrayOfBytes();
        
        for (var i = 0; i < bytesArray.count; i++) {
            var b = bytesArray[i]
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536;
        return UInt16(s);
    }
    
    func md5() -> NSData {
         
        var ctx = UnsafePointer<CC_MD5_CTX>.alloc(sizeof(CC_MD5_CTX))
        CC_MD5_Init(ctx);

        CC_MD5_Update(ctx, self.bytes, UInt32(self.length));
        let length = Int(CC_MD5_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        CC_MD5_Final(output, ctx);

        let outData = NSData(bytes: output, length: Int(CC_MD5_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()

        //withUnsafePointer
        return outData;
    }
    
    func sha1() -> NSData {
        var ctx = UnsafePointer<CC_SHA1_CTX>.alloc(sizeof(CC_SHA1_CTX))
        CC_SHA1_Init(ctx);
        
        CC_SHA1_Update(ctx, self.bytes, UInt32(self.length));
        let length = Int(CC_SHA1_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        CC_SHA1_Final(output, ctx);
        
        let outData = NSData(bytes: output, length: Int(CC_SHA1_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()
        
        return outData;
    }
    
    func sha224() -> NSData {
        var ctx = UnsafePointer<CC_SHA256_CTX>.alloc(sizeof(CC_SHA256_CTX))
        CC_SHA224_Init(ctx);
        
        CC_SHA224_Update(ctx, self.bytes, UInt32(self.length));
        let length = Int(CC_SHA224_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        CC_SHA224_Final(output, ctx);
        
        let outData = NSData(bytes: output, length: Int(CC_SHA224_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()
        
        return outData;
    }
    
    func sha256() -> NSData {
        var ctx = UnsafePointer<CC_SHA256_CTX>.alloc(sizeof(CC_SHA256_CTX))
        CC_SHA256_Init(ctx);
        
        CC_SHA256_Update(ctx, self.bytes, UInt32(self.length));
        let length = Int(CC_SHA256_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        CC_SHA256_Final(output, ctx);
        
        let outData = NSData(bytes: output, length: Int(CC_SHA256_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()
        
        return outData;
    }
    
    func sha384() -> NSData {
        var ctx = UnsafePointer<CC_SHA512_CTX>.alloc(sizeof(CC_SHA512_CTX))
        CC_SHA384_Init(ctx);
        
        CC_SHA384_Update(ctx, self.bytes, UInt32(self.length));
        let length = Int(CC_SHA384_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        CC_SHA384_Final(output, ctx);
        
        let outData = NSData(bytes: output, length: Int(CC_SHA384_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()
        
        return outData;
    }
    
    func sha512() -> NSData {
        var ctx = UnsafePointer<CC_SHA512_CTX>.alloc(sizeof(CC_SHA512_CTX))
        CC_SHA512_Init(ctx);
        
        CC_SHA512_Update(ctx, self.bytes, UInt32(self.length));
        let length = Int(CC_SHA512_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        CC_SHA512_Final(output, ctx);
        
        let outData = NSData(bytes: output, length: Int(CC_SHA512_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()
        
        return outData;
    }

    func ripemd160() -> NSData {
        var ctx = UnsafePointer<RIPEMD160_CTX>.alloc(sizeof(RIPEMD160_CTX))
        RIPEMD160_Init(ctx);
        
        RIPEMD160_Update(ctx, self.bytes, UInt(self.length));
        let length = Int(RIPEMD160_DIGEST_LENGTH) * sizeof(Byte)
        var output = UnsafePointer<Byte>.alloc(length)
        RIPEMD160_Final(output, ctx);
        
        let outData = NSData(bytes: output, length: Int(RIPEMD160_DIGEST_LENGTH))
        output.destroy()
        ctx.destroy()
        
        return outData;
    }
    
    func toHexString() -> String {
        let count = self.length / sizeof(Byte)
        var bytesArray = Byte[](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        
        var s:String = "";
        for(var i = 0; i < bytesArray.count; i++) {
            var st: String = NSString(format:"%02X", bytesArray[i])
            NSLog("\(bytesArray[i]) -> \(st)")
            s = s + st
        }
        return s;
    }
}

