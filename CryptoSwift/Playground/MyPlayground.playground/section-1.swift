// Playground - noun: a place where people can play

import UIKit

//var array = [120,9,8,7,6,5,6,7,8,9]
//
//var p = Int(pow(Double(2),Double(3)))
//

// Crash because of overflow
//var b:Byte = 128
//var i = b << 24

var b:Byte = 128
var i = UInt32(b) << 24

//var words:[[Int]] = [[Int]]()
//for (idx, item) in enumerate(array) {
//    if (idx > 0) && (idx + 2) <= array.count && (idx % 2) == 0 {
//        let word = array[idx..<idx + 2]
//    }
//}

//for var idx = 2; idx <= array.count; idx = idx + 2 {
//    let word = Array(array[idx - 2..<idx])
//    words.append(word)
//}
//let reminder = Array(suffix(array, array.count % 2))
//words.append(reminder)
//
//words

extension Array {
    func chunks(chunksize:Int) -> [Array<T>] {
        var words:[[T]] = [[T]]()
        for var idx = chunksize; idx <= self.count; idx = idx + chunksize {
            let word = Array(self[idx - chunksize..<idx])
            words.append(word)
        }
        let reminder = Array(suffix(self, self.count % chunksize))
        if (reminder.count > 0) {
            words.append(reminder)
        }
        return words
    }
}

