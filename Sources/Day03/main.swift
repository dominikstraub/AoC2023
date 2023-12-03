import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

func prepare() -> [String] {
    return input
        .components(separatedBy: CharacterSet(charactersIn: "\n"))
        .compactMap { $0 }
}

let schematic = run(part: "Input parsing", closure: prepare)

func part1() -> Int {
    var sum = 0
    for (yIndex, line) in schematic.enumerated() {
        var xIndex = 0
        var isPart = false
        var number = 0
        while xIndex <= line.count {
            if xIndex < line.count {
                if line[xIndex].isNumber {
                    number = number * 10 + Int(String(line[xIndex]))!
                    if !isPart && schematic.isPart(yIndex: yIndex, xIndex: xIndex) {
                        isPart = true
                    }
                }
            }
            if xIndex >= line.count || !line[xIndex].isNumber {
                if isPart {
                    sum += number
                }
                number = 0
                isPart = false
            }
            xIndex += 1
        }
    }
    return sum
}

extension Array where Element == String {
    func isPart(yIndex: Int, xIndex: Int) -> Bool {
        let diffs = [
            (-1, -1),
            (-1, 0),
            (-1, +1),
            (0, -1),
            (0, +1),
            (+1, -1),
            (+1, 0),
            (+1, +1),
        ]
        for (yDiff, xDiff) in diffs where isSymbol(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff) ?? false {
            return true
        }
        return false
    }

    func isSymbol(yIndex: Int, xIndex: Int) -> Bool? {
        if let element = self[safe: yIndex]?[safe: xIndex] {
            return !element.isNumber && element != "."
        }
        return nil
    }
}

_ = run(part: 1, closure: part1)

// func part2() -> Int {
//     return -1
// }

// _ = run(part: 2, closure: part2)
