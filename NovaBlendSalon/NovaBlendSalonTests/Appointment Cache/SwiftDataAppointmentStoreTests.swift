//
//  SwiftDataAppointmentStoreTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 13/11/24.
//

import XCTest
import NovaBlendSalon
import SwiftData

final class SwiftDataAppointmentStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieve()
            
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            var result = try await sut.retrieve()
            XCTAssertTrue(result.isEmpty)
            result = try await sut.retrieve()
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_retrive_deliversFoundValuesOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            let appointment = makeAppointmentItem()
            let localAppointment = getLocalAppointment(from: appointment)
            try await sut.insert(localAppointment)
            
            let result = try await sut.retrieve()
            
            XCTAssertEqual(result, [localAppointment])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieve()
            XCTAssertTrue(result.isEmpty)
            
            let localAppointment = getLocalAppointment(from: makeAppointmentItem())
            try await sut.insert(localAppointment)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            let localAppointment = getLocalAppointment(from: makeAppointmentItem())
            try await sut.insert(localAppointment)
            let result = try await sut.retrieve()
            XCTAssertEqual(result, [localAppointment])
            
            let anotherLocalAppointment = getLocalAppointment(from: makeAppointmentItem())
            try await sut.insert(anotherLocalAppointment)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) async -> AppointmentStore {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: ManagedAppointmentItem.self, configurations: config)
        let sut = SwiftDataSalonStore(modelContainer: container)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
