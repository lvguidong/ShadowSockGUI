import Cocoa

let APP_VERSION = "1.0"
let APP_AUTHOR = "guidong"

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuItemValidation {
    var statusItem: NSStatusItem!
    let manager = SSManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let icon = NSImage(systemSymbolName: "antenna.radiowaves.left.and.right", accessibilityDescription: "Shadowsocks") {
            icon.isTemplate = true
            statusItem.button?.image = icon
        }

        let menu = NSMenu()
        statusItem.menu = menu

        buildMenu()
    }

    func buildMenu() {
        guard let menu = statusItem.menu else { return }
        menu.removeAllItems()

        // Status
        let statusText = manager.isRunning ? "Running" : "Stopped"
        let color = manager.isRunning ? NSColor(red: 0.0, green: 0.85, blue: 0.0, alpha: 1.0) : NSColor(red: 0.95, green: 0.05, blue: 0.05, alpha: 1.0)
        let statusAttr = NSAttributedString(
            string: statusText,
            attributes: [
                .foregroundColor: color,
                .font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
            ]
        )
        let statusMI = NSMenuItem()
        statusMI.attributedTitle = statusAttr
        statusMI.action = #selector(dummyAction)
        menu.addItem(statusMI)

        menu.addItem(NSMenuItem.separator())

        // Start
        let startMI = NSMenuItem(title: "Start", action: #selector(startSS), keyEquivalent: "")
        startMI.target = self
        startMI.identifier = NSUserInterfaceItemIdentifier("startAction")
        menu.addItem(startMI)

        // Stop
        let stopMI = NSMenuItem(title: "Stop", action: #selector(stopSS), keyEquivalent: "")
        stopMI.target = self
        stopMI.identifier = NSUserInterfaceItemIdentifier("stopAction")
        menu.addItem(stopMI)

        menu.addItem(NSMenuItem.separator())

        // sslocal path
        let sslocalPath = UserDefaults.standard.string(forKey: "ssLocalPath") ?? ""
        let sslocalMI = NSMenuItem(
            title: "sslocal: " + (sslocalPath.isEmpty ? "Not Set" : (sslocalPath as NSString).lastPathComponent),
            action: #selector(selectSSLocal),
            keyEquivalent: ""
        )
        sslocalMI.target = self
        sslocalMI.identifier = NSUserInterfaceItemIdentifier("sslocalPath")
        menu.addItem(sslocalMI)

        // Config
        let configPath = UserDefaults.standard.string(forKey: "ssConfigPath") ?? ""
        let configMI = NSMenuItem(
            title: "Config: " + (configPath.isEmpty ? "Not Set" : (configPath as NSString).lastPathComponent),
            action: #selector(selectConfig),
            keyEquivalent: ""
        )
        configMI.target = self
        configMI.identifier = NSUserInterfaceItemIdentifier("configPath")
        menu.addItem(configMI)

        // About
        let aboutMI = NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: "")
        aboutMI.target = self
        menu.addItem(aboutMI)

        // Quit
        menu.addItem(NSMenuItem.separator())
        let quitMI = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitMI.target = self
        menu.addItem(quitMI)
    }

    @objc func showAbout() {
        activateForModal {
            let alert = NSAlert()
            alert.messageText = "SSMenuApp"
            alert.informativeText = "Version \(APP_VERSION)\n\nA macOS menu bar app for shadowsocks-rust.\n\nAuthor: \(APP_AUTHOR)"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        switch menuItem.identifier?.rawValue {
        case "startAction":
            return !manager.isRunning
        case "stopAction":
            return manager.isRunning
        default:
            return true
        }
    }

    @objc func startSS() {
        guard let sslocalPath = UserDefaults.standard.string(forKey: "ssLocalPath"),
              !sslocalPath.isEmpty else {
            showAlert("Please set the sslocal path first.")
            return
        }
        guard let configPath = UserDefaults.standard.string(forKey: "ssConfigPath"),
              !configPath.isEmpty else {
            showAlert("Please set the config file path first.")
            return
        }
        manager.start(sslocalPath: sslocalPath, configPath: configPath)
        DispatchQueue.main.async { self.buildMenu() }
    }

    @objc func stopSS() {
        manager.stop()
        DispatchQueue.main.async { self.buildMenu() }
    }

    @objc func dummyAction() {}

    @objc func selectSSLocal() {
        activateForModal {
            let alert = NSAlert()
            alert.messageText = "Set sslocal path"
            alert.informativeText = "Enter the full path to the sslocal binary:"
            let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
            field.stringValue = UserDefaults.standard.string(forKey: "ssLocalPath") ?? "/opt/homebrew/bin/sslocal"
            alert.accessoryView = field
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            if alert.runModal() == .alertFirstButtonReturn {
                let path = field.stringValue.trimmingCharacters(in: .whitespaces)
                guard !path.isEmpty else { return }
                UserDefaults.standard.set(path, forKey: "ssLocalPath")
            }
        }
    }

    @objc func selectConfig() {
        activateForModal {
            let alert = NSAlert()
            alert.messageText = "Set config path"
            alert.informativeText = "Enter the full path to your Shadowsocks config JSON:"
            let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
            field.stringValue = UserDefaults.standard.string(forKey: "ssConfigPath") ?? ""
            alert.accessoryView = field
            alert.addButton(withTitle: "OK")
            alert.addButton(withTitle: "Cancel")
            if alert.runModal() == .alertFirstButtonReturn {
                let path = field.stringValue.trimmingCharacters(in: .whitespaces)
                guard !path.isEmpty else { return }
                UserDefaults.standard.set(path, forKey: "ssConfigPath")
            }
        }
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    private func activateForModal(_ block: () -> Void) {
        let savedPolicy = NSApp.activationPolicy()
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        block()
        NSApp.setActivationPolicy(savedPolicy)
    }

    private func showAlert(_ message: String) {
        activateForModal {
            let alert = NSAlert()
            alert.messageText = "Shadowsocks"
            alert.informativeText = message
            alert.runModal()
        }
    }
}
