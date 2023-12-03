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

let adjacentMat = [
    (-1, -1),
    (-1, 0),
    (-1, +1),
    (0, -1),
    (0, +1),
    (+1, -1),
    (+1, 0),
    (+1, +1),
]

extension Array where Element == String {
    func isPart(yIndex: Int, xIndex: Int) -> Bool {
        for (yDiff, xDiff) in adjacentMat where isSymbol(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff) {
            return true
        }
        return false
    }

    func isSymbol(yIndex: Int, xIndex: Int) -> Bool {
        if let element = self[safe: yIndex]?[safe: xIndex] {
            return !element.isNumber && element != "."
        }
        return false
    }

    func isNumber(yIndex: Int, xIndex: Int) -> Bool {
        if let element = self[safe: yIndex]?[safe: xIndex] {
            return element.isNumber
        }
        return false
    }

    func isGear(yIndex: Int, xIndex: Int) -> Bool {
        if let element = self[safe: yIndex]?[safe: xIndex], element == "*" {
            var count = 0
            for (yDiff, xDiff) in adjacentMat where isNumber(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff) &&
                (xDiff == -1 || !isNumber(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff - 1))
            {
                count += 1
            }
            return count == 2
        }
        return false
    }

    func getFullNumber(yIndex: Int, xIndex: Int) -> Int {
        var number = 0
        var xStart = xIndex
        while isNumber(yIndex: yIndex, xIndex: xStart) {
            xStart -= 1
        }
        xStart += 1
        var xCurrent = xStart
        while xCurrent <= self[safe: yIndex]!.count {
            if xCurrent < self[safe: yIndex]!.count, isNumber(yIndex: yIndex, xIndex: xCurrent) {
                number = number * 10 + Int(String(self[safe: yIndex]![xCurrent]))!
                xCurrent += 1
            } else {
                return number
            }
        }
        return -1
    }

    func getGearRatio(yIndex: Int, xIndex: Int) -> Int {
        var numbers: [Int] = []
        for (yDiff, xDiff) in adjacentMat where isNumber(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff) &&
            (xDiff == -1 || !isNumber(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff - 1))
        {
            numbers.append(getFullNumber(yIndex: yIndex + yDiff, xIndex: xIndex + xDiff))
        }
        return numbers.product()
    }
}

func part1() -> Int {
    var sum = 0
    for (yIndex, line) in schematic.enumerated() {
        var xIndex = 0
        var isPart = false
        var number = 0
        while xIndex <= line.count {
            if xIndex < line.count {
                if schematic.isNumber(yIndex: yIndex, xIndex: xIndex) {
                    number = number * 10 + Int(String(line[xIndex]))!
                    if !isPart, schematic.isPart(yIndex: yIndex, xIndex: xIndex) {
                        isPart = true
                    }
                }
            }
            if xIndex >= line.count || !schematic.isNumber(yIndex: yIndex, xIndex: xIndex) {
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

_ = run(part: 1, closure: part1)

func part2() -> Int {
    var sum = 0
    for (yIndex, line) in schematic.enumerated() {
        var xIndex = 0
        while xIndex < line.count {
            if schematic.isGear(yIndex: yIndex, xIndex: xIndex) {
                sum += schematic.getGearRatio(yIndex: yIndex, xIndex: xIndex)
            }
            xIndex += 1
        }
    }
    return sum
}

_ = run(part: 2, closure: part2)
