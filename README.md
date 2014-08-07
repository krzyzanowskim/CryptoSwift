#CryptoSwift

Crypto related helpers for Swift.

Since Xcode6-Beta5 frameworks can't bind to third-party libraries written in C/Objective-C so I decided drop OpenSSL dependency and now let's try build some stuff with Swift.

##Requirements
~~For now CryptoSwift depends on OpenSSL~~


##Usage

	import CryptoSwift

    var data:NSData = NSData(bytes: [49, 50, 51] as Byte[], length: 3)
    let md5data:NSData = CryptoHash.md5.hash(data)
    
	// Printout MD5 as String
    NSLog(md5data.hexString())
