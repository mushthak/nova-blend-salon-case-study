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
    var error: Error?
}

private class LocalAppointmentLoader {
    let store: AppointmentStoreSpy
    
    enum Error: Swift.Error {
        case insertion
    }
    
    init(store: AppointmentStoreSpy) {
        self.store = store
    }
    
    func save(_ appointment: SalonAppointment) throws{
        store.receivedMessages += 1
        if store.error != nil {
            throw Error.insertion
        }
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
        
        do {
            try sut.save(appointment)
            XCTAssertEqual(store.receivedMessages, 1)
        } catch  {
            XCTFail("Expect to succeed but got \(error) instead")
        }
    }
    
    func test_save_failsOnInsertionError() async {
        let store = AppointmentStoreSpy()
        store.error = anyError()
        let sut = LocalAppointmentLoader(store: store)
        
        let appointment = makeAppointmentItem()
        
        do {
            try sut.save(appointment)
            XCTFail("Expect to throw \(LocalAppointmentLoader.Error.insertion) but got success instead")
        } catch  {
            XCTAssertEqual(error as? LocalAppointmentLoader.Error, .insertion)
        }        
    }
    
    func test_save_succeedsOnSuccessfullCacheInsertion() async {
        let store = AppointmentStoreSpy()
        let sut = LocalAppointmentLoader(store: store)
        
        let appointment = makeAppointmentItem()
        
        do {
            try sut.save(appointment)
        } catch  {
            XCTFail("Expect to succeed but got \(error) instead")
        }
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
