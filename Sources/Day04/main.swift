import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

func prepare() -> [(cardNr: Int, winningNrs: [Int], myNrs: [Int])] {
    return input
        .components(separatedBy: CharacterSet(charactersIn: "\n"))
        .compactMap { line -> (cardNr: Int, winningNrs: [Int], myNrs: [Int])? in
            if line == "" {
                return nil
            }
            let pattern = "Card +(\\d+): +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) \\| +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+) +(\\d+)"
            let regex = try? NSRegularExpression(pattern: pattern)
            guard let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf8.count)) else { return nil }

            var matches = [Int]()
            for index in 0 ..< match.numberOfRanges {
                if let range = Range(match.range(at: index), in: line), let matched = Int(line[range]) {
                    matches.append(matched)
                }
            }

            return (
                cardNr: matches[0],
                winningNrs: [matches[1], matches[2], matches[3], matches[4], matches[5], matches[6], matches[7], matches[8], matches[9], matches[10]],
                myNrs: [matches[11], matches[12], matches[13], matches[14], matches[15], matches[16], matches[17], matches[18], matches[19], matches[20], matches[21], matches[22], matches[23], matches[24], matches[25], matches[26], matches[27], matches[28], matches[29], matches[30], matches[31], matches[32], matches[33], matches[34], matches[35]]
            )
        }
}

let cards = run(part: "Input parsing", closure: prepare)

func part1() -> Int {
    print(cards.count)
    return cards.map { card -> Int in
        2 ^^ ((Set<Int>(card.myNrs).intersection(Set<Int>(card.winningNrs)).count) - 1) as Int
    }.sum()
}

_ = run(part: 1, closure: part1)

// func part2() -> Int {
//     return -1
// }

// _ = run(part: 2, closure: part2)
