Pod::Spec.new do |s|
  s.name         = "CryptoSwift"
  s.version      = "0.4.1"
  s.summary      = "Cryptography in Swift. SHA, MD5, CRC, Poly1305, HMAC, ChaCha20, Rabbit, AES."
  s.description  = "Cryptography functions and helpers for Swift implemented in Swift. SHA, MD5, PBKDF2, CRC, Poly1305, HMAC, ChaCha20, Rabbit, AES."
  s.homepage     = "https://github.com/krzyzanowskim/CryptoSwift"
  s.license      = {:type => "Attribution License", :file => "LICENSE"}
  s.source       = { :git => "https://github.com/krzyzanowskim/CryptoSwift.git", :tag => "#{s.version}" }
  s.authors      = {'Marcin Krzyżanowski' => 'marcin@krzyzanowskim.com'}
  s.social_media_url   = "https://twitter.com/krzyzanowskim"
  s.ios.platform  = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.osx.platform  = :osx, '10.9'
  s.osx.deployment_target = "10.9"
  s.watchos.platform = :watchos, '2.0'
  s.watchos.deployment_target = "2.0"
  s.tvos.platform = :tvos, '9.0'
  s.tvos.deployment_target = "9.0"
  s.source_files  = "Sources/CryptoSwift/**/*.swift"
  s.requires_arc = true
end
