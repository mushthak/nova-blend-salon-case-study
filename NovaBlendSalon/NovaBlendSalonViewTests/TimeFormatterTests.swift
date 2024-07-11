//
//  TimeFormatterTests.swift
//  NovaBlendSalonViewTests
//
//  Created by Mushthak Ebrahim on 11/07/24.
//

import XCTest
import NovaBlendSalonView

final class TimeFormatterTests: XCTestCase {
    
    func test_convertTo12HourFormat() {
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 13.50), "1:50 PM")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 0.00), "12:00 AM")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 12.00), "12:00 PM")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 23.59), "11:59 PM")
        XCTAssertNil(TimeFormatter.convertTo12HourFormat(from: 24.00)) // Invalid time
    }
    
}
