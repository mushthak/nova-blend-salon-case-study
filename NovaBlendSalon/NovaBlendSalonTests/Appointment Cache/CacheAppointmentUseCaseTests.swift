//
//  CacheAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/09/24.
//

import Foundation
import XCTest

private class AppointmentStoreSpy {
    var receivedMessages = 0
}

private class LocalAppointmentLoader {
    let store: AppointmentStoreSpy
    
    init(store: AppointmentStoreSpy) {
        self.store = store
    }
}

final class CacheAppointmentUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let store = AppointmentStoreSpy()
        let _ = LocalAppointmentLoader(store: store)
        XCTAssertEqual(store.receivedMessages, 0)
    }
}
