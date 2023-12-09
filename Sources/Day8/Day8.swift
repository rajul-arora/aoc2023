import Foundation
import SwiftGraph

struct Day8 {
    static func run(input: String) throws {
        let lines = input
            .split(separator: "\n")
            .map { String($0) }
        
        let instructions = lines
            .first?
            .split(separator: "")
            .map { String($0) }
        
        guard let instructions else {
            fatalError("No instructions")
        }
    
        let path = Array(lines[1..<lines.count])
        

        var lookup: [String: (String, String)] = [:]

        for element in path { 
            let components = element.split(separator: "=").map { String($0) }
            let key = components.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            let values = components.last?.split(separator: ",").map { String($0) }
            let left = values?.first?.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst()
            let right = values?.last?.trimmingCharacters(in: .whitespacesAndNewlines).dropLast()
            

            if let key, let left, let right { 
                lookup[key] = (String(left), String(right))
            }
        }

        let graph = UnweightedGraph<String>()
        
        lookup.keys.forEach { let _ = graph.addVertex($0) }    
        for (key, value) in lookup {
            graph.addEdge(from: key, to: value.0, directed: false)
            graph.addEdge(from: key, to: value.1, directed: false)
        }

        print(graph)

        // PART 1:

        /**
        let count = Self.part1(
            startString: "AAA", 
            endPosition: "ZZZ", 
            instructions: instructions, 
            lookup: lookup
        )

        print(count)
        */
    
        // PART 2:
        let count2 = Self.part2V2(instructions: instructions, lookup: lookup, graph: graph)

        print(count2)
    }

    private static func part1(
        startString: String,
        endPosition: String,
        instructions: [String], 
        lookup: [String: (String, String)]
    ) -> Int {
        var count = 0
        var currentInstructionIndex = 0
        var currentPosition = startString

        while currentPosition != endPosition { 
            if let directions = lookup[currentPosition] {
                currentPosition = instructions[currentInstructionIndex] == "L" ? directions.0 : directions.1
                count += 1
                currentInstructionIndex = (currentInstructionIndex == instructions.count - 1) ? 0 : currentInstructionIndex + 1
            } else {
                fatalError("\(currentPosition) doesn't exist in \(lookup)!")
            }
        }

        return count
    }

    private static func part2V2(
        instructions: [String],
        lookup: [String: (String, String)],
        graph: UnweightedGraph<String>
    ) -> Int {
        // var count = 0 

        let startNodes = lookup.keys.filter { $0.hasSuffix("A") }
        let endNodes = lookup.keys.filter { $0.hasSuffix("Z") }  

        var map: [String: [String]] = [:] 
        startNodes.forEach { startNode in
            let possibleSolutions = Self.possibleEndSolutions(
                for: startNode, 
                endNodes: endNodes, 
                graph: graph, 
                lookup: lookup
            )   

            map[startNode] = possibleSolutions
        }
    
        return 0
    }

    private static func possibleEndSolutions(
        for startNode: String,
        endNodes: [String],
        graph: UnweightedGraph<String>,
        lookup: [String: (String, String)]
    ) -> [String] {
        let paths = endNodes.map { graph.bfs(from: startNode, to: $0) }
        print("\(startNode), \(paths)")

        return endNodes.filter {
            !graph.bfs(from: startNode, to: $0).isEmpty 
        }
    }

    private static func part2(
        instructions: [String],
        lookup: [String: (String, String)]
    ) -> Int {
        var count = 0
        var currentNodes = lookup.keys.filter { $0.hasSuffix("A") }
        var currentInstructionIndex = 0
 
        while !(currentNodes.allSatisfy({ $0.hasSuffix("Z") })) {
            let instruction = instructions[currentInstructionIndex]

            currentNodes = currentNodes.map { node in 
                if let directions = lookup[node] {
                   return instruction == "L" ? directions.0 : directions.1 
                } else {
                    fatalError("\(node) does not exist in \(lookup)!")
                }     
            }

            count += 1
            currentInstructionIndex = (currentInstructionIndex == instructions.count - 1) ? 0 : currentInstructionIndex + 1
        }

        return count
    }
}
