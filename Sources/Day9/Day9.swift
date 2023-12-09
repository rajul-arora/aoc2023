import Foundation

struct Day9 {
    static func run(input: String) throws {
        let lines: [[Int]] = input
            .split(separator: "\n")
            .map { String($0) }
            .map { $0.split(separator: " ").compactMap { value in Int(String(value))} } 


        /**
        let result = lines.map {
            let history = Self.generateHistory(for: $0)
            return Self.generateNextValue(for: history)
        }*/

        let part2Result = lines.map {
            let history = Self.generateHistory(for: $0)
            return Self.generatePreviousValue(for: history)
        }
        
        print(part2Result)

        let total = part2Result.reduce(0, +)
        

        // let total = result.reduce(0, +)
        print(total)
    }

    private static func generateNextValue(for history: [[Int]]) -> Int {
        var currentNext = 0
    
        history.reversed().forEach { 
            currentNext = $0[$0.count - 1] + currentNext
        }

        return currentNext
    }

    private static func generatePreviousValue(for history: [[Int]]) -> Int {
        var currentPrevious = 0
        
        history.reversed().forEach {
            currentPrevious = $0[0] - currentPrevious
        }

        return currentPrevious
    }

    private static func generateHistory(for input: [Int]) -> [[Int]] {
        var history: [[Int]] = []
        history.append(input)
        var currentLine = input

        while !currentLine.allSatisfy({ $0 == 0 }) {
            currentLine = Self.generateNextRow(input: currentLine)
            history.append(currentLine)
        }
    
        return history
    }

    private static func generateNextRow(
        input: [Int]
    ) -> [Int] {
        return input
            .enumerated()
            .compactMap { (index, element) in  index != 0 ? input[index] - input[index-1] : nil }
    }
}
