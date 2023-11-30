import Foundation

enum Day1Error: LocalizedError {
    case unknown

    var errorDescription: String? {
        switch self {
            case .unknown:
                return "Unknown Error!"
        }
    }
}

struct Day1 {
    static func run(input: String) throws {
        throw Day1Error.unknown
    }
}
