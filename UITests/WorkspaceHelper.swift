import AppKit

class WorkspaceHelper {
    let workspace = NSWorkspace.shared
    
    private func checkIfApp(url: URL) {
        verify(try! workspace.type(ofFile: url.path) == kUTTypeApplicationBundle as String)
    }
    
    private func launchConfiguration(arguments:[String]) -> NSWorkspace.OpenConfiguration {
        let config = NSWorkspace.OpenConfiguration()
        config.arguments = arguments
        config.activates = true
        config.allowsRunningApplicationSubstitution = true
        config.promptsUserIfNeeded = false
        config.addsToRecentItems = false
        return config
    }
    
    func launch(url: URL, arguments:[String] = []) {
        checkIfApp(url: url)
        verify(workspace.urlForApplication(toOpen: url) == url)
        let config = launchConfiguration(arguments: arguments)
        LaunchService.waitForAppToBeReadyForLaunch(at: url)
        wait("app is running") { done in
            workspace.open(url, configuration: config) { app, err in
                verifyNoError(err, "opening url: \(url)")
                done()
            }
        }
    }
}
