import AppKit
import os.log

class WorkspaceHelper {
    let workspace = NSWorkspace.shared
    let securityHelper = SecurityHelper()

    private func verifyValidAppBundle(url: URL) {
        verify(try! workspace.type(ofFile: url.path) == kUTTypeApplicationBundle as String)
        securityHelper.verify(url: url)
    }

    private func launchConfiguration(arguments: [String]) -> NSWorkspace.OpenConfiguration {
        let config = NSWorkspace.OpenConfiguration()
        config.arguments = arguments
        config.activates = true
        config.allowsRunningApplicationSubstitution = true
        config.promptsUserIfNeeded = false
        config.addsToRecentItems = false
        config.architecture = CPU_TYPE_X86_64
        return config
    }

    func verifyAppRegistedToLaunch(url: URL) {
        verifyStatusSuccess(LSRegisterURL(url as CFURL, true),
                            "bundle should be registered")
    }

    func launch(url: URL, arguments: [String] = []) {
        verifyValidAppBundle(url: url)
        verifyAppRegistedToLaunch(url: url)
        let openApp = workspace.urlForApplication(toOpen: url)
        if #available(macOS 10.16, *) {
            verify(openApp == nil, "Big Sur 11.0 Beta (20A5343i)")
        } else {
            verify(openApp == url, "app to open was \(String(describing: openApp))")
        }
        let config = launchConfiguration(arguments: arguments)
        workspace.open(url, configuration: config) { _, error in
            verifyNoError(error, "failed to launch")
        }
    }
}
