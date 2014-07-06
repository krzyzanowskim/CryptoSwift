#CryptoSwift

Crypto related helpers for Swift.

##Requirements
For now CryptoSwift depends on OpenSSL


##Usage

	import CryptoSwift

    var data:NSData = NSData(bytes: [49, 50, 51] as Byte[], length: 3)
    let md5:NSData = CryptoHash.md5.hash(data)
    
	// Printout MD5 as String
    NSLog(md5.toHexString())

####Cocoapods

*Caution*: Podspec support for Swift is not yet ready, however some fixes has been made see: https://github.com/CocoaPods/CocoaPods/pull/2222

so... you need to do some manual work

1. Setup Podfile

```
    platform :ios, '7.0'
    link_with 'CryptoSwift', 'CryptoSwiftTests'
    pod 'OpenSSL-Universal'
```
2. Setup binding header:

Copy and header file [CryptoSwift-Bridging-Header.h](https://github.com/krzyzanowskim/CryptoSwift/blob/master/CryptoSwift-Bridging-Header.h) to you project and setup `Objective-C Bridging Header` in `Builds Settings` of you project with name of this header file.

Done.

