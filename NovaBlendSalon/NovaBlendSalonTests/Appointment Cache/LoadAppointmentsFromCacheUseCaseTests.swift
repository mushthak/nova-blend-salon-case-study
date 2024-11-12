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
        
        _ = try sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_twice_requestsCacheRetrivalTwice() async throws {
        let (sut, store) = makeSUT()
        
        _ = try sut.load()
        _ = try sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .retrieve])
    }
    
    func test_load_failsOnRetrivalError() async {
        let (sut, _) = makeSUT(with: retrievalError())
        
        do {
            _ = try sut.load()
            XCTFail("Expected to throw error but got success intead")
        } catch {
            XCTAssertEqual(error as? LocalAppointmentLoader.Error, .retrieval)
        }
        
    }
    
    func test_load_deliversEmptyAppointmentsOnEmptyCache() async {
        let (sut, _) = makeSUT(with: .success(.none))
        
        do {
            let result: [SalonAppointment] = try sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
        
    }
    
    func test_load_deliversCachedAppointmentsOnNonEmptyCache() async {
        let appointment = makeAppointmentItem()
        let (sut, _) = makeSUT(with: .success([getLocalAppointment(from: appointment)]))
        
        do {
            let result: [SalonAppointment] = try sut.load()
            XCTAssertEqual(result, [appointment])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
        
    }
    
    //MARK: Helpers
    private func makeSUT(with result: AppointmentStoreSpy.Result = .success(.none)) -> (sut: LocalAppointmentLoader, store: AppointmentStoreSpy ) {
        let store = AppointmentStoreSpy(result: result)
        return (sut: LocalAppointmentLoader(store: store), store: store)
    }
    
    private func retrievalError() -> AppointmentStoreSpy.Result {
        return .failure(.retrievalError)
    }
    
    private func makeAppointmentItem() -> SalonAppointment {
        return SalonAppointment(id: UUID(),
                                time: Date.init().roundedToSeconds(),
                                phone: "a phone number",
                                email: nil,
                                notes: nil)
    }
    
    private func getLocalAppointment(from model: SalonAppointment) -> LocalAppointmentItem {
        return LocalAppointmentItem(id: model.id,
                                    time: model.time,
                                    phone: model.phone,
                                    email: model.email,
                                    notes: model.notes)
    }
}


private extension Date {
    func roundedToSeconds() -> Date {
        let timeInterval = TimeInterval(Int(self.timeIntervalSince1970))
        return Date(timeIntervalSince1970: timeInterval)
    }
}
