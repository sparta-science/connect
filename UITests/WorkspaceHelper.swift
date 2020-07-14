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

    func launch(url: URL, arguments: [String] = []) {
        verifyValidAppBundle(url: url)
        verify(workspace.urlForApplication(toOpen: url) == url)
        let config = launchConfiguration(arguments: arguments)
        LaunchService.waitForAppToBeReadyForLaunch(at: url)
        wait("app is running", timeout: .install) { done in
            retry(times: 5) { onError in
                self.workspace.open(url, configuration: config) { _, err in
                    if !onError(err) {
                        done()
                    } else {
                        RareEventMonitor.log(.hadToRetryLaunching)
                    }
                }
            }
        }
    }
}

func retry(times: Int, block: @escaping (_ onError: @escaping (Error?) -> Bool) -> Void) {
    block { error in
        if error != nil {
            if times > 0 {
                RunLoop.run(for: 1)
                NSLog("retrying \(times) time")
                retry(times: times - 1, block: block)
            } else {
                verifyNoError(error, "failed to retry")
            }
            return true
        }
        return false
    }
}
