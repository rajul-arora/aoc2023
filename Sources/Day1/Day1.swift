import Foundation

enum Day1Error: LocalizedError {
    case unknown

    var errorDescription: String? {
        switch self {
            case .unknown:
                return "Unknown Error!"
        }
    }
}

struct Day1 {
    static func run(input: String) throws {
        let lines = input.split(separator: "\n")
        let result = lines.map { number(for: String($0)) }.reduce(0, +)
        debugPrint(result)
    }

    static func digitStringToInt(string: String) -> Int {
        switch string {
            case "zero": return 0
            case "one": return 1
            case "two": return 2
            case "three": return 3
            case "four": return 4
            case "five": return 5
            case "six": return 6
            case "seven": return 7
            case "eight": return 8
            case "nine": return 9
            default: return 0

        }
    }

    static func number(for line: String) -> Int {
        let digitStrings = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        let firstIntegerIdx = line.firstIndex {
            guard let _ = Int(String($0)) else {
                return false
            }

            return true
        }

        let digitNameRanges: [(Int, Int)] = digitStrings
            .flatMap { line.ranges(of: $0) }
            .sorted { $0.lowerBound < $1.lowerBound }
            .map { (line.distance(from:line.startIndex, to: $0.lowerBound), line.distance(from: line.startIndex, to: $0.upperBound)) }
        
        let lastIntegerIdx = line.lastIndex {
            guard let _ = Int(String($0)) else {
                return false
            }

            return true
        }


        let firstDigitRange = digitNameRanges.first
        let lastDigitRange = digitNameRanges.last

        var firstDigit: String = "0"
        var lastDigit: String = "0"

        if let firstIntegerIdx, let firstDigitRange {    
            let firstIntegerIntIdx = line.distance(from: line.startIndex, to: firstIntegerIdx)
            if firstIntegerIntIdx < firstDigitRange.0 {
                firstDigit = String(line[firstIntegerIdx])
            } else {
                let start = line.index(line.startIndex, offsetBy: firstDigitRange.0)
                let end = line.index(line.startIndex, offsetBy: firstDigitRange.1)
                firstDigit = String(digitStringToInt(string: String(line[start..<end])))
            } 
        } else if let firstIntegerIdx {
            firstDigit = String(line[firstIntegerIdx])
        } else if let firstDigitRange {
            let start = line.index(line.startIndex, offsetBy: firstDigitRange.0)
            let end = line.index(line.startIndex, offsetBy: firstDigitRange.1)
            firstDigit = String(digitStringToInt(string: String(line[start..<end]))) 
        }

        if let lastIntegerIdx, let lastDigitRange {
            let lastIntegerIntIdx = line.distance(from: line.startIndex, to: lastIntegerIdx)
            if lastIntegerIntIdx > lastDigitRange.0 {
                lastDigit = String(line[lastIntegerIdx])
            } else {
                let start = line.index(line.startIndex, offsetBy: lastDigitRange.0)
                let end = line.index(line.startIndex, offsetBy: lastDigitRange.1)
                lastDigit = String(digitStringToInt(string: String(line[start..<end]))) 
            }
        } else if let lastIntegerIdx {
            lastDigit = String(line[lastIntegerIdx])
        } else if let lastDigitRange {
            let start = line.index(line.startIndex, offsetBy: lastDigitRange.0)
            let end = line.index(line.startIndex, offsetBy: lastDigitRange.1)
            lastDigit = String(digitStringToInt(string: String(line[start..<end])))
        }
        
        return Int("\(firstDigit)\(lastDigit)") ?? 0
    }
}

// https://gist.github.com/robertmryan/7fc421b905d22be5063528e64676529a
extension StringProtocol where Index == String.Index {
    func ranges<T: StringProtocol>(of substring: T, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let result = range(of: substring, options: options, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(result)
        }
        return ranges
    }
}
