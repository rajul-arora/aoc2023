import Foundation

struct Day5 {
    static func run(input: String) throws {
        var lines = input.split(separator: "\n").map { String($0) }
        let seeds: [Int] = lines
            .removeFirst()
            .split(separator: ":")
            .last?
            .split(separator: " ")
            .compactMap { Int(String($0)) } ?? []

        var inputs: [[String]] = []
        var subarray: [String] = []
        
        while !lines.isEmpty {
            if subarray.isEmpty {
                subarray.append(lines.removeFirst())
            } else {
                let currentLine = lines.removeFirst()
                if currentLine.hasSuffix("map:") {
                    inputs.append(subarray)
                    subarray = [currentLine]
                } else {
                    subarray.append(currentLine)
                }
            }
        }

        inputs.append(subarray)
 
        let maps: [SourceToDestinationMap] = inputs.compactMap { 
            SourceToDestinationMap(input: $0) 
        } 

        // PART 1:
        debugPrint(Self.getMinLocation(for: seeds, maps: maps))

        // PART 2:
    
        // let chunkedSeeds: [[Int]] = seeds.chunk()
    }

    private static func getMinLocation(for seeds: [Int], maps: [SourceToDestinationMap]) -> Int {
        var locations: [Int] = []
        
        for seed in seeds {
            var currentValue = seed
            for map in maps {
                let nextValue = map.destinationValue(for: currentValue)
                currentValue = nextValue
            }

            locations.append(currentValue)
        }    

        return locations.min() ?? -1
    }

    private static func getMinLocationPart2(for chunkedSeeds: [[Int]], maps: [SourceToDestinationMap]) -> Int {
        var minLocation: Int = Int.max
 
        for seedsChunk in chunkedSeeds {
            let start = seedsChunk[0]
            let end = start + seedsChunk[1]
            let range = start..<end
            
            var currentRanges: [Range<Int>] = [range]
            for map in maps {
                let nextRanges = currentRanges.flatMap { map.destinationRanges(for: $0) }
                currentRanges = nextRanges
            }

            minLocation = min(minLocation, currentRanges.lowestValue())
        }

        return minLocation
    }
}

struct SourceToDestinationMap {
    let source: String
    let destination: String
     // let map: [Int: Int]

    let sourceRanges: [Range<Int>]
    let destinationRanges: [Range<Int>]

    init?(input: [String]) {
        guard let sourceToDestinationString = input.first else {
            return nil
        }

        let array = sourceToDestinationString.split(separator: "-to-")

        guard
            let source = array.first,
            let destination = array.last?.split(separator: " ").first
        else {
            return nil
        }

        self.source = String(source)
        self.destination = String(destination)

    
        var mutableInput = input
        mutableInput.removeFirst()

        let arrays: [[Int]] = mutableInput.map { inputString in
            inputString.split(separator: " ").compactMap { value in
                Int(String(value)) 
            }
        }

        var sourceRanges: [Range<Int>] = []
        var destinationRanges: [Range<Int>] = []

        for integerArray in arrays {
            let destinationRangeStart = integerArray[0]
            let sourceRangeStart = integerArray[1]
            let length = integerArray[2]
            
            let destinationRange: Range<Int> = destinationRangeStart..<destinationRangeStart+length
            let sourceRange: Range<Int> = sourceRangeStart..<sourceRangeStart+length

            sourceRanges.append(sourceRange)
            destinationRanges.append(destinationRange)
        }

        self.sourceRanges = sourceRanges
        self.destinationRanges = destinationRanges
    }

    func destinationValue(for inputValue: Int) -> Int {
        let index = sourceRanges.firstIndex { $0.contains(inputValue) } 

        guard let index else {
            return inputValue
        }
        
        let sourceRange = sourceRanges[index]
        let destinationRange = destinationRanges[index]
        let offset = inputValue - sourceRange.lowerBound
        return destinationRange.lowerBound + offset 
    }

    func destinationRanges(for inputRange: Range<Int>) -> [Range<Int>] {
        let fullyContainedSourceRangeIndex = sourceRanges.firstIndex { 
            $0.contains(inputRange.lowerBound) && $0.contains(inputRange.upperBound) 
        }

        // If input range is fully encompassed by one of the source ranges, return the 
        // corresponding destination range.
        if let fullyContainedSourceRangeIndex {
            let sourceRange = sourceRanges[fullyContainedSourceRangeIndex]
            let destinationRange = destinationRanges[fullyContainedSourceRangeIndex]
            let offset = destinationRange.lowerBound - sourceRange.lowerBound
            return [inputRange.lowerBound + offset..<inputRange.upperBound + offset]
        } else {
            return []
        }
    } 


}

extension Array {
    func chunk() -> [[Element]] {
        guard count % 2 == 0 else {
            fatalError("Odd array sizes not supported!")
        }
    
        var result: [[Element]] = []
        for i in stride(from: 0, to: self.count, by: 2) {
            result.append([self[i], self[i+1]])
        }

        return result
    }
}

extension Array where Element == Range<Int> {
    func lowestValue() -> Int {
        var value = Int.max
            
        for range in self {
            value = Swift.min(value, range.lowerBound)
        }

        return value
    }
}
