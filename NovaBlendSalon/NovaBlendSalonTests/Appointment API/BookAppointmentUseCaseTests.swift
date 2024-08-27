//
//  BookAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 27/08/24.
//

import Foundation
import XCTest

private class RemoteAppointmentBooker {
}

private class HTTPClientSpy {
    var requestedURL: URL?
}

final class BookAppointmentUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestAppointment() {
        let client = HTTPClientSpy()
        let _ = RemoteAppointmentBooker()
        
        XCTAssertNil(client.requestedURL)
    }
}


