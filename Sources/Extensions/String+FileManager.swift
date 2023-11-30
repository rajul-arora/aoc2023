import Foundation

extension String {
    init(
        fileFromRelativePath pathToInputFile: String, 
        fileManager: FileManager = .default
    ) throws {
        let baseDirectory = fileManager.currentDirectoryPath
        let url = URL(fileURLWithPath: "\(baseDirectory)/\(pathToInputFile)")
        self = try String(contentsOf: url, encoding: .utf8) 
    }
}
