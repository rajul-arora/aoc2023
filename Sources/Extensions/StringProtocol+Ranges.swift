import Foundation

// https://gist.github.com/robertmryan/7fc421b905d22be5063528e64676529a
extension StringProtocol where Index == String.Index {
    func ranges<T: StringProtocol>(of substring: T, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let result = range(of: substring, options: options, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(result)
        }
        return ranges
    }

    func numberRanges() -> [(Int, Int)] {
        var ranges: [(Int, Int)] = []
        var digitStart: Int = -1

        self.enumerated().forEach { index, character in
            if let _ = Int(String(character)) {
                if digitStart == -1 {
                    digitStart = index
                } 
            } else {
                if digitStart != -1 {
                    ranges.append((digitStart, index - 1 ))
                    digitStart = -1         
                }
            }
        }

        if digitStart != -1 {
            ranges.append((digitStart, count - 1))
        }

        return ranges   
    }
}

