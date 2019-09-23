//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

public final class CBCMAC: CMAC {
    override public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
        var inBytes = bytes
        bitPadding(to: &inBytes, blockSize: CMAC.BlockSize)
        let blocks = inBytes.batched(by: CMAC.BlockSize)
        
        var lastBlockEncryptionResult : [UInt8] = CBCMAC.Zero
        try blocks.forEach { (block) in
            let aes = try AES(key: Array(key), blockMode: CBC(iv: lastBlockEncryptionResult), padding: .noPadding)
            lastBlockEncryptionResult = try aes.encrypt(block)
        }
        
        return lastBlockEncryptionResult
    }
}
