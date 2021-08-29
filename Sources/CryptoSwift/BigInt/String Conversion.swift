//
//  String Conversion.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension BigUInt {

    //MARK: String Conversion

    /// Calculates the number of numerals in a given radix that fit inside a single `Word`.
    ///
    /// - Returns: (chars, power) where `chars` is highest that satisfy `radix^chars <= 2^Word.bitWidth`. `power` is zero
    ///   if radix is a power of two; otherwise `power == radix^chars`.
    fileprivate static func charsPerWord(forRadix radix: Int) -> (chars: Int, power: Word) {
        var power: Word = 1
        var overflow = false
        var count = 0
        while !overflow {
            let (p, o) = power.multipliedReportingOverflow(by: Word(radix))
            overflow = o
            if !o || p == 0 {
                count += 1
                power = p
            }
        }
        return (count, power)
    }

    /// Initialize a big integer from an ASCII representation in a given radix. Numerals above `9` are represented by
    /// letters from the English alphabet.
    ///
    /// - Requires: `radix > 1 && radix < 36`
    /// - Parameter `text`: A string consisting of characters corresponding to numerals in the given radix. (0-9, a-z, A-Z)
    /// - Parameter `radix`: The base of the number system to use, or 10 if unspecified.
    /// - Returns: The integer represented by `text`, or nil if `text` contains a character that does not represent a numeral in `radix`.
    public init?<S: StringProtocol>(_ text: S, radix: Int = 10) {
        precondition(radix > 1)
        let (charsPerWord, power) = BigUInt.charsPerWord(forRadix: radix)

        var words: [Word] = []
        var end = text.endIndex
        var start = end
        var count = 0
        while start != text.startIndex {
            start = text.index(before: start)
            count += 1
            if count == charsPerWord {
                guard let d = Word.init(text[start ..< end], radix: radix) else { return nil }
                words.append(d)
                end = start
                count = 0
            }
        }
        if start != end {
            guard let d = Word.init(text[start ..< end], radix: radix) else { return nil }
            words.append(d)
        }

        if power == 0 {
            self.init(words: words)
        }
        else {
            self.init()
            for d in words.reversed() {
                self.multiply(byWord: power)
                self.addWord(d)
            }
        }
    }
}

extension BigInt {
    /// Initialize a big integer from an ASCII representation in a given radix. Numerals above `9` are represented by
    /// letters from the English alphabet.
    ///
    /// - Requires: `radix > 1 && radix < 36`
    /// - Parameter `text`: A string optionally starting with "-" or "+" followed by characters corresponding to numerals in the given radix. (0-9, a-z, A-Z)
    /// - Parameter `radix`: The base of the number system to use, or 10 if unspecified.
    /// - Returns: The integer represented by `text`, or nil if `text` contains a character that does not represent a numeral in `radix`.
    public init?<S: StringProtocol>(_ text: S, radix: Int = 10) {
        var magnitude: BigUInt?
        var sign: Sign = .plus
        if text.first == "-" {
            sign = .minus
            let text = text.dropFirst()
            magnitude = BigUInt(text, radix: radix)
        }
        else if text.first == "+" {
            let text = text.dropFirst()
            magnitude = BigUInt(text, radix: radix)
        }
        else {
            magnitude = BigUInt(text, radix: radix)
        }
        guard let m = magnitude else { return nil }
        self.magnitude = m
        self.sign = sign
    }
}

extension String {
    /// Initialize a new string with the base-10 representation of an unsigned big integer.
    ///
    /// - Complexity: O(v.count^2)
    public init(_ v: BigUInt) { self.init(v, radix: 10, uppercase: false) }

    /// Initialize a new string representing an unsigned big integer in the given radix (base).
    ///
    /// Numerals greater than 9 are represented as letters from the English alphabet,
    /// starting with `a` if `uppercase` is false or `A` otherwise.
    ///
    /// - Requires: radix > 1 && radix <= 36
    /// - Complexity: O(count) when radix is a power of two; otherwise O(count^2).
    public init(_ v: BigUInt, radix: Int, uppercase: Bool = false) {
        precondition(radix > 1)
        let (charsPerWord, power) = BigUInt.charsPerWord(forRadix: radix)

        guard !v.isZero else { self = "0"; return }

        var parts: [String]
        if power == 0 {
            parts = v.words.map { String($0, radix: radix, uppercase: uppercase) }
        }
        else {
            parts = []
            var rest = v
            while !rest.isZero {
                let mod = rest.divide(byWord: power)
                parts.append(String(mod, radix: radix, uppercase: uppercase))
            }
        }
        assert(!parts.isEmpty)

        self = ""
        var first = true
        for part in parts.reversed() {
            let zeroes = charsPerWord - part.count
            assert(zeroes >= 0)
            if !first && zeroes > 0 {
                // Insert leading zeroes for mid-Words
                self += String(repeating: "0", count: zeroes)
            }
            first = false
            self += part
        }
    }

    /// Initialize a new string representing a signed big integer in the given radix (base).
    ///
    /// Numerals greater than 9 are represented as letters from the English alphabet,
    /// starting with `a` if `uppercase` is false or `A` otherwise.
    ///
    /// - Requires: radix > 1 && radix <= 36
    /// - Complexity: O(count) when radix is a power of two; otherwise O(count^2).
    public init(_ value: BigInt, radix: Int = 10, uppercase: Bool = false) {
        self = String(value.magnitude, radix: radix, uppercase: uppercase)
        if value.sign == .minus {
            self = "-" + self
        }
    }
}

extension BigUInt: ExpressibleByStringLiteral {
    /// Initialize a new big integer from a Unicode scalar.
    /// The scalar must represent a decimal digit.
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self = BigUInt(String(value), radix: 10)!
    }

    /// Initialize a new big integer from an extended grapheme cluster.
    /// The cluster must consist of a decimal digit.
    public init(extendedGraphemeClusterLiteral value: String) {
        self = BigUInt(value, radix: 10)!
    }

    /// Initialize a new big integer from a decimal number represented by a string literal of arbitrary length.
    /// The string must contain only decimal digits.
    public init(stringLiteral value: StringLiteralType) {
        self = BigUInt(value, radix: 10)!
    }
}

extension BigInt: ExpressibleByStringLiteral {
    /// Initialize a new big integer from a Unicode scalar.
    /// The scalar must represent a decimal digit.
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self = BigInt(String(value), radix: 10)!
    }

    /// Initialize a new big integer from an extended grapheme cluster.
    /// The cluster must consist of a decimal digit.
    public init(extendedGraphemeClusterLiteral value: String) {
        self = BigInt(value, radix: 10)!
    }

    /// Initialize a new big integer from a decimal number represented by a string literal of arbitrary length.
    /// The string must contain only decimal digits.
    public init(stringLiteral value: StringLiteralType) {
        self = BigInt(value, radix: 10)!
    }
}

extension BigUInt: CustomStringConvertible {
    /// Return the decimal representation of this integer.
    public var description: String {
        return String(self, radix: 10)
    }
}

extension BigInt: CustomStringConvertible {
    /// Return the decimal representation of this integer.
    public var description: String {
        return String(self, radix: 10)
    }
}

extension BigUInt: CustomPlaygroundDisplayConvertible {

    /// Return the playground quick look representation of this integer.
    public var playgroundDescription: Any {
        let text = String(self)
        return text + " (\(self.bitWidth) bits)"
    }
}

extension BigInt: CustomPlaygroundDisplayConvertible {

    /// Return the playground quick look representation of this integer.
    public var playgroundDescription: Any {
        let text = String(self)
        return text + " (\(self.magnitude.bitWidth) bits)"
    }
}
