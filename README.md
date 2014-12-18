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
- [ChaCha20](http://cr.yp.to/chacha/chacha-20080128.pdf)

#####Message authenticators
- [Poly1305](http://cr.yp.to/mac/poly1305-20050329.pdf)

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
    
Working with Cipher

	// convenience setup tuple
	let setup = (key: keyData, iv: ivData)
	
	// encrypt
	if let encrypted = Cipher.ChaCha20(setup).encrypt(dataToEncrypt) {
	
	    // decrypt
	    if let decrypted = Cipher.ChaCha20(setup).decrypt(encrypted) {
	    
	        // validate result
	        if (encrypted.isEqual(decrypted)) {
		        print("Decryption failed!")
	        }
	        
	    }
	}
	

with extensions
	
	// convenience setup tuple
	let setup = (key: keyData, iv: ivData)

	if let encrypted = dataToEncrypt.encrypt(Cipher.ChaCha20(setup)) {
		if let decrypted = encrypted.decrypt(Cipher.ChaCha20(setup)) {
			println(decrypted)
		}
	}
	
Message authenticators

	// Calculate Message Authentication Code (MAC) for message
	let mac = Authenticator.Poly1305(key: key).authenticate(message)
    
##Contact
Marcin Krzyżanowski [@krzyzanowskim](http://twitter.com/krzyzanowskim)

##Licence
see LICENSE file
