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
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() async {
        let (sut, store) = makeSUT(with: deletionError())
        let appointment = makeAppointmentItem()
        
        do {
            try await sut.save([appointment])
            XCTFail("Expect to throw error but got success instead")
        } catch  {
            XCTAssertEqual(store.receivedMessages, [AppointmentStoreSpy.ReceivedMessage.deleteAll])
        }
    }
    
    func test_save_remoteAppointments_failsOnCacheDeletionError() async {
        let (sut, _) = makeSUT(with: deletionError())
        let appointment = makeAppointmentItem()
        
        do {
            try await sut.save([appointment])
            XCTFail("Expect to throw \(LocalAppointmentLoader.Error.deletion) but got success instead")
        } catch  {
            XCTAssertEqual(error as? LocalAppointmentLoader.Error, .deletion)
        }
    }
    
    func test_save_remoteAppointments_failsOnCacheInsertionError() async {
        let (sut, _) = makeSUT(with: insetionError())
        let appointment = makeAppointmentItem()
        
        do {
            try await sut.save([appointment])
            XCTFail("Expect to throw \(LocalAppointmentLoader.Error.insertion) but got success instead")
        } catch  {
            XCTAssertEqual(error as? LocalAppointmentLoader.Error, .insertion)
        }
    }
    
    func test_save_remoteAppointments_succeedsOnSuccessfullCacheInsertion() async {
        let (sut, _) = makeSUT()
        let appointment = makeAppointmentItem()
        
        do {
            try await sut.save([appointment])
        } catch  {
            XCTFail("Expected successfull cache insertion but got \(error) intead")

        }
    }
    
    //MARK: Helpers
    private func makeSUT(with result: AppointmentStoreSpy.Result = .success(.none)) -> (sut: LocalAppointmentLoader, store: AppointmentStoreSpy ) {
        let store = AppointmentStoreSpy(result: result)
        return (sut: LocalAppointmentLoader(store: store), store: store)
    }
}
