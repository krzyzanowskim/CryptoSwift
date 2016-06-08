#CryptoSwift

Crypto related functions and helpers for [Swift](https://developer.apple.com/swift/) implemented in Swift. ([#PureSwift](https://twitter.com/hashtag/pureswift))

#Table of Contents
- [Requirements](#requirements)
- [Features](#features)
- [Contribution](#contribution)
- [Installation](#installation)
- [Usage](#usage)
- [Author](#author)
- [License](#license)
- [Changelog](#changelog)

##Requirements
Good mood

##Features

- Easy to use
- Convenient extensions for String and NSData
- iOS, OSX, AppleTV, watchOS, Linux support

#### Hash (Digest)
- [MD5](http://tools.ietf.org/html/rfc1321)
- [SHA1](http://tools.ietf.org/html/rfc3174)
- [SHA224](http://tools.ietf.org/html/rfc6234)
- [SHA256](http://tools.ietf.org/html/rfc6234)
- [SHA384](http://tools.ietf.org/html/rfc6234)
- [SHA512](http://tools.ietf.org/html/rfc6234)

#### Cyclic Redundancy Check (CRC)
- [CRC32](http://en.wikipedia.org/wiki/Cyclic_redundancy_check)
- [CRC16](http://en.wikipedia.org/wiki/Cyclic_redundancy_check)

#### Cipher
- [AES-128, AES-192, AES-256](http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf)
- [ChaCha20](http://cr.yp.to/chacha/chacha-20080128.pdf)
- [Rabbit](https://tools.ietf.org/html/rfc4503)

#### Message authenticators
- [Poly1305](http://cr.yp.to/mac/poly1305-20050329.pdf)
- [HMAC](https://www.ietf.org/rfc/rfc2104.txt) MD5, SHA1, SHA256

#### Cipher block mode
- Electronic codebook ([ECB](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_codebook_.28ECB.29))
- Cipher-block chaining ([CBC](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29))
- Propagating Cipher Block Chaining ([PCBC](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Propagating_Cipher_Block_Chaining_.28PCBC.29))
- Cipher feedback ([CFB](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_feedback_.28CFB.29))
- Output Feedback ([OFB](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Output_Feedback_.28OFB.29))
- Counter ([CTR](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_.28CTR.29))

#### Password-Based Key Derivation Function
- [PBKDF1](http://tools.ietf.org/html/rfc2898#section-5.1) (Password-Based Key Derivation Function 1)
- [PBKDF2](http://tools.ietf.org/html/rfc2898#section-5.2) (Password-Based Key Derivation Function 2)

#### Data padding
- [PKCS#7](http://tools.ietf.org/html/rfc5652#section-6.3)
- NoPadding

##Why
[Why?](https://github.com/krzyzanowskim/CryptoSwift/issues/5) [Because I can](https://github.com/krzyzanowskim/CryptoSwift/issues/5#issuecomment-53379391).

##Contribution

For latest version, please check **develop** branch. This is latest development version that will be merged into **master** branch at some point.

- If you want to contribute, submit a [pull request](https://github.com/krzyzanowskim/CryptoSwift/pulls) against a development `develop` branch.
- If you found a bug, [open an issue](https://github.com/krzyzanowskim/CryptoSwift/issues).
- If you have a feature request, [open an issue](https://github.com/krzyzanowskim/CryptoSwift/issues).

##Installation

To install CryptoSwift, add it as a submodule to your project (on the top level project directory):

	git submodule add https://github.com/krzyzanowskim/CryptoSwift.git

####Embedded Framework

Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9). Drag the `CryptoSwift.xcodeproj` file into your Xcode project, and add appropriate framework as a dependency to your target. Now select your App and choose the General tab for the app target. Find *Embedded Binaries* and press "+", then select `CryptoSwift.framework` (iOS, OS X, watchOS or tvOS)

![](https://cloud.githubusercontent.com/assets/758033/10834511/25a26852-7e9a-11e5-8c01-6cc8f1838459.png)



#####iOS, OSX, watchOS, tvOS

In the project, you'll find three targets, configured for each supported SDK:
- CryptoSwift iOS
- CryptoSwift OSX
- CryptoSwift watchOS
- CryptoSwift tvOS

You may need to choose the one you need to build `CryptoSwift.framework` for your application.

####Older Swift

- Swift 1.2: branch [swift12](https://github.com/krzyzanowskim/CryptoSwift/tree/swift12).
- Swift 2.1: branch [swift21](https://github.com/krzyzanowskim/CryptoSwift/tree/swift21)

####CocoaPods

You can use [CocoaPods](http://cocoapods.org/?q=cryptoSwift).

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'CryptoSwift'
```

or for newest version from specified branch of code:

```ruby
pod 'CryptoSwift', :git => "https://github.com/krzyzanowskim/CryptoSwift", :branch => "master"
```

####Carthage 
You can use [Carthage](https://github.com/Carthage/Carthage). 
Specify in Cartfile:

```ruby
github "krzyzanowskim/CryptoSwift"
```

Run carthage to build the framework and drag the built CryptoSwift.framework into your Xcode project. Follow [build instructions](https://github.com/Carthage/Carthage#getting-started)

####Swift Package Manager

You can use [Swift Package Manager](https://swift.org/package-manager/) and specify dependency in `Package.swift` by adding this:
```
.Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0)
```
 
##Usage

* [Basics (data types, conversion, ...)](#basics)
* [Calculate Hash (MD5, SHA...)](#calculate-hash)
* [Message authenticators (HMAC...)](#message-authenticators)
* [Password-Based Key Derivation Function (PBKDF2, ...)](password-based-key-derivation-function)
* [Data Padding](#data-padding)
* [ChaCha20](#chacha20)
* [Rabbit](#rabbit)
* [Advanced Encryption Standard (AES)](#aes)


also check [Playground](/CryptoSwift.playground/Contents.swift)

#####Basics

```swift
import CryptoSwift
```

CryptoSwift use array of bytes aka `Array<UInt8>` as base type for all operations. Every data can be converted to stream of bytes. you will find convenience functions that accept String or NSData, and it will be internally converted to array of bytes anyway.

#####Data conversions

For you convenience CryptoSwift provide two function to easily convert array of bytes to NSData and other way around:

```swift
let data: NSData = NSData(bytes: [0x01, 0x02, 0x03])
let bytes:[UInt8] = data.arrayOfBytes()
```

Make bytes out of `String`:
```swift
let bytes = "string".utf8.map({$0})
```

#####Calculate Hash

Hashing a data or array of bytes (aka `Array<UInt8>`)
```swift
/* Hash enum usage */
let input:[UInt8] = [49, 50, 51]

let output = input.md5()
// alternatively: let output = CryptoSwift.Hash.md5(input).calculate()

print(output.toHexString())
```

```swift
let data = NSData()

let hash = data.md5()
let hash = data.sha1()
let hash = data.sha224()
let hash = data.sha256()
let hash = data.sha384()
let hash = data.sha512()
	
let crc32 = data.crc32()
let crc16 = data.crc16()

print(hash.toHexString())
```
	
Hashing a String and printing result

```swift
let hash = "123".md5()
```

#####Message authenticators

```swift
// Calculate Message Authentication Code (MAC) for message
let mac: [UInt8] = try! Authenticator.Poly1305(key: key).authenticate(message)
let hmac: [UInt8] = try! Authenticator.HMAC(key: key, variant: .sha256).authenticate(message)
```

#####Password-Based Key Derivation Function

```swift
let password: [UInt8] = "s33krit".utf8.map {$0}
let salt: [UInt8] = "nacl".utf8.map {$0}

let value = try! PKCS5.PBKDF1(password: password, salt: salt, iterations: 4096, variant: .sha1).calculate()

let value = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate()

value.toHexString() // print Hex representation
```

#####Data Padding
    
Some content-encryption algorithms assume the input length is a multiple of k octets, where k is greater than one. For such algorithms, the input shall be padded.

```swift
let paddedData = PKCS7().add(arr, blockSize: AES.blockSize)
```

####Working with Ciphers
#####ChaCha20

```swift
let encrypted: [UInt8] = ChaCha20(key: key, iv: iv).encrypt(message)
let decrypted: [UInt8] = ChaCha20(key: key, iv: iv).decrypt(encrypted)
```

#####Rabbit

```swift
let encrypted = Rabbit(key: key, iv: iv)?.encrypt(plaintext)
let decrypted = Rabbit(key: key, iv: iv)?.decrypt(encrypted!)
```

#####AES

Notice regarding padding: *Manual padding of data is optional and CryptoSwift is using PKCS7 padding by default. If you need manually disable/enable padding, you can do this by setting parameter for __AES__ class*

######All at once
```swift
let input = NSData()
let encrypted = try! input.encrypt(AES(key: "secret0key000000", iv:"0123456789012345"))

let input: [UInt8] = [0,1,2,3,4,5,6,7,8,9]
input.encrypt(AES(key: "secret0key000000", iv:"0123456789012345", blockMode: .CBC))
```

######Incremental updates

Incremental operations uses instance of Cryptor and encrypt/decrypt one part at time, this way you can save on memory for large files. 

```swift
let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap")
var encryptor = aes.makeEncryptor()

var ciphertext = Array<UInt8>()
ciphertext += try encryptor.update(withBytes: "Nullam quis risus ".utf8.map({$0}))
ciphertext += try encryptor.update(withBytes: "eget urna mollis ".utf8.map({$0}))
ciphertext += try encryptor.update(withBytes: "ornare vel eu leo.".utf8.map({$0}))
ciphertext += try encryptor.finish()
```

See [Playground](/CryptoSwift.playground/Contents.swift) for sample code to work with streams.

Check this helper functions to work with **Base64** encoded data directly:
- .decryptBase64ToString()
- .toBase64()

######AES Advanced usage
```swift
let input: [UInt8] = [0,1,2,3,4,5,6,7,8,9]

let key: [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
let iv: [UInt8] = AES.randomIV(AES.blockSize)

do {
    let encrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(input)
    let decrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(encrypted)
} catch {
	print(error)
}	
```
	
AES without data padding

```swift
let input: [UInt8] = [0,1,2,3,4,5,6,7,8,9]
let encrypted: [UInt8] = try! AES(key: "secret0key000000", iv:"0123456789012345", blockMode: .CBC, padding: NoPadding()).encrypt(input)
```

Using convenience extensions
	
```swift
let plain = NSData()
let encrypted: NSData = try! plain.encrypt(ChaCha20(key: key, iv: iv))
let decrypted: NSData = try! encrypted.decrypt(ChaCha20(key: key, iv: iv))
// plain == decrypted
```

##Author

CryptoSwift is owned and maintained by [Marcin Krzyżanowski](http://www.krzyzanowskim.com)

You can follow me on Twitter at [@krzyzanowskim](http://twitter.com/krzyzanowskim) for project updates and releases.

##License

Copyright (C) 2014-2016 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
This software is provided 'as-is', without any express or implied warranty. 

In no event will the authors be held liable for any damages arising from the use of this software. 

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

- The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, **an acknowledgment in the product documentation is required**.
- Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
- This notice may not be removed or altered from any source or binary distribution.

##Changelog

See [CHANGELOG](./CHANGELOG) file.
