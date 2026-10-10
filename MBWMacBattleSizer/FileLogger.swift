import Foundation

final class FileLogger {
    static let shared = FileLogger()

    let url: URL
    private let queue = DispatchQueue(label: "filelogger")
    private let formatter = ISO8601DateFormatter()

    private init() {
        let dir = FileManager.default
            .urls(for: .libraryDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Logs/MBWMacBattleSizer", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        url = dir.appendingPathComponent("app.log")
    }

    func error(_ message: String) { write("ERROR", message) }
    func info(_ message: String)  { write("INFO", message) }

    private func write(_ level: String, _ message: String) {
        queue.sync {
            let line = "\(formatter.string(from: Date())) [\(level)] \(message)\n"
            guard let data = line.data(using: .utf8) else { return }

            if let handle = try? FileHandle(forWritingTo: url) {
                defer { try? handle.close() }
                _ = try? handle.seekToEnd()
                try? handle.write(contentsOf: data)
            } else {
                try? data.write(to: url)
            }
        }
    }
}
