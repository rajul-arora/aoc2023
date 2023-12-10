import Foundation

struct Day10 {
    static func run(input: String) throws {
        let lines = input
            .split(separator: .newline)
            .map { String($0) }
    
        for line in lines {
            print(line)
        }

        let startPosition = Self.calculateStartPosition(lines) 
        let loop = Self.findLoop(startPosition: startPosition, lines)

        let distance = Self.calculateMaxDistance(in: loop)
        print(distance)
    }

    private static func calculateMaxDistance(in loop: [(Int, Int)]) -> Int {
        let middleIndex = Int(loop.count / 2)
        return middleIndex
    }

    private static func calculateStartPosition(_ lines: [String]) -> (Int, Int) {
        var startPosition: (Int, Int) = (-1, -1)

        for (row, line) in lines.enumerated() {
            if let index = line.firstIndex(of: "S") {
                let column = line.distance(from: line.startIndex, to: index)
                startPosition = (row, column)
            }
        }

        guard startPosition.0 != -1 && startPosition.1 != -1 else {
            fatalError("Could not find valid start position!")
        }

        return startPosition
    }

    private static func findLoop(
        startPosition: (Int, Int),
        _ lines: [String]
    ) -> [(Int, Int)] {
        var loop: [(Int, Int)] = [startPosition]
        var currentPosition: (Int, Int) = startPosition
        var done = false

        while !done {
            let nextPosition = Self.findNextValidPosition(
                currentPosition: currentPosition, 
                lines, currentLoop: loop
            )

            if let nextPosition {
                currentPosition = nextPosition
                loop.append(nextPosition)
            } else {
                done = true
            }
        }

        return loop
    }

    private static func findNextValidPosition(
        currentPosition: (Int, Int), 
        _ lines: [String],
        currentLoop: [(Int, Int)]
    ) -> (Int, Int)? {
        guard let currentString = Self.value(at: currentPosition, lines) else {
            fatalError("Could not find current string in lines!")
        }

        // print("Current String = \(currentString)")
 
        switch currentString {
            case "S":
                return Self.getPositions(
                    from: .all, 
                    currentPosition: currentPosition, 
                    lines: lines,
                    currentLoop: currentLoop
                )
            case "-":
                return self.getPositions(
                    from: .horizontal, 
                    currentPosition: currentPosition, 
                    lines: lines, 
                    currentLoop: currentLoop
                )
            case "|":
                return Self.getPositions(
                    from: .vertical, 
                    currentPosition: currentPosition, 
                    lines: lines, 
                    currentLoop: currentLoop
                )
            case "7":
                return Self.getPositions(
                    from: [.left, .bottom], 
                    currentPosition: currentPosition, 
                    lines: lines, 
                    currentLoop: currentLoop
                )

            case "J":
                return Self.getPositions(
                    from: [.top, .left], 
                    currentPosition: currentPosition, 
                    lines: lines, 
                    currentLoop: currentLoop
                )
            case "F":
                return Self.getPositions(
                    from: [.bottom, .right], 
                    currentPosition: currentPosition, 
                    lines: lines, 
                    currentLoop: currentLoop
                )
            case "L":
                return Self.getPositions(
                    from: [.top, .right], 
                    currentPosition: currentPosition, 
                    lines: lines, 
                    currentLoop: currentLoop
                )
            default: 
                return nil
        }
    }

    private static func getPositions(
        from position: Position, 
        currentPosition: (Int, Int),
        lines: [String],
        currentLoop: [(Int, Int)]
    ) -> (Int, Int)? {
        let validRightPipes = ["-", "7", "J"]
        let validLeftPipes = ["-", "L", "F"]
        let validTopPipes = ["|", "7", "F"]
        let validBottomPipes = ["|", "J", "L"]

        let leftPosition = (currentPosition.0, currentPosition.1 - 1)
        let rightPosition = (currentPosition.0, currentPosition.1 + 1)
        let topPosition = (currentPosition.0 - 1, currentPosition.1)
        let bottomPosition = (currentPosition.0 + 1, currentPosition.1)

        if
            !currentLoop.contains(leftPosition),
            position.contains(.left), 
            let leftValue = Self.value(at: leftPosition, lines), 
            validLeftPipes.contains(leftValue) 
        {
            return leftPosition 
        }

        if 
            !currentLoop.contains(rightPosition),
            position.contains(.right), 
            let rightValue = Self.value(at: rightPosition, lines), 
            validRightPipes.contains(rightValue) 
        {
            return rightPosition
        }

        if 
            !currentLoop.contains(topPosition),
            position.contains(.top), 
            let topValue = Self.value(at: topPosition, lines), 
            validTopPipes.contains(topValue) 
        {
            return topPosition
        }

        if 
            !currentLoop.contains(bottomPosition),
            position.contains(.bottom), 
            let bottomValue = Self.value(at: bottomPosition, lines), 
            validBottomPipes.contains(bottomValue) 
        {
            return bottomPosition
        }

        return nil
    }

    private static func value(at position: (Int, Int), _ lines: [String]) -> String? {
        guard position.0 >= 0 && position.0 < lines.count else {
            return nil
        }

        let line = lines[position.0]
        
        guard position.1 >= 0 && position.1 < line.count else {
            return nil
        }

        return String(line[position.1])
    } 
}

extension Array where Element == String {
    static let pipes = ["|", "-", "7", "L", "J", "F"]
}

extension String {
    subscript (index: Int) -> Character {
        let start = self.index(startIndex, offsetBy: index)
        return self[start]
    }
}

struct Position: OptionSet {
    let rawValue: Int

    static let top = Position(rawValue: 1 << 0)
    static let bottom = Position(rawValue: 1 << 1)
    static let left = Position(rawValue: 1 << 2)
    static let right = Position(rawValue: 1 << 3)

    static let all: Position = [.top, .bottom, .left, .right]
    static let horizontal: Position = [.left, .right]
    static let vertical: Position = [.top, .bottom]
}

extension Array where Element == (Int, Int) {
    func contains(_ value: (Int, Int)) -> Bool {
        for element in self {
            if element.0 == value.0 && element.1 == value.1 {
                return true
            }
        }

        return false
    }
}
