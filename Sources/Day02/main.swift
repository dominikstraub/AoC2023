import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

func prepare() -> [(Int, [[(Int, String)]])] {
    return input
        .components(separatedBy: CharacterSet(charactersIn: "\n"))
        .compactMap { line -> (Int, [[(Int, String)]])? in
            if line == "" {
                return nil
            }
            let parts = line.components(separatedBy: ": ")
            let parts2 = parts[0].components(separatedBy: " ")
            let gameNr = Int(parts2[1])!
            let draws = parts[1].components(separatedBy: "; ")
                .compactMap { draw -> [(Int, String)]? in
                    draw.components(separatedBy: ", ")
                        .compactMap { cube -> (Int, String)? in
                            if cube == "" {
                                return nil
                            }
                            let parts = cube.components(separatedBy: " ")
                            let count = Int(parts[0])!
                            let color = parts[1]
                            return (count, color)
                        }
                }
            return (gameNr, draws)
        }
}

let games = run(part: "Input parsing", closure: prepare)

let maxCubes = ["red": 12, "green": 13, "blue": 14]

func part1() -> Int {
    var idSum = 0
    for game in games {
        var possible = true
        draw: for draw in game.1 {
            for (count, color) in draw {
                if maxCubes[color]! < count {
                    possible = false
                    break draw
                }
            }
        }
        if possible {
            idSum += game.0
        }
    }
    return idSum
}

_ = run(part: 1, closure: part1)

func part2() -> Int {
    return games.reduce(0) { total, game in
        var minCubes = ["red": 0, "green": 0, "blue": 0]
        for draw in game.1 {
            for (count, color) in draw where minCubes[color]! < count {
                minCubes[color] = count
            }
        }
        return total + minCubes.values.reduce(1, *)
    }
}

_ = run(part: 2, closure: part2)
