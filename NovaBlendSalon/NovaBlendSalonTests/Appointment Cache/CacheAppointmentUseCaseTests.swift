//
//  CacheAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/09/24.
//

import Foundation
import XCTest
import NovaBlendSalon

final class CacheAppointmentUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_failsOnInsertionError() async {
        let (sut, _) = makeSUT(with: insetionError())
        let appointment = makeAppointmentItem()
        
        do {
            try await sut.save(appointment)
            XCTFail("Expect to throw \(LocalAppointmentLoader.Error.insertion) but got success instead")
        } catch  {
            XCTAssertEqual(error as? LocalAppointmentLoader.Error, .insertion)
        }
    }
    
    func test_save_succeedsOnSuccessfullCacheInsertion() async {
        let (sut, _) = makeSUT()
        let appointment = makeAppointmentItem()
        
        do {
            try await sut.save(appointment)
        } catch  {
            XCTFail("Expect to succeed but got \(error) instead")
        }
    }
    
    func test_save_succeedsOnSuccessfullCacheInsertionWithLocalAppointmentItem() async {
        let (sut, store) = makeSUT()
        let appointment = makeAppointmentItem()
        let localAppointment = getLocalAppointment(from: appointment)
        
        do {
            try await sut.save(appointment)
            XCTAssertEqual(store.receivedMessages, [.insert(localAppointment)])
        } catch  {
            XCTFail("Expect to succeed but got \(error) instead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(with result: AppointmentStoreSpy.Result = .success(.none)) -> (sut: LocalAppointmentLoader, store: AppointmentStoreSpy ) {
        let store = AppointmentStoreSpy(result: result)
        return (sut: LocalAppointmentLoader(store: store), store: store)
    }
}
