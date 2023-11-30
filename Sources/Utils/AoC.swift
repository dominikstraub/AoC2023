import Foundation

public func getInput(bundle: Bundle, file: String = "input") throws -> String {
    let inputFile = bundle.url(forResource: file, withExtension: "txt")!
    let input = try String(contentsOf: inputFile, encoding: .utf8)
    return input
}

public func measure<T>(closure: () -> T) -> (result: T, duration: Double) {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = closure()
    let endTime = CFAbsoluteTimeGetCurrent()
    return (result: result, duration: endTime - startTime)
}

public func format(duration dur: Double) -> String {
    var duration = dur / 60
    let minutes = Int(duration)
    duration = (duration - Double(minutes)) * 60
    let seconds = Int(duration)
    duration = (duration - Double(seconds)) * 1000
    let miliseconds = Int(duration)
    duration = (duration - Double(miliseconds)) * 1000
    let microseconds = Int(duration)
    var stringComponents = [String]()
    if minutes > 0 {
        stringComponents.append("\(minutes)min")
    }
    if minutes > 0 || seconds > 0 {
        stringComponents.append("\(seconds)s")
    }
    if minutes > 0 || seconds > 0 || miliseconds > 0 {
        stringComponents.append("\(miliseconds)ms")
    }
    stringComponents.append("\(microseconds)μs")
    return String(stringComponents.joined(separator: " "))
}

public func run<T>(part: String, closure: () -> T) -> T {
    let (result, duration) = measure(closure: closure)
    let formattedDuration = format(duration: duration)
    print("\(part) in \(formattedDuration)")
    return result
}

public func run<T>(part: Int, closure: () -> T) -> T {
    let (result, duration) = measure(closure: closure)
    let formattedDuration = format(duration: duration)
    print("Part \(part): \(result) in \(formattedDuration)")
    return result
}
