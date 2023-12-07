struct Day7 {
    public static func run(input: String) throws {
        let lines = input
            .split(separator: "\n")
            .map { String($0) } 

        var handsToBidMap: [String: Int] = [:]
        var hands: [String] = []    

        for line in lines {
            let split = line.split(separator: " ")

            if 
                let handSubstring = split.first, 
                let bidSubstring = split.last, 
                let bid = Int(String(bidSubstring)) 
            {
                let hand = String(handSubstring)
                handsToBidMap[hand] = bid
                hands.append(hand)
            }   
        }
        

        let grouped: [Int: [String]] = Dictionary(
            grouping: hands, 
            by: { Self.type(for: $0) }
        )
 
        let total = Self.calculateWinnings(groupedHands: grouped, handsToBidMap: handsToBidMap)
        debugPrint(total)
    }

    private static func calculateWinnings(
        groupedHands: [Int: [String]], 
        handsToBidMap: [String: Int]
    ) -> Int {
        var total: Int = 0
        var currentRank: Int = 0
        let ranks: [Int] = [0, 1, 2, 3, 4, 5, 6]

        for rank in ranks {
             if let grouping = groupedHands[rank] {
                let sorted = grouping.sorted { 
                    Self.compareHands(hand1: $0, hand2: $1) != 1 
                }

                // debugPrint(sorted)
                
                for hand in sorted {
                    currentRank += 1 
                    if let bid = handsToBidMap[hand] {
                        total += bid * currentRank 
                    }
                }
            }
        } 
    
        return total
    }


    // 1 -> Hand1 > Hand2, -1 -> Hand2 > Hand1, 0 Hand1 == hand2 
    private static func compareHands(hand1: String, hand2: String) -> Int {
        for (element1, element2) in zip(hand1, hand2) {
            let stringElement1 = String(element1)
            let stringElement2 = String(element2)
            let comparisonResult = Self.compareElement(
                element1: stringElement1, 
                element2: stringElement2
            )

            if comparisonResult != 0 {
                // debugPrint("\(element1) \(element2) \(comparisonResult)")
                return comparisonResult
            } else {
                // debugPrint("\(element1) \(element2) \(comparisonResult)")
            } 
        }

        return 0 // Hands are the same
    }

    // 0 -> Same element, 1 -> element1 > element2, -1 -> element2 > element1
    private static func compareElement(element1: String, element2: String) -> Int {
        if element1 == element2 {
            return 0
        }

        let ranks: [String] = ["J","2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
        
        if let index1 = ranks.firstIndex(of: element1), let index2 = ranks.firstIndex(of: element2) {
            if index1 > index2 {
                return 1
            } else if index2 > index1 {
                return -1
            } else {
                return 0
            } 
        } else {
            fatalError("Error comparing elements: \(element1), \(element2)")
        }
    }

    /**
        Type For a Hand:
        - Five of a kind, where all five cards have the same label: AAAAA -> 6
        - Four of a kind, where four cards have the same label and one card has a different label: AA8AA -> 5
        - Full house, where three cards have the same label, and the remaining two cards share a different label: 23332 -> 4
        - Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98 -> 3
        - Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432 -> 2
        - One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4 -> 1
        - High card, where all cards' labels are distinct: 23456 -> 0
    
    */
    private static func type(for hand: String) -> Int {
        let map = Self.frequencyMap(for: hand)

        if Self.isFiveOfAKind(frequencyMap: map) {
            return 6
        } else if Self.isFourOfAKind(frequencyMap: map) {
            return 5
        } else if Self.isFullHouse(frequencyMap: map) {
            return 4
        } else if Self.isThreeOfAKind(frequencyMap: map) {
            return 3
        } else if Self.isTwoPair(frequencyMap: map) {
            return 2
        } else if Self.isOnePair(frequencyMap: map) {
            return 1
        } else {
            return 0
        }
    }

    private static func isFiveOfAKind(frequencyMap: [String: Int]) -> Bool {
        let allFive = frequencyMap.filter { $0.value == 5 }.count == 1
        if allFive {
            return true
        } else {
            let jokerCount = frequencyMap["J"] ?? 0
            // If we have another card whose frequency is (5 - jokerCount), this means
            // that if we add them with the jokers, it will create a 5 of a kind.
            return frequencyMap.filter { $0.value == (5 - jokerCount) }.count == 1
        }
    }

    private static func isFourOfAKind(frequencyMap: [String: Int]) -> Bool {
        let fourCount = frequencyMap.filter { $0.value == 4 }.count == 1
        if fourCount {
            return true
        } else {
            let jokerCount = frequencyMap["J"] ?? 0
            
            if jokerCount == 1 {
                let threePair = frequencyMap.filter { $0.value == 3 && $0.key != "J" }.count == 1
                return threePair
            } else if jokerCount == 2 {
                let twoPair = frequencyMap.filter { $0.value ==  2 && $0.key != "J" }.count == 1
                return twoPair
            } else if jokerCount == 3 {
                return true
            } else {
                return false 
            }
        }
    }

    private static func isFullHouse(frequencyMap: [String: Int]) -> Bool {
        let threeValue = frequencyMap.filter { $0.value == 3 }.count == 1
        let twoValue = frequencyMap.filter { $0.value == 2}.count == 1
        if threeValue && twoValue {
            return true
        } else {
            let jokerCount = frequencyMap["J"] ?? 0
            if jokerCount == 1 {
                /** 
                XJYYY // Joker Count == 1
                XXYYJ // Joker Count == 1 
                */
                let isTwoPair = frequencyMap.filter { $0.value == 2 && $0.key != "J" }.count == 2
                return threeValue || isTwoPair
            } else if jokerCount == 2 {
                /**
                 XXYJJ // Joker Count == 2
                */
                let isTwoPair = frequencyMap.filter { $0.value == 2 && $0.key != "J" }.count == 2
                return isTwoPair    
            } else {
                return false
            }
        }
    }

    private static func isThreeOfAKind(frequencyMap: [String: Int]) -> Bool {
        // This only works because we are checking for the above cases.
        let threePair = frequencyMap.filter { $0.value == 3 }.count == 1
        if threePair {
            return true
        } else {
            let jokerCount = frequencyMap["J"] ?? 0
            if jokerCount == 1 {
                let onePair = frequencyMap.filter { $0.value == 2 && $0.key != "J" }.count == 1
                return onePair
            } else if jokerCount == 2 {
                return true // If there are two jokers and the above hands don't exist, this is always true.
            } else {
                return false
            }
            /**
            XX J YZ // Joker Count == 1
            X JJ YZ // Joker Count == 2
            JJJ Y Z // Joker Count == 3, original logic
            */
        }
    }

    private static func isTwoPair(frequencyMap: [String: Int]) -> Bool {
        let twoPair = frequencyMap.filter { $0.value == 2 }.count == 2
        if twoPair {
            return true
        } else {
            let jokerCount = frequencyMap["J"] ?? 0
            if jokerCount == 1 {
                let onePair = frequencyMap.filter { $0.value == 2 && $0.key != "J" }.count == 1
                return onePair
            } else {
                return false
            }
            /**
            XX J Y Z // Joker Count == 1    
            */
        }
    }

    private static func isOnePair(frequencyMap: [String: Int]) -> Bool {
        let onePair = frequencyMap.filter { $0.value == 2 }.count == 1
        if onePair {
            return true
        } else {
            let jokerCount = frequencyMap["J"] ?? 0
            return jokerCount > 0
        }
    }

    private static func frequencyMap(for hand: String) -> [String: Int] {
        let elements = hand.map { String($0) }
        var map: [String: Int] = [:]

        for element in elements {
            if let value = map[element] {
                map[element] = value + 1
            } else {
                map[element] = 1
            }
        }

        return map
    }
}
