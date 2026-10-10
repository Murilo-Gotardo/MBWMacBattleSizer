import Foundation
import AppKit

enum GameFileError: LocalizedError {
    case valueNotFound(file: String, pattern: String)

    var errorDescription: String? {
        switch self {
        case .valueNotFound(let file, _):
            return "Could not find the expected value in \((file as NSString).lastPathComponent)."
        }
    }

    var debugDescription: String {
        switch self {
        case .valueNotFound(let file, let pattern):
            return "No match for \"\(pattern)\" in \(file)"
        }
    }
}

@MainActor
func showErrorModal(appError: Error) {
    if let e = appError as? GameFileError {
        FileLogger.shared.error(e.debugDescription)
    } else {
        FileLogger.shared.error(String(describing: appError))
    }
    
    let alert = NSAlert()
    alert.messageText = "Ops, that’s an error..."
    alert.informativeText = "\(appError.localizedDescription) You probably have some problems with your game files"
    alert.alertStyle = .critical
    
    alert.addButton(withTitle: "Close")
    alert.addButton(withTitle: "Show Log")
    
    let answer = alert.runModal()
    switch answer {
        case .alertSecondButtonReturn:
            NSWorkspace.shared.activateFileViewerSelecting([FileLogger.shared.url])
            quitApp()
        default:
            quitApp()
    }
}
