#CryptoSwift
Crypto related functions and helpers for [Swift](https://developer.apple.com/swift/) implemented in Swift. ([#PureSwift](https://twitter.com/hashtag/pureswift))

##Requirements
Good mood

##Features

- Easy to use
- Convenience extensions

####what implemented?

#### Hash
- MD5
- SHA1
- SHA224
- SHA256
- SHA384
- SHA512
- CRC32 (well, kind of hash)

#####Cipher
- ChaCha20

####[Why?](https://github.com/krzyzanowskim/CryptoSwift/issues/5)

[Because I can](https://github.com/krzyzanowskim/CryptoSwift/issues/5#issuecomment-53379391)

##Usage

Generally you should use `CryptoSwift.Hash`,`CryptoSwift.Cipher` enums or convenience extensions

CryptoHash enum usage

    import CryptoSwift
    
    /* Hash enum usage */
    var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
    if let data = CryptoSwift.Hash.md5.calculate(data) {
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
    
##Contact
Marcin Krzyżanowski [@krzyzanowskim](http://twitter.com/krzyzanowskim)

##Licence
see LICENSE file
