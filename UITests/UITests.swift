//
//  SpartaConnectUITests.swift
//  SpartaConnectUITests
//
//  Created by Sparta Science on 6/2/20.
//  Copyright © 2020 Sparta Science. All rights reserved.
//

import XCTest

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
        let app = XCUIApplication()
        app.launch()
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        app.dialogs["alert"].buttons["OK"].click()
        _ = app.dialogs["Software Update"].waitForExistence(timeout: 10)
        XCTAssert(app.dialogs["Software Update"].staticTexts["Version 1.3.1 (3/26/17)"].exists, "should find release notes")
        app.dialogs["Software Update"].buttons["Install Update"].click()
        app.dialogs["alert"].buttons["Cancel Update"].click()
    }

    func XtestLaunchPerformance() throws {
        measure {
            XCUIApplication().launch()
        }
    }
}
