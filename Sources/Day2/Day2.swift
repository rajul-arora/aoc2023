import Foundation

struct Day2 {
    static func run(input: String) throws {
        let constraints: [String: Int] = [
            "red": 12,
            "green": 13,
            "blue": 14
        ]

        let lines = input.split(separator: "\n")
        let games = lines.compactMap { Game(input: String($0)) }
        let possibleGames = games.filter { $0.isPossible(with: constraints) }
        let value = possibleGames.map { $0.id }.reduce(0, +)
        debugPrint(value)

        let minimumPossibleCubeMaps = games.map { $0.minimumPossibleCubes() }
        let result = minimumPossibleCubeMaps.map { calculatePower(for: $0) }.reduce(0, +)
        debugPrint(result)
    }

    static func calculatePower(for map: [String: Int]) -> Int {
        return map.values.reduce(1, *)
    }
}

struct Game {
    struct Round {
        let colorsMap: [String: Int]
    
        init?(input: String) {
            let values = input.split(separator: ",")
            var map: [String: Int] = [:]

            values.forEach { value in 
                let split = value.split(separator: " ")
                if 
                    let numberCharacter = split.first,
                    let number = Int(String(numberCharacter)),
                    let colorString = split.last
                { 
                    map[String(colorString)] = number
                }
            }

            self.colorsMap = map
        }

        func isPossible(with constraints: [String: Int]) -> Bool {
            for (key, value) in colorsMap {
                if let constraint = constraints[key] {
                    if value > constraint {
                        return false
                    }
                }
            }

            return true
        }
    }

    let id: Int
    let rounds: [Round]

    init?(input: String) {
        let idContentSplit = input.split(separator: ":")

        guard 
            let gameName = idContentSplit.first,
            let gameNumberString = gameName.split(separator: " ").last,
            let gameNumber = Int(gameNumberString)
        else {
            return nil
        } 
        
        self.id = gameNumber
        
        let roundsStrings = idContentSplit.last?.split(separator: ";")
        self.rounds = roundsStrings?.compactMap { Round(input: String($0)) } ?? []
    }

    func isPossible(with constraints: [String: Int]) -> Bool {
        return self.rounds.allSatisfy { $0.isPossible(with: constraints) }
    }

    func minimumPossibleCubes() -> [String: Int] {
        var map: [String: Int] = [:]

        rounds.forEach { round in 
            for (key, value) in round.colorsMap {
                map[key] = max(map[key] ?? -1, value)
            }
        }

        return map
    }
}
