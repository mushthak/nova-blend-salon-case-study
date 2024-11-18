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
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) async -> AppointmentStore {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: ManagedCache.self, configurations: config)
        let sut = SwiftDataSalonStore(modelContainer: container)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
