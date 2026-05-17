import Foundation

class SSManager: ObservableObject {
    @Published var isRunning = false
    private var startedPIDs: Set<pid_t> = []

    func checkRunning() {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
        task.arguments = ["-x", "sslocal"]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            let pids = output.split(separator: "\n").compactMap { pid_t($0.trimmingCharacters(in: .whitespaces)) }
            isRunning = !pids.isEmpty
        } catch {
            isRunning = false
        }
    }

    func start(sslocalPath: String, configPath: String) {
        guard FileManager.default.fileExists(atPath: sslocalPath) else { return }
        guard FileManager.default.fileExists(atPath: configPath) else { return }

        let p = Process()
        p.executableURL = URL(fileURLWithPath: sslocalPath)
        p.arguments = ["-c", configPath]

        let nullFile = FileHandle(forWritingAtPath: "/dev/null")
        p.standardOutput = nullFile
        p.standardError = nullFile

        do {
            try p.run()
            startedPIDs.insert(p.processIdentifier)
            isRunning = true
        } catch {
            print("Failed to start sslocal: \(error)")
        }
    }

    func stop() {
        // Kill processes we started
        for pid in startedPIDs {
            kill(pid, SIGTERM)
        }
        startedPIDs.removeAll()

        // Also kill any other sslocal processes
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pkill")
        task.arguments = ["-x", "sslocal"]
        try? task.run()

        isRunning = false
    }
}
