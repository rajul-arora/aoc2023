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

        let input = try String(fileFromRelativePath: pathToInputFile) 
        try runDay(day: day, input: input)
    }

    private func runDay(day: Int, input: String) throws {
        switch day {
            case 1:
                try Day1.run(input: input)
            case 2:
                try Day2.run(input: input)
            case 3:
                try Day3.run(input: input)
            case 4: 
                try Day4.run(input: input)
            default:
                break
       }
    }
}
