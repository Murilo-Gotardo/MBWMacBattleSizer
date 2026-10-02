import SwiftUI

@main struct MBWMacBattleSizer: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 450, height: 200)
        }
        .windowResizability(.contentSize)
    }
}
