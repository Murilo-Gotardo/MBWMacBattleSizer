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
            do {
                let battleSize = try getValueFromGameFiles(
                    pathToFile: "Library/Application Support/MBWarband/rgl_config.txt",
                    regex: #"battle_size = (\d+\.\d{4})"#
                )
                if let n = Double(battleSize) {
                    battleSizeValue = n
                }

                gameVersion = try getValueFromGameFiles(
                    pathToFile: "Library/Application Support/Steam/steamapps/common/MountBlade Warband/Mount and Blade.app/Contents/Resources/rgl_log.txt",
                    regex: #"Version:\s+(\d+\.\d+)"#
                )
            } catch {
                showErrorModal(appError: error)
            }
        }
    }
}

func realBattleSizeInGame(_ battleSize: Double) -> Int {
    let n = min(Int(battleSize.rounded()), 998)
    return 120 * n + 30
}

func quitApp() {
    NSApplication.shared.terminate(nil)
}

#Preview {
    ContentView()
}
