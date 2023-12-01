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

    static func number(for line: String) -> Int {
        var firstNumberIndex: Int = -1
        var secondNumberIndex: Int = -1
        let split = Array(line)

        split.enumerated().forEach { index, value in 
            if let _ = Int(String(value)), firstNumberIndex == -1 {
                firstNumberIndex = index
            }
        }

        split.reversed().enumerated().forEach { index, value in 
            if let _ = Int(String(value)), secondNumberIndex == -1 {
                secondNumberIndex = split.count - index - 1
            }
        }
          
        return Int("\(split[firstNumberIndex])\(split[secondNumberIndex])") ?? 0
    }
}
