import Foundation

class SSManager: ObservableObject {
    @Published var isRunning = false
    private var process: Process?

    func start(sslocalPath: String, configPath: String) {
        print("[SSManager] start called: sslocal=\(sslocalPath), config=\(configPath)")
        guard !isRunning else { print("[SSManager] already running"); return }
        guard FileManager.default.fileExists(atPath: sslocalPath) else {
            print("[SSManager] sslocal not found: \(sslocalPath)")
            return
        }
        guard FileManager.default.fileExists(atPath: configPath) else {
            print("[SSManager] config not found: \(configPath)")
            return
        }

        let p = Process()
        p.executableURL = URL(fileURLWithPath: sslocalPath)
        p.arguments = ["-c", configPath]

        // Redirect output to /dev/null to avoid blocking
        let nullFile = FileHandle(forWritingAtPath: "/dev/null")
        p.standardOutput = nullFile
        p.standardError = nullFile

        do {
            try p.run()
            process = p
            isRunning = true
        } catch {
            print("Failed to start sslocal: \(error)")
        }
    }

    func stop() {
        guard isRunning, let p = process else { return }
        p.terminate()
        process = nil
        isRunning = false
    }
}
