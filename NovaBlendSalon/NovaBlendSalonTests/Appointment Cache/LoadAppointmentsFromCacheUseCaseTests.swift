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
        XCTAssertEqual(store.receivedMessages, 0)
    }
    
    //MARK: Helpers
    private func makeSUT(with error: AppointmentStoreSpy.Error? = nil) -> (sut: LocalAppointmentLoader, store: AppointmentStoreSpy ) {
        let store = AppointmentStoreSpy(error: error)
        return (sut: LocalAppointmentLoader(store: store), store: store)
    }
}
