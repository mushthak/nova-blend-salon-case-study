//
//  CacheAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/09/24.
//

import Foundation
import XCTest
import NovaBlendSalon

private class AppointmentStoreSpy {
    var receivedMessages = 0
}

private class LocalAppointmentLoader {
    let store: AppointmentStoreSpy
    
    init(store: AppointmentStoreSpy) {
        self.store = store
    }
    
    func save(_ appointment: SalonAppointment) {
        store.receivedMessages += 1
    }
}

final class CacheAppointmentUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let store = AppointmentStoreSpy()
        let _ = LocalAppointmentLoader(store: store)
        XCTAssertEqual(store.receivedMessages, 0)
    }
    
    func test_save_requestsNewCacheInsertion() {
        let store = AppointmentStoreSpy()
        let sut = LocalAppointmentLoader(store: store)
        
        let appointment = makeAppointmentItem()
        
        sut.save(appointment)
        XCTAssertEqual(store.receivedMessages, 1)
    }
    
    //MARK: Helpers
    private func makeAppointmentItem() -> SalonAppointment {
        return SalonAppointment(id: UUID(),
                                time: Date.init().roundedToSeconds(),
                                phone: "a phone number",
                                email: nil,
                                notes: nil)
    }
}

private extension Date {
    func roundedToSeconds() -> Date {
        let timeInterval = TimeInterval(Int(self.timeIntervalSince1970))
        return Date(timeIntervalSince1970: timeInterval)
    }
}
