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
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 13.50), "1:50 pm")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 0.00), "12:00 am")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 12.00), "12:00 pm")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 23.59), "11:59 pm")
        XCTAssertEqual(TimeFormatter.convertTo12HourFormat(from: 20.30), "8:30 pm")
        XCTAssertNil(TimeFormatter.convertTo12HourFormat(from: 24.00)) // Invalid time
    }
    
}
