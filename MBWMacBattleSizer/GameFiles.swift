import Foundation

func getValueFromGameFiles(pathToFile: String, regex pattern: String) throws -> String {
    let url = URL(fileURLWithPath: home)
        .appendingPathComponent(pathToFile)
    
    let content = try String(contentsOf: url, encoding: .utf8)
    
    let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
    
    let range = NSRange(content.startIndex..., in: content)

    guard let match = regex.firstMatch(in: content, range: range),
        match.numberOfRanges > 1,
        let faixa = Range(match.range(at: 1), in: content)
    else {
        throw GameFileError.valueNotFound(file: pathToFile, pattern: pattern)
    }

    return String(content[faixa])
}

func saveAndExit(battleSize: Double) -> Void {
    let url = URL(fileURLWithPath: home)
        .appendingPathComponent("Library/Application Support/MBWarband/rgl_config.txt")
    
    do {
        var fileContent = try String(contentsOf: url, encoding: .utf8)
        
        guard fileContent.contains("battle_size = ") else { return }

        let regex = /battle_size = \d+/
        fileContent.replace(regex, with: "battle_size = \(Int(battleSize))")
        try fileContent.write(to: url, atomically: false, encoding: .utf8)
    } catch {
        showErrorModal(appError: error)
    }
    
    quitApp()
}
