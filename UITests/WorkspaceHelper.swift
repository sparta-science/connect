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
        verify(workspace.urlForApplication(toOpen: url) == url)
        verifyAppRegistedToLaunch(url: url)
        let config = launchConfiguration(arguments: arguments)
        retry("launching app", upToTimes: 5, timeout: .install) { checkError in
            self.workspace.open(url, configuration: config) { _, err in
                checkError(err)
            }
        }
    }
}

func retry(_ reason: String,
           upToTimes: Int,
           timeout: Timeout = .test,
           block: @escaping (@escaping (Error?) -> Void) -> Void) {
    wait(reason, timeout: timeout) { done in
        retry(times: upToTimes) { shouldRetry in
            block { mayBeError in
                if !shouldRetry(mayBeError) {
                    done()
                }
            }
        }
    }
}

func retry(times: Int, block: @escaping (_ onError: @escaping (Error?) -> Bool) -> Void) {
    block { error in
        if error != nil {
            if times > 0 {
                RareEventMonitor.log(.hadToRetryLaunching)
                RunLoop.run(for: 1)
                NSLog("retrying up to \(times) times")
                retry(times: times - 1, block: block)
            } else {
                verifyNoError(error, "failed to retry")
            }
            return true
        }
        return false
    }
}
