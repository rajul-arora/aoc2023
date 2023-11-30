import Foundation

enum CommandLineError: LocalizedError {
    case invalidDay
    case invalidFileUrl
    case fileEmpty

    var errorDescription: String? {
        switch self {
            case .invalidDay:
                return "Invalid day in December. Please select a valid number."
            case .invalidFileUrl:
                return "Invalid file URL"
            case .fileEmpty:
                return "Input file empty."
        }
    }
}
