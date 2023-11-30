import ArgumentParser
import Foundation

@main 
struct aoc2023: ParsableCommand {

    @Argument(help: "Select which AOC2023 day to run")
    var day: Int

    @Argument(help: "input data path")
    var pathToInputFile: String

    mutating func run() throws {
        guard day.isValidDayInDecember else {
            throw CommandLineError.invalidDay
        }

        let baseDirectory = FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: "\(baseDirectory)/\(pathToInputFile)")
        let input = try String(contentsOf: url, encoding: .utf8)
        
        debugPrint(input)

        try runDay(day: day, input: input)
    }

    private func runDay(day: Int, input: String) throws {
        switch day {
            case 1:
                try Day1.run(input: input)
            default:
                break
       }
    }
}

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
