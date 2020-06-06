//
//  SpartaConnectUITests.swift
//  SpartaConnectUITests
//
//  Created by Sparta Science on 6/2/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import XCTest

let kDefaultTimeout: TimeInterval = 5

class UITests: XCTestCase {
    var mockServer: Process!
    var interruptionMonitor: NSObjectProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        interruptionMonitor = addUIInterruptionMonitor(withDescription: "port mapper deamon firewall") { element -> Bool in
            let title = "Do you want the application “Python.app” to accept incoming network connections?"
            if element.staticTexts[title].exists {
                element.buttons["Allow"].click()
                return true
            } else {
                return false
            }
        }
        try startMockServer()
    }

    override func tearDownWithError() throws {
        removeUIInterruptionMonitor(interruptionMonitor)
        mockServer.terminate()
        try super.tearDownWithError()
    }
    
    func startMockServer() throws {
        mockServer = Process()
        mockServer.executableURL = URL(fileURLWithPath: "/bin/bash")
        mockServer.arguments = ["start-mock-server.sh"]
        let serverHome = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
        mockServer.currentDirectoryURL = serverHome
        try mockServer.run()
    }

    func testAutoUpgrade() throws {

        let app = XCUIApplication()
        app.launch()
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        let updateDialog = app.dialogs["Software Update"]
        updateDialog.waitToAppear()
        updateDialog.staticTexts["Initial Release."].waitToAppear()
        updateDialog.buttons["Install Update"].click()
        
        let updatingWindow = app.windows["Updating SpartaConnect"]
        updatingWindow.staticTexts["Ready to Install"].waitToAppear()
        updatingWindow.buttons["Install and Relaunch"].waitToAppear().click()
        app.dialogs["alert"].buttons["Cancel Update"].click()
    }

    func XtestLaunchPerformance() throws {
        measure {
            XCUIApplication().launch()
        }
    }
}
