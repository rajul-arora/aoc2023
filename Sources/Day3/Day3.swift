import Foundation


struct Day3 {
    static func run(input: String) throws {
        let lines = input.split(separator: "\n")
        let mapped = lines.map { String($0) }

        /**
    
        // PART 1:
    
        let symbolIndices: [(Int, Int)] = lines.enumerated().flatMap { lineNumber, line  in 
           Day3.symbolIndices(for: String(line), lineNumber: lineNumber) 
        }

        let numberIndices: [(Int, (Int, Int))] = lines.enumerated().flatMap { lineNumber, line in 
           Day3.numberIndices(for: String(line), lineNumber: lineNumber) 
        }

        let adjacentSymbolIndices: [(Int, Int)] = symbolIndices.flatMap { Day3.adjacentIndices(for: $0) }
        
        let numbers = numberIndices.filter { numberIndex in 
            adjacentSymbolIndices.filter { symbolIndex in 
                Day3.doesOverlap(numberIndex: numberIndex, symbolIndex: symbolIndex)
            }.count > 0
        }.compactMap { numberIndex in 
            Day3.number(using: numberIndex, from: mapped)
        }

        
        // mapped.forEach { debugPrint($0) }
        debugPrint(numbers.reduce(0, +))

        */

        // PART 2:

        let starIndices: [(Int, Int)] = lines.enumerated().flatMap { lineNumber, line in 
            Day3.starIndices(for: String(line), lineNumber: lineNumber)
        }

        let numberIndices: [(Int, (Int, Int))] = lines.enumerated().flatMap { lineNumber, line in 
           Day3.numberIndices(for: String(line), lineNumber: lineNumber) 
        }

        let validAdjacentNumbers: [[(Int, (Int, Int))]] = starIndices.map { 
            Day3.numberIndices(adjacentTo: $0, numberIndices: numberIndices)
        }.filter {
            $0.count == 2
        }
 
        let numbers = validAdjacentNumbers.map { indexArray in
            indexArray
                .compactMap { Day3.number(using: $0, from: mapped) }
                .reduce(1, *)
        }

        debugPrint(numbers.reduce(0, +))
    }

    private static func numberIndices(
        adjacentTo index: (Int, Int),
        numberIndices: [(Int, (Int, Int))]
    ) -> [(Int, (Int, Int))] {
        let adjacentSymbolIndices = Day3.adjacentIndices(for: index)
        return numberIndices.filter { numberIndex in 
            adjacentSymbolIndices.filter { adjacentIndex in 
                Day3.doesOverlap(numberIndex: numberIndex, symbolIndex: adjacentIndex)
            }.count > 0
        }
    }

    private static func symbolIndices(
        for line: String,
        lineNumber: Int
    ) -> [(Int, Int)] {
        "!@#$%^&*()_+-=<>,?[]{}|;:\\/"
            .flatMap { line.ranges(of: String($0)) }
            .map { (lineNumber, line.distance(from: line.startIndex, to: $0.lowerBound)) }
    }

    private static func starIndices(
        for line: String,
        lineNumber: Int
    ) -> [(Int, Int)] {
        return line
            .ranges(of: "*")
            .map { (lineNumber, line.distance(from: line.startIndex, to: $0.lowerBound)) }
    }

    private static func numberIndices(
        for line: String,
        lineNumber: Int
    ) -> [(Int, (Int, Int))] {
        line.numberRanges().map { (lineNumber, $0)}
    } 

    private static func adjacentIndices(for index: (Int, Int)) -> [(Int, Int)] {
        return [
            (index.0 + 1, index.1),
            (index.0 - 1, index.1),
            (index.0, index.1 + 1),
            (index.0, index.1 - 1),
            (index.0 + 1, index.1 + 1),
            (index.0 - 1, index.1 - 1),
            (index.0 + 1, index.1 - 1),
            (index.0 - 1, index.1 + 1)
        ]
    }

    private static func doesOverlap(
        numberIndex: (Int, (Int, Int)), 
        symbolIndex: (Int, Int)
    ) -> Bool {
        let indices: [(Int, Int)] = (numberIndex.1.0...numberIndex.1.1).map { (numberIndex.0, $0) }
        return indices.filter { symbolIndex.0 == $0.0 && symbolIndex.1 == $0.1 }.count > 0
    }

    private static func number(
        using index: (Int, (Int, Int)), 
        from input: [String]
    ) -> Int? {
        let line = input[index.0]
        let startIndex = line.index(line.startIndex, offsetBy: index.1.0)
        let endIndex = line.index(line.startIndex, offsetBy: index.1.1)
        let substring = String(line[startIndex...endIndex])
        return Int(substring)
    }
}
