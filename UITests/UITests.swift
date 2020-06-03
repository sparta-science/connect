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
        // UI tests must launch the application that they test.

        let app = XCUIApplication()
        app.launch()
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Help"].click()
        menuBarsQuery.menuItems["Check for updates..."].click()
        app.dialogs["alert"].buttons["OK"].click()
        app.dialogs["Software Update"].buttons["Install Update"].click()
        app.dialogs["alert"].buttons["Cancel Update"].click()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        measure {
            XCUIApplication().launch()
        }
    }
}
