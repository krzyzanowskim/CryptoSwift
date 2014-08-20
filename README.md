#CryptoSwift
Crypto related helpers for [Swift](https://developer.apple.com/swift/) implemented in Swift. ([#PureSwift](https://twitter.com/hashtag/pureswift))

##Requirements
Good mood

##Features

- Easy to use
- Convenience extensions

#####what implemented?
- MD5
- SHA1
- SHA256

##Usage

Generally you should use `CryptoHash` enum or convenience extensions

    import CryptoSwift
    
    /* CryptoHash enum usage */
    var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
    if let data = CryptoHash.md5.hash(data) {
        println(data.hexString)
    }
    
 direct or with helpers
	
	let hash = MD5(data).calculate()
	let hash = data.md5()
	let hash = data.sha1()
	let hash = data.sha256()
	
	println(hash.hexString)
	
straight from String

    /* Calculate hash for string with convenience extension */
    if let hash = "123".md5() {
        println(string.md5())
    }
    
##Contact
Marcin Krzyżanowski [@krzyzanowskim](http://twitter.com/krzyzanowskim)

##Licence
see LICENSE file