Pod::Spec.new do |s|
  s.name         = "CryptoSwift"
  s.version      = "0.0.3"
  s.summary      = "Cryptography in Swift"
  s.description  = "Cryptography functions and helpers for Swift implemented in Swift. SHA, MD5, CRC, AES, Poly1305, ChaCha20."
  s.homepage     = "https://github.com/krzyzanowskim/CryptoSwift"
  s.license      = {:type => "Attribution License", :file => "LICENSE"}
  s.source       = { :git => "https://github.com/krzyzanowskim/CryptoSwift.git", :tag => "#{s.version}" }
  s.authors      = {'Marcin Krzyżanowski' => 'marcin.krzyzanowski@hakore.com'}
  s.social_media_url   = "https://twitter.com/krzyzanowskim"
  s.ios.platform  = :ios, '8.0'
  s.osx.platform  = :osx, '10.9'
  s.source_files  = "CryptoSwift/*"
  s.requires_arc = true
end