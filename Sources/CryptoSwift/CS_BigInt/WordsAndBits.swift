//
//  WordsAndBits.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2017-08-11.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension Array where Element == UInt {
    mutating func twosComplement() {
        var increment = true
        for i in 0 ..< self.count {
            if increment {
                (self[i], increment) = (~self[i]).addingReportingOverflow(1)
            }
            else {
                self[i] = ~self[i]
            }
        }
    }
}

extension CS.BigUInt {
    public subscript(bitAt index: Int) -> Bool {
        get {
            precondition(index >= 0)
            let (i, j) = index.quotientAndRemainder(dividingBy: Word.bitWidth)
            return self[i] & (1 << j) != 0
        }
        set {
            precondition(index >= 0)
            let (i, j) = index.quotientAndRemainder(dividingBy: Word.bitWidth)
            if newValue {
                self[i] |= 1 << j
            }
            else {
                self[i] &= ~(1 << j)
            }
        }
    }
}

extension CS.BigUInt {
    /// The minimum number of bits required to represent this integer in binary.
    ///
    /// - Returns: floor(log2(2 * self + 1))
    /// - Complexity: O(1)
    public var bitWidth: Int {
        guard count > 0 else { return 0 }
        return count * Word.bitWidth - self[count - 1].leadingZeroBitCount
    }

    /// The number of leading zero bits in the binary representation of this integer in base `2^(Word.bitWidth)`.
    /// This is useful when you need to normalize a `BigUInt` such that the top bit of its most significant word is 1.
    ///
    /// - Note: 0 is considered to have zero leading zero bits.
    /// - Returns: A value in `0...(Word.bitWidth - 1)`.
    /// - SeeAlso: width
    /// - Complexity: O(1)
    public var leadingZeroBitCount: Int {
        guard count > 0 else { return 0 }
        return self[count - 1].leadingZeroBitCount
    }

    /// The number of trailing zero bits in the binary representation of this integer.
    ///
    /// - Note: 0 is considered to have zero trailing zero bits.
    /// - Returns: A value in `0...width`.
    /// - Complexity: O(count)
    public var trailingZeroBitCount: Int {
        guard count > 0 else { return 0 }
        let i = self.words.firstIndex { $0 != 0 }!
        return i * Word.bitWidth + self[i].trailingZeroBitCount
    }
}

extension CS.BigInt {
    public var bitWidth: Int {
        guard !magnitude.isZero else { return 0 }
        return magnitude.bitWidth + 1
    }

    public var trailingZeroBitCount: Int {
        // Amazingly, this works fine for negative numbers
        return magnitude.trailingZeroBitCount
    }
}

extension CS.BigUInt {
    public struct Words: RandomAccessCollection {
        private let value: CS.BigUInt

        fileprivate init(_ value: CS.BigUInt) { self.value = value }

        public var startIndex: Int { return 0 }
        public var endIndex: Int { return value.count }

        public subscript(_ index: Int) -> Word {
            return value[index]
        }
    }

    public var words: Words { return Words(self) }

    public init<Words: Sequence>(words: Words) where Words.Element == Word {
        let uc = words.underestimatedCount
        if uc > 2 {
            self.init(words: Array(words))
        }
        else {
            var it = words.makeIterator()
            guard let w0 = it.next() else {
                self.init()
                return
            }
            guard let w1 = it.next() else {
                self.init(word: w0)
                return
            }
            if let w2 = it.next() {
                var words: [UInt] = []
                words.reserveCapacity(Swift.max(3, uc))
                words.append(w0)
                words.append(w1)
                words.append(w2)
                while let word = it.next() {
                    words.append(word)
                }
                self.init(words: words)
            }
            else {
                self.init(low: w0, high: w1)
            }
        }
    }
}

extension CS.BigInt {
    public struct Words: RandomAccessCollection {
        public typealias Indices = CountableRange<Int>

        private let value: CS.BigInt
        private let decrementLimit: Int

        fileprivate init(_ value: CS.BigInt) {
            self.value = value
            switch value.sign {
            case .plus:
                self.decrementLimit = 0
            case .minus:
                assert(!value.magnitude.isZero)
                self.decrementLimit = value.magnitude.words.firstIndex(where: { $0 != 0 })!
            }
        }

        public var count: Int {
            switch value.sign {
            case .plus:
                if let high = value.magnitude.words.last, high >> (Word.bitWidth - 1) != 0 {
                    return value.magnitude.count + 1
                }
                return value.magnitude.count
            case .minus:
                let high = value.magnitude.words.last!
                if high >> (Word.bitWidth - 1) != 0 {
                    return value.magnitude.count + 1
                }
                return value.magnitude.count
            }
        }

        public var indices: Indices { return 0 ..< count }
        public var startIndex: Int { return 0 }
        public var endIndex: Int { return count }

        public subscript(_ index: Int) -> UInt {
            // Note that indices above `endIndex` are accepted.
            if value.sign == .plus {
                return value.magnitude[index]
            }
            if index <= decrementLimit {
                return ~(value.magnitude[index] &- 1)
            }
            return ~value.magnitude[index]
        }
    }

    public var words: Words {
        return Words(self)
    }

    public init<S: Sequence>(words: S) where S.Element == Word {
        var words = Array(words)
        if (words.last ?? 0) >> (Word.bitWidth - 1) == 0 {
            self.init(sign: .plus, magnitude: CS.BigUInt(words: words))
        }
        else {
            words.twosComplement()
            self.init(sign: .minus, magnitude: CS.BigUInt(words: words))
        }
    }
}
