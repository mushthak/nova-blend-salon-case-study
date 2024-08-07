//
//  NovaBlendAppUIAcceptanceTests.swift
//  NovaBlendAppUITests
//
//  Created by Mushthak Ebrahim on 04/08/24.
//

import XCTest

final class NovaBlendAppUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteSalonsWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launchArguments = ["-reset", "-connectivity", "online"]
        app.launch()
        
        if app.cells.element.waitForExistence(timeout: 2) {
            XCTAssertEqual(app.cells.count, 4)
        }
    }
    
    func test_onLaunch_displaysCachedRemoteSalonsWhenCustomerHasNoConnectivity() {
        let onlineApp = XCUIApplication()
        onlineApp.launchArguments = ["-reset", "-connectivity", "online"]
        onlineApp.launch()
        
        let offlineApp = XCUIApplication()
        offlineApp.launchArguments = ["-connectivity", "offline"]
        offlineApp.launch()
        
        if offlineApp.cells.element.waitForExistence(timeout: 2) {
            XCTAssertEqual(offlineApp.cells.count, 4)
        }
        XCTAssertEqual(offlineApp.cells.count, 4)
    }
    
    func test_onLaunch_displaysEmptySalonsWhenCustomerHasNoConnectivityAndNoCache() {
        let app = XCUIApplication()
        app.launchArguments = ["-reset", "-connectivity", "offline"]
        app.launch()
        
        XCTAssertEqual(app.cells.count, 0)
    }
}
