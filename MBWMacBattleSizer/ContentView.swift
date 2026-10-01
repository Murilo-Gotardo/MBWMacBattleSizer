import SwiftUI
import Playgrounds
internal import UniformTypeIdentifiers

let home = String(cString: getpwuid(getuid()).pointee.pw_dir)

struct ContentView: View {
    @State private var battleSizeValue: Double = 100

    var body: some View {
        VStack(){
            GroupBox("Battle Size") {
                VStack(spacing: 16) {
                        Slider(value: $battleSizeValue, in: 2...1000, step: 1)
                        Text("Valor: \(Int(battleSizeValue))")
                    }
                    .padding()
                
            }.padding()
            
            HStack(alignment: .bottom) {
                Text( "M&B version: \(getGameVersion())")
                Spacer()
                Button("Save and exit"){
                    saveAndExit(battleSize: $battleSizeValue.wrappedValue)
                }
                Button("exit"){
                    exit()
                }
            }.padding()
        }
        
    }
}

func getGameVersion() -> String {
    let url = URL(fileURLWithPath: home)
        .appendingPathComponent("Library/Application Support/Steam/steamapps/common/MountBlade Warband/Mount and Blade.app/Contents/Resources/rgl_log.txt")
    
    do {
        let conteudo = try String(contentsOf: url, encoding: .utf8)
        
        guard conteudo.contains("Version:") else { return "Version not found" }
        
        let regex = try! NSRegularExpression(pattern: #"Version:\s+(\d+\.\d+)"#, options: [.caseInsensitive])
        
        let range = NSRange(conteudo.startIndex..., in: conteudo)

        guard let match = regex.firstMatch(in: conteudo, options: [], range: range),
        let faixa = Range(match.range(at: 1), in: conteudo) else { return "" }

        return String(conteudo[faixa])
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
        print("Erro: \(error)")
    }
    
    exit()
}

func exit() {
    NSApplication.shared.terminate(nil)
}

#Preview {
    ContentView()
}
