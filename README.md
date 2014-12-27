#CryptoSwift
Crypto related functions and helpers for [Swift](https://developer.apple.com/swift/) implemented in Swift. ([#PureSwift](https://twitter.com/hashtag/pureswift))

##Requirements
Good mood

##Features

- Easy to use
- Convenience extensions

###What implemented?

#### Hash
- [MD5](http://tools.ietf.org/html/rfc1321)
- [SHA1](http://tools.ietf.org/html/rfc3174)
- [SHA224](http://tools.ietf.org/html/rfc6234)
- [SHA256](http://tools.ietf.org/html/rfc6234)
- [SHA384](http://tools.ietf.org/html/rfc6234)
- [SHA512](http://tools.ietf.org/html/rfc6234)
- [CRC32](http://en.wikipedia.org/wiki/Cyclic_redundancy_check) (well, kind of hash)

#####Cipher
- [AES-128, AES-192, AES-256](http://csrc.nist.gov/publications/fips/fips197/fips-197.pd8) (encrypt only)
- [ChaCha20](http://cr.yp.to/chacha/chacha-20080128.pdf)

#####Message authenticators
- [Poly1305](http://cr.yp.to/mac/poly1305-20050329.pdf)

#####Cipher block mode
- Cipher-block chaining ([CBC](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29))
- Cipher feedback ([CFB](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_feedback_.28CFB.29))

#####Data padding
- [PKCS#7](http://tools.ietf.org/html/rfc5652#section-6.3)

###Why
[Why?](https://github.com/krzyzanowskim/CryptoSwift/issues/5) [Because I can](https://github.com/krzyzanowskim/CryptoSwift/issues/5#issuecomment-53379391).

##Installation

To install CryptoSwift, add it as a submodule to your project (on the top level project directory):

	git submodule add git@github.com:krzyzanowskim/CryptoSwift.git

Then, drag the CryptoSwift.xcodeproj file into your Xcode project, and add CryptoSwift.framework as a dependency for your target.

#####iOS and OSX
Bu default project is setup for iOS. You need to switch to OSX SDK manually [see #8](https://github.com/krzyzanowskim/CryptoSwift/issues/8)

##Usage

    import CryptoSwift

Generally you should use `CryptoSwift.Hash`,`CryptoSwift.Cipher` enums or convenience extensions

Hash enum usage
    
    /* Hash enum usage */
    var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
    if let data = CryptoSwift.Hash.md5(data).calculate() {
        println(data.hexString)
    }
    
Hashing a data
	
	let hash = data.md5()
	let hash = data.sha1()
    let hash = data.sha224()
	let hash = data.sha256()
	let hash = data.sha384()
	let hash = data.sha512()
	
	let crc = data.crc32()
	
	println(hash.hexString)
	
Hashing a String and printing result

    if let hash = "123".md5() {
        println(hash)
    }
    
Working with Ciphers

	// convenience setup tuple
	let setup = (key: keyData, iv: ivData)
	
	// ENCRYPT
	let aesEncrypted = Cipher.AES(setup).encrypte(dataToEncrypt)
	let chacha20Encrypted = Cipher.ChaCha20(setup).encrypt(dataToEncrypt)
	
	// AES setup with CBC block mode and data padding
	let aes = AES(key: keyData, iv: ivData, blockMode: .CBC, paddingMode: .PKCS_7)
	let aesEncrypted = aes.encrypt(dataToEncrypt)
	
	// DECRYPT
	let decryptedChaCha20 = Cipher.ChaCha20(setup).decrypt(encryptedData)
	let decryptedAES = Cipher.AES(setup).decrypt(encryptedData)
	

using extensions
	
	// convenience setup tuple
	let setup = (key: keyData, iv: ivData)

	let encrypted = dataToEncrypt.encrypt(Cipher.ChaCha20(setup))
	let decrypted = encrypted.decrypt(Cipher.ChaCha20(setup))
	
Message authenticators

	// Calculate Message Authentication Code (MAC) for message
	let mac = Authenticator.Poly1305(key: key).authenticate(message)
    
##Contact
Marcin Krzyżanowski [@krzyzanowskim](http://twitter.com/krzyzanowskim)

##Licence

Copyright (C) 2014 Marcin Krzyżanowski <marcin.krzyzanowski@gmail.com>
This software is provided 'as-is', without any express or implied warranty. 

In no event will the authors be held liable for any damages arising from the use of this software. 

Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

- The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
- Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
- This notice may not be removed or altered from any source or binary distribution.
