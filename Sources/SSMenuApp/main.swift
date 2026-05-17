import Cocoa

let bundleID = "com.guidong.SSMenuApp"
let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
let myPID = ProcessInfo.processInfo.processIdentifier
if let existing = runningApps.first(where: { $0.processIdentifier != myPID }) {
    existing.activate(options: .activateIgnoringOtherApps)
    exit(0)
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
