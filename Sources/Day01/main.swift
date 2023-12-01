import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
let input = try Utils.getInput(bundle: Bundle.module)

func prepare() -> [String] {
    return input
        .components(separatedBy: CharacterSet(charactersIn: "\n"))
        .compactMap { line -> String? in
            if line == "" {
                return nil
            }
            return line
        }
}

let lines = run(part: "Input parsing", closure: prepare)

// func part1() -> Int {
//     var total = 0
//     for line in lines {
//         var first: Int?
//         var last: Int?
//         for char in line {
//             if let digit = Int(String(char)) {
//                 if first == nil {
//                     first = digit
//                 }
//                 last = digit
//             }
//         }
//         total += Int("\(String(describing: first!))\(String(describing: last!))")!
//     }
//     return total
// }

// _ = run(part: 1, closure: part1)

let digits = [
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
]

func part2() -> Int {
    var total = 0
    for line in lines {
        var first: Int?
        var last: Int?
        var index = 0
        while index < line.count {
            if let digit = Int(String(line[index])) {
                if first == nil {
                    first = digit
                } else {
                    last = digit
                }
            } else {
                digit: for (digit, word) in digits {
                    if index + word.count <= line.count, String(line[index ..< index + word.count]) == word {
                        index = index + word.count - 1
                        if first == nil {
                            first = digit
                        } else {
                            last = digit
                        }
                        break digit
                    }
                }
            }
            index += 1
        }
        // if first == nil || last == nil {
        //     print("invalid")
        //     continue
        // }
        print(line, terminator: ": ")
        let number = Int("\(String(describing: first!))\(String(describing: last!))")!
        print(number)

        total += Int("\(String(describing: first!))\(String(describing: last!))")!
    }
    return total
}

_ = run(part: 2, closure: part2)
