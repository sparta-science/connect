//
//  SpartaConnectUITests.swift
//  SpartaConnectUITests
//
//  Created by Sparta Science on 6/2/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import XCTest
import HttpSwift

let kDefaultTimeout: TimeInterval = 5

class UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAutoUpgrade() throws {
        let server = Server()
        let serverHome = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("mockHttpServer")
        server.fileBrowser(in: serverHome.path)

        server.middlewares.append(contentsOf: <#T##Sequence#>)
        try server.run(port: 8000)
        RunLoop.current.run(until: .distantFuture)
        let app = XCUIApplication()
        app.launch()
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        app.dialogs["alert"].buttons["OK"].click()
        let updateDialog = app.dialogs["Software Update"]
        updateDialog.waitToAppear()
//        updateDialog.staticTexts["Version 1.3.1 (3/26/17)"].waitToAppear()
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
