import Foundation

struct Day4 {
    static func run(input: String) throws {
        let lines = input
            .split(separator: "\n")
            .map { String($0) }
            
        let cards = lines.compactMap { Card(input: $0) }

        var cardsMap: [Int: [Int]] = [:]
        for card in cards {
            cardsMap[card.id] = card.copiesWon
        }

        var countMap: [Int: Int] = [:]
        for card in cards {
            countMap[card.id] = 1
        }
        

        for card in cards {
            if let value = countMap[card.id] {
                let wonValues = cardsMap[card.id] ?? []

                 (0..<value).forEach { _ in 
                    wonValues.forEach { currentValue in 
                        if let countValue = countMap[currentValue] {
                            countMap[currentValue] = countValue + 1
                        }
                    }
                } 
            }
        }

        debugPrint(countMap.values.reduce(0, +))
    }
}

struct Card {
    var id: Int
    var winningNumbers: [Int]
    var currentNumbers: [Int]

    var matchingNumbers: Int
    var copiesWon: [Int]

    init?(input: String) {
        let idNumberSplit = input.split(separator: ":")
        
        guard 
            let idString = idNumberSplit.first?.split(separator: " ").last,
            let id = Int(idString)
        else {
            return nil
        }

        self.id = id
        
        let numberLists = idNumberSplit.last?.split(separator: "|")

        guard 
            let winningNumbersStringArray = numberLists?.first?.split(separator: " "),
            let currentNumbersStringArray = numberLists?.last?.split(separator: " ")
        else {
            return nil
        }

        self.winningNumbers = winningNumbersStringArray
            .map { String($0) }
            .compactMap { Int($0) }
        
    
        self.currentNumbers = currentNumbersStringArray
            .map { String($0) }
            .compactMap { Int($0) }

        self.matchingNumbers = Set(winningNumbers).intersection(Set(currentNumbers)).count
        self.copiesWon = (0..<self.matchingNumbers).map { $0 + id + 1 }
    }

    func score() -> Int {
        let winningSet = Set<Int>(winningNumbers)
        let currentSet = Set<Int>(currentNumbers)
        let intersection = winningSet.intersection(currentSet)
        return Int(pow(Double(2), Double(intersection.count - 1)))
    }
}
