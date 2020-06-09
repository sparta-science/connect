import XCTest

class TempAppHelper {
    let tempUrl = URL(fileURLWithPath: "/tmp/SpartaConnect.app")
    let fileHelper = FileHelper()
    func tempApp() -> XCUIApplication {
        XCUIApplication(url: tempUrl)
    }
    
    func prepare() {
        cleanup()
        let builtApp = XCUIApplication()
        let builtAppPath = builtApp.value(forKeyPath: "_applicationImpl._path") as! String
        fileHelper.copy(path: builtAppPath, to: tempUrl)
    }
    func cleanup() {
        fileHelper.remove(url: tempUrl)
    }
}
