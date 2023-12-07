struct Day6 {
    static func run(input: String) throws {
        let lines = input
            .split(separator: "\n")
            .map { String($0) }

        // PART 1:
        let timeArray = lines
            .first?
            .split(separator: ":")
            .last?
            .split(separator: " ")
            .compactMap { Int(String($0)) } ?? []

        let distanceArray = lines
            .last?
            .split(separator: ":")
            .last?
            .split(separator: " ")
            .compactMap { Int(String($0)) } ?? []

        /**
        let result: Int = zip(timeArray, distanceArray)
            .map { time, distance in Self.combinations(time: time, distance: distance) }
            .reduce(1, *)

        debugPrint(result)
        */

        // PART 2:
        
        let time = Int(timeArray.map { "\($0)" }.joined()) ?? 0
        let distance = Int(distanceArray.map { "\($0)" }.joined()) ?? 0
        
        let result = Self.combinations(time: time, distance: distance)

        debugPrint(result)
    }

    static func combinations(time: Int, distance: Int) -> Int {
        var combinations: Int = 0
        
        (1..<time).forEach { holdTime in 
            let currentDistance = (time - holdTime) * holdTime
            if currentDistance > distance {
                combinations += 1
            }
        }
 
        return combinations
    }
}
