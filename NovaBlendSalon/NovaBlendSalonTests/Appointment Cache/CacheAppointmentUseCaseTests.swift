//
//  CacheAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/09/24.
//

import Foundation
import XCTest
import NovaBlendSalon

private protocol SalonAppointmentCache {
    func save(_ appointment: SalonAppointment) throws
}

private protocol AppointmentStore {
    func insert(_ appointment: SalonAppointment) throws
}

private class AppointmentStoreSpy: AppointmentStore {
    var receivedMessages = 0
    var error: AppointmentStoreSpy.Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    enum Error: Swift.Error {
        case insertionError
    }
    
    func insert(_ appointment: SalonAppointment) throws {
        receivedMessages += 1
        if let error {
            throw error
        }
    }
}

private class LocalAppointmentLoader: SalonAppointmentCache {
    let store: AppointmentStoreSpy
    
    enum Error: Swift.Error {
        case insertion
    }
    
    init(store: AppointmentStoreSpy) {
        self.store = store
    }
    
    func save(_ appointment: SalonAppointment) throws{
        do {
            try store.insert(appointment)
        } catch {
            throw Error.insertion
        }
    }
}

final class CacheAppointmentUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, 0)
    }
    
    func test_save_requestsNewCacheInsertion() {
        let (sut, store) = makeSUT()
        let appointment = makeAppointmentItem()
        
        do {
            try sut.save(appointment)
            XCTAssertEqual(store.receivedMessages, 1)
        } catch  {
            XCTFail("Expect to succeed but got \(error) instead")
        }
    }
    
    func test_save_failsOnInsertionError() async {
        let (sut, _) = makeSUT(with: insetionError())
        let appointment = makeAppointmentItem()
        
        do {
            try sut.save(appointment)
            XCTFail("Expect to throw \(LocalAppointmentLoader.Error.insertion) but got success instead")
        } catch  {
            XCTAssertEqual(error as? LocalAppointmentLoader.Error, .insertion)
        }        
    }
    
    func test_save_succeedsOnSuccessfullCacheInsertion() async {
        let (sut, _) = makeSUT()
        let appointment = makeAppointmentItem()
        
        do {
            try sut.save(appointment)
        } catch  {
            XCTFail("Expect to succeed but got \(error) instead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(with error: AppointmentStoreSpy.Error? = nil) -> (sut: LocalAppointmentLoader, store: AppointmentStoreSpy ) {
        let store = AppointmentStoreSpy(error: error)
        return (sut: LocalAppointmentLoader(store: store), store: store)
    }
    
    private func makeAppointmentItem() -> SalonAppointment {
        return SalonAppointment(id: UUID(),
                                time: Date.init().roundedToSeconds(),
                                phone: "a phone number",
                                email: nil,
                                notes: nil)
    }
    
    private func insetionError() -> AppointmentStoreSpy.Error {
        return .insertionError
    }
}

private extension Date {
    func roundedToSeconds() -> Date {
        let timeInterval = TimeInterval(Int(self.timeIntervalSince1970))
        return Date(timeIntervalSince1970: timeInterval)
    }
}
