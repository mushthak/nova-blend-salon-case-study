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
        
        app.launch()
        
        XCTAssertEqual(app.cells.count, 4)
    }
}
