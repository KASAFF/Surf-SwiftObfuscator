import ArgumentParser

struct ObfuscateStrings: ParsableCommand {

    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "strings")
    }

    @Option(name: .shortAndLong, help: "Path to the file where you want to obfuscate strings.")
    var filePath: String

    @Option(name: .shortAndLong, help: "Salt that the strings should be obfuscated with.")
    var salt: String

    @Option(name: .shortAndLong, help: "The line number on which strings should be obfuscated. By default, all lines will be obfuscated.")
    var line: Int?

    @Option(name: .long, help: "This property used for obfuscate SwiftGen localizable strings")
    var swiftGen: Bool?

    mutating func run() throws {
        let contents = try String(contentsOfFile: filePath, encoding: .utf8)
        let obfuscator = StringObfuscator(contents: contents, salt: salt)
        let newContents: String
        if let swiftGen {
            newContents = obfuscator.obfuscateLocalizationValues()
        } else {
            newContents = try obfuscator.obfuscate(line: line)
        }
        try newContents.write(toFile: filePath, atomically: false, encoding: .utf8)
    }

}
