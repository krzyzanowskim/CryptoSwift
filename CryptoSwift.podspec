Pod::Spec.new do |s|
  s.name         = "CryptoSwift"
  s.version      = "0.13.0"
  s.source       = { :git => "https://github.com/krzyzanowskim/CryptoSwift.git", :tag => "#{s.version}" }
  s.summary      = "Cryptography in Swift. SHA, MD5, CRC, PBKDF, Poly1305, HMAC, CMAC, HDKF, ChaCha20, Rabbit, Blowfish, AES."
  s.description  = "Cryptography functions and helpers for Swift implemented in Swift. SHA-1, SHA-2, SHA-3, MD5, PBKDF1, PBKDF2, CRC, Poly1305, HMAC, ChaCha20, Rabbit, Blowfish, AES"
  s.homepage     = "https://github.com/krzyzanowskim/CryptoSwift"
  s.license      = {:type => "Attribution", :file => "LICENSE"}
  s.authors      = {'Marcin Krzyżanowski' => 'marcin@krzyzanowskim.com'}
  s.social_media_url   = "https://twitter.com/krzyzanowskim"
  s.cocoapods_version = '>= 1.4.0'
  s.swift_version = "4.2"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source_files  = "Sources/CryptoSwift/**/*.swift"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_OPTIMIZATION_LEVEL' => '-O', 'SWIFT_COMPILATION_MODE' => 'wholemodule', 'SWIFT_DISABLE_SAFETY_CHECKS' => 'YES', 'SWIFT_ENFORCE_EXCLUSIVE_ACCESS' => 'compile-time', 'GCC_UNROLL_LOOPS' => 'YES'}
end
