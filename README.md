[![Platform](https://img.shields.io/badge/Platforms-ios%20%7C%20macos%20%7C%20watchos%20%7C%20tvos%20%7C%20linux-4E4E4E.svg?colorA=EF5138)](http://cocoadocs.org/docsets/CryptoSwift)
[![Swift support](https://img.shields.io/badge/Swift-3.1%20%7C%203.2%20%7C%204.0-lightgrey.svg?colorA=EF5138&colorB=4E4E4E)](#swift-versions-support)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CryptoSwift.svg?style=flat&label=CocoaPods)](https://cocoapods.org/pods/CryptoSwift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorB=64A5DE)](https://github.com/apple/swift-package-manager)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorB=64A5DE)](https://github.com/apple/swift-package-manager)
[![Twitter](https://img.shields.io/badge/twitter-@krzyzanowskim-blue.svg?style=flat&colorB=64A5DE&label=Twitter)](http://twitter.com/krzyzanowskim)

# CryptoSwift

Crypto related functions and helpers for [Swift](https://swift.org) implemented in Swift. ([#PureSwift](https://twitter.com/hashtag/pureswift)) 

# Table of Contents
- [Requirements](#requirements)
- [Features](#features)
- [Contribution](#contribution)
- [Installation](#installation)
- [Swift versions](#swift-versions-support)
- [Usage](#usage)
- [Author](#author)
- [License](#license)
- [Changelog](#changelog)

## Requirements
Good mood

## Features

- Easy to use
- Convenient extensions for String and Data
- Support for incremental updates (stream, ...)
- iOS, macOS, AppleTV, watchOS, Linux support

#### Hash (Digest)
- [MD5](http://tools.ietf.org/html/rfc1321)
- [SHA1](http://tools.ietf.org/html/rfc3174)
- [SHA224](http://tools.ietf.org/html/rfc6234)
- [SHA256](http://tools.ietf.org/html/rfc6234)
- [SHA384](http://tools.ietf.org/html/rfc6234)
- [SHA512](http://tools.ietf.org/html/rfc6234)
- [SHA3](http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf)

#### Cyclic Redundancy Check (CRC)
- [CRC32](http://en.wikipedia.org/wiki/Cyclic_redundancy_check)
- [CRC16](http://en.wikipedia.org/wiki/Cyclic_redundancy_check)

#### Cipher
- [AES-128, AES-192, AES-256](http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf)
- [ChaCha20](http://cr.yp.to/chacha/chacha-20080128.pdf)
- [Rabbit](https://tools.ietf.org/html/rfc4503)
- [Blowfish](https://www.schneier.com/academic/blowfish/)

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
- PKCS#5
- [PKCS#7](http://tools.ietf.org/html/rfc5652#section-6.3)
- [Zero padding](https://en.wikipedia.org/wiki/Padding_(cryptography)#Zero_padding)
- No padding

## Why
[Why?](https://github.com/krzyzanowskim/CryptoSwift/issues/5) [Because I can](https://github.com/krzyzanowskim/CryptoSwift/issues/5#issuecomment-53379391).

## Contribution

For the latest version, please check [develop](https://github.com/krzyzanowskim/CryptoSwift/tree/develop) branch. Changes from this branch will be merged into the [master](https://github.com/krzyzanowskim/CryptoSwift/tree/master) branch at some point.

- If you want to contribute, submit a [pull request](https://github.com/krzyzanowskim/CryptoSwift/pulls) against a development `develop` branch.
- If you found a bug, [open an issue](https://github.com/krzyzanowskim/CryptoSwift/issues).
- If you have a feature request, [open an issue](https://github.com/krzyzanowskim/CryptoSwift/issues).

## Installation

To install CryptoSwift, add it as a submodule to your project (on the top level project directory):

    git submodule add https://github.com/krzyzanowskim/CryptoSwift.git
    
It is recommended to enable [Whole-Module Optimization](https://swift.org/blog/whole-module-optimizations/) to gain better performance. Non-optimized build results in significantly worse performance.

#### Embedded Framework

Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9). Drag the `CryptoSwift.xcodeproj` file into your Xcode project, and add appropriate framework as a dependency to your target. Now select your App and choose the General tab for the app target. Find *Embedded Binaries* and press "+", then select `CryptoSwift.framework` (iOS, OS X, watchOS or tvOS)

![](https://cloud.githubusercontent.com/assets/758033/10834511/25a26852-7e9a-11e5-8c01-6cc8f1838459.png)

Sometimes "embedded framework" option is not available. In that case, you have to add new build phase for the target

![](https://cloud.githubusercontent.com/assets/758033/18415615/d5edabb0-77f8-11e6-8c94-f41d9fc2b8cb.png)

##### iOS, macOS, watchOS, tvOS

In the project, you'll find [single scheme](http://promisekit.org/news/2016/08/Multiplatform-Single-Scheme-Xcode-Projects/) for all platforms:
- CryptoSwift

#### Swift versions support

- Swift 1.2: branch [swift12](https://github.com/krzyzanowskim/CryptoSwift/tree/swift12) version <= 0.0.13
- Swift 2.1: branch [swift21](https://github.com/krzyzanowskim/CryptoSwift/tree/swift21) version <= 0.2.3
- Swift 2.2, 2.3: branch [swift2](https://github.com/krzyzanowskim/CryptoSwift/tree/swift2) version <= 0.5.2
- Swift 3.1, branch [swift3](https://github.com/krzyzanowskim/CryptoSwift/tree/swift3) version <= 0.6.9
- Swift 3.2, branch [swift32](https://github.com/krzyzanowskim/CryptoSwift/tree/swift32) version = 0.7.0
- Swift 4.0, branch [master](https://github.com/krzyzanowskim/CryptoSwift/tree/master) version >= 0.7.1

#### CocoaPods

You can use [CocoaPods](http://cocoapods.org/?q=cryptoSwift).

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'CryptoSwift'
end
```

or for newest version from specified branch of code:

```ruby
pod 'CryptoSwift', :git => "https://github.com/krzyzanowskim/CryptoSwift", :branch => "master"
```

Bear in mind that CocoaPods will build CryptoSwift without [Whole-Module Optimization](https://swift.org/blog/whole-module-optimizations/) that my impact performance. You can change it manually after installation, or use [cocoapods-wholemodule](https://github.com/jedlewison/cocoapods-wholemodule) plugin.

#### Carthage 
You can use [Carthage](https://github.com/Carthage/Carthage). 
Specify in Cartfile:

```ruby
github "krzyzanowskim/CryptoSwift"
```

Run `carthage` to build the framework and drag the built CryptoSwift.framework into your Xcode project. Follow [build instructions](https://github.com/Carthage/Carthage#getting-started). [Common issues](https://github.com/krzyzanowskim/CryptoSwift/issues/492#issuecomment-330822874).

#### Swift Package Manager

You can use [Swift Package Manager](https://swift.org/package-manager/) and specify dependency in `Package.swift` by adding this:

```swift
dependencies: [
    .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0)
]
```

or more strict

```swift
dependencies: [
    .Package(url: "ttps://github.com/krzyzanowskim/CryptoSwift.git", "0.7.2"),
]
```

See: [Package.swift - manual](http://blog.krzyzanowskim.com/2016/08/09/package-swift-manual/)
 
## Usage

* [Basics (data types, conversion, ...)](#basics)
* [Digest (MD5, SHA...)](#calculate-digest)
* [Message authenticators (HMAC...)](#message-authenticators-1)
* [Password-Based Key Derivation Function (PBKDF2, ...)](#password-based-key-derivation-functions)
* [Data Padding](#data-padding)
* [ChaCha20](#chacha20)
* [Rabbit](#rabbit)
* [Blowfish](#blowfish)
* [Advanced Encryption Standard (AES)](#aes)


also check [Playground](/CryptoSwift.playground/Contents.swift)

##### Basics

```swift
import CryptoSwift
```

CryptoSwift uses array of bytes aka `Array<UInt8>` as a base type for all operations. Every data may be converted to a stream of bytes. You will find convenience functions that accept String or NSData, and it will be internally converted to the array of bytes.

##### Data types conversion

For you convenience **CryptoSwift** provides two functions to easily convert array of bytes to NSData and another way around:

Data from bytes:

```swift
let data = Data(bytes: [0x01, 0x02, 0x03])
```

`Data` to `Array<UInt8>`

```swift
let bytes = data.bytes                     // [1,2,3]
```

[Hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) encoding:

```swift
let bytes = Array<UInt8>(hex: "0x010203")  // [1,2,3]
let hex   = bytes.toHexString()            // "010203"
```

Build bytes out of `String`
```swift
let bytes = Array("string".utf8)
```

Also... check out helpers that work with **Base64** encoded data:
```swift
"aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs=".decryptBase64ToString(cipher)
"aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs=".decryptBase64(cipher)
bytes.toBase64()
```

##### Calculate Digest

Hashing a data or array of bytes (aka `Array<UInt8>`)
```swift
/* Hash struct usage */
let bytes:Array<UInt8> = [0x01, 0x02, 0x03]
let digest = input.md5()
let digest = Digest.md5(bytes)
```

```swift
let data = Data(bytes: [0x01, 0x02, 0x03])

let hash = data.md5()
let hash = data.sha1()
let hash = data.sha224()
let hash = data.sha256()
let hash = data.sha384()
let hash = data.sha512()    
```
```swift
do {
    var digest = MD5()
    let partial1 = try digest.update(withBytes: [0x31, 0x32])
    let partial2 = try digest.update(withBytes: [0x33])
    let result = try digest.finish()
} catch { }
```
    
Hashing a String and printing result

```swift
let hash = "123".md5()
```

##### Calculate CRC

```swift
bytes.crc16()
data.crc16()

bytes.crc32()
data.crc32()
```

##### Message authenticators

```swift
// Calculate Message Authentication Code (MAC) for message
let key:Array<UInt8> = [1,2,3,4,5,6,7,8,9,10,...]

try Poly1305(key: key).authenticate(bytes)
try HMAC(key: key, variant: .sha256).authenticate(bytes)
```

##### Password-Based Key Derivation Functions

```swift
let password: Array<UInt8> = Array("s33krit".utf8)
let salt: Array<UInt8> = Array("nacllcan".utf8)

try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate()
```

##### Data Padding
    
Some content-encryption algorithms assume the input length is a multiple of `k` octets, where `k` is greater than one. For such algorithms, the input shall be padded.

```swift
Padding.pkcs7.add(to: bytes, blockSize: AES.blockSize)
```

#### Working with Ciphers
##### ChaCha20

```swift
let encrypted = try ChaCha20(key: key, iv: iv).encrypt(message)
let decrypted = try ChaCha20(key: key, iv: iv).decrypt(encrypted)
```

##### Rabbit

```swift
let encrypted = try Rabbit(key: key, iv: iv).encrypt(message)
let decrypted = try Rabbit(key: key, iv: iv).decrypt(encrypted)
```
##### Blowfish

```swift
let encrypted = try Blowfish(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).encrypt(message)
let decrypted = try Blowfish(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).decrypt(encrypted)
```

##### AES

Notice regarding padding: *Manual padding of data is optional, and CryptoSwift is using PKCS7 padding by default. If you need manually disable/enable padding, you can do this by setting parameter for __AES__ class*

Variant of AES encryption (AES-128, AES-192, AES-256) depends on given key length:

- AES-128 = 16 bytes
- AES-192 = 24 bytes
- AES-256 = 32 bytes

AES-256 example
```swift
try AES(key: [1,2,3,...,32], iv: [1,2,3,...,16], blockMode: .CBC, padding: .pkcs7)
```
 
###### All at once
```swift
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap") // aes128
    let ciphertext = try aes.encrypt(Array("Nullam quis risus eget urna mollis ornare vel eu leo.".utf8))
} catch { }
```

###### Incremental updates

Incremental operations use instance of Cryptor and encrypt/decrypt one part at a time, this way you can save on memory for large files. 

```swift
do {
    var encryptor = try AES(key: "passwordpassword", iv: "drowssapdrowssap").makeEncryptor()

    var ciphertext = Array<UInt8>()
    // aggregate partial results
    ciphertext += try encryptor.update(withBytes: Array("Nullam quis risus ".utf8))
    ciphertext += try encryptor.update(withBytes: Array("eget urna mollis ".utf8))
    ciphertext += try encryptor.update(withBytes: Array("ornare vel eu leo.".utf8))
    // finish at the end
    ciphertext += try encryptor.finish()

    print(ciphertext.toHexString())
} catch {
    print(error)
}
```

See [Playground](/CryptoSwift.playground/Contents.swift) for sample code that work with stream.

###### AES Advanced usage
```swift
let input: Array<UInt8> = [0,1,2,3,4,5,6,7,8,9]

let key: Array<UInt8> = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
let iv: Array<UInt8> = AES.randomIV(AES.blockSize)

do {
    let encrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).encrypt(input)
    let decrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).decrypt(encrypted)
} catch {
    print(error)
}    
```
    
AES without data padding

```swift
let input: Array<UInt8> = [0,1,2,3,4,5,6,7,8,9]
let encrypted: Array<UInt8> = try! AES(key: "secret0key000000", iv:"0123456789012345", blockMode: .CBC, padding: .noPadding).encrypt(input)
```

Using convenience extensions
    
```swift
let plain = Data(bytes: [0x01, 0x02, 0x03])
let encrypted = try! plain.encrypt(ChaCha20(key: key, iv: iv))
let decrypted = try! encrypted.decrypt(ChaCha20(key: key, iv: iv))
```

## Author

CryptoSwift is owned and maintained by [Marcin Krzyżanowski](http://www.krzyzanowskim.com)

You can follow me on Twitter at [@krzyzanowskim](http://twitter.com/krzyzanowskim) for project updates and releases.

## License

Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
This software is provided 'as-is', without any express or implied warranty. 

In no event will the authors be held liable for any damages arising from the use of this software. 

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

- The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, **an acknowledgment in the product documentation is required**.
- Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
- This notice may not be removed or altered from any source or binary distribution.

## Changelog

See [CHANGELOG](./CHANGELOG) file.
