import SwiftUI
internal import UniformTypeIdentifiers

let home = String(cString: getpwuid(getuid()).pointee.pw_dir)

struct ContentView: View {
    @State private var battleSizeValue: Double = 2
    @State private var gameVersion = "..."
    
    private var trackColor: Color {
        switch battleSizeValue {
            case ..<20: return .green
            case ..<500: return .yellow
            default: return .red
        }
    }

    var body: some View {
        VStack(){
            GroupBox {
                VStack(spacing: 16) {
                        Slider(value: $battleSizeValue, in: 1...998) {
                            
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("998")
                        }
                        .tint(trackColor)
                    
                        HStack(spacing: 4) {
                            Text("Current battle size:")
                            TextField("", value: $battleSizeValue, format: .number.precision(.fractionLength(0)))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 70)
                                .multilineTextAlignment(.trailing)
                                .focusable(false)
                            Spacer()
                            Text("Real game value: \(realBattleSizeInGame(battleSizeValue))")
                        }
                    }
                    .padding()
            } label: {
                Text("Battle Size")
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding()
            
            HStack() {
                Text("Warning: values above 1000 in **Real game value** can cause game crashes and/or bad performance")
                    .foregroundStyle(.red)
                    .font(.system(size: 7))
                Spacer()
            }
            .padding(Edge.Set.horizontal)
            
            HStack(alignment: .center) {
                Text("M&B version: \(gameVersion)")
                Spacer()
                Button("Save and exit") {
                    saveAndExit(battleSize: battleSizeValue)
                }
                Button("exit"){
                    quitApp()
                }
            }
            .padding()
        }
        .task {
            if let n = Double(getValueFromGameFiles(
                pathToFile: "Library/Application Support/MBWarband/rgl_config.txt",
                regex: #"battle_size = (\d+\.\d{4})"#
            )) {
                battleSizeValue = n
            }
            
            gameVersion = getValueFromGameFiles(pathToFile: "Library/Application Support/Steam/steamapps/common/MountBlade Warband/Mount and Blade.app/Contents/Resources/rgl_log.txt", regex: #"Version:\s+(\d+\.\d+)"#)
        }
    }
}

func realBattleSizeInGame(_ battleSize: Double) -> Int {
    let n = min(Int(battleSize.rounded()), 998)
    return 120 * n + 30
}

func getValueFromGameFiles(pathToFile: String, regex: String) -> String {
    let url = URL(fileURLWithPath: home)
        .appendingPathComponent(pathToFile)
    
    do {
        let content = try String(contentsOf: url, encoding: .utf8)
        
        let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
        
        let range = NSRange(content.startIndex..., in: content)

        guard let match = regex.firstMatch(in: content, options: [], range: range),
        let faixa = Range(match.range(at: 1), in: content) else { return "" }

        return String(content[faixa])
    } catch {
        print("Error: \(error)")
    }
    
    return ""
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
        print("Error: \(error)")
    }
    
    quitApp()
}

func quitApp() {
    NSApplication.shared.terminate(nil)
}

#Preview {
    ContentView()
}
