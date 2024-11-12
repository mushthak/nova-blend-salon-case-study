//
//  LoadAppointmentsFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 12/11/24.
//

import XCTest
import NovaBlendSalon

final class LoadAppointmentsFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrival() async throws {
        let (sut, store) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_twice_requestsCacheRetrivalTwice() async throws {
        let (sut, store) = makeSUT()
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .retrieve])
    }
    
    //MARK: Helpers
    private func makeSUT(with error: AppointmentStoreSpy.Error? = nil) -> (sut: LocalAppointmentLoader, store: AppointmentStoreSpy ) {
        let store = AppointmentStoreSpy(error: error)
        return (sut: LocalAppointmentLoader(store: store), store: store)
    }
}
