//
//  SwiftDataSalonStoreTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/06/24.
//

import Foundation
import NovaBlendSalon
import XCTest
import SwiftData

class SwiftDataSalonStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieve()
            XCTAssertEqual(result.salons, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            var result = try await sut.retrieve()
            XCTAssertEqual(result.salons, [])
            result = try await sut.retrieve()
            XCTAssertEqual(result.salons, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }

    //MARK: Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) async -> SalonStore {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: ManagedSalonItem.self, configurations: config)
        let mainContext = await container.mainContext
        let sut = SwiftDataSalonStore(modelContext: mainContext)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}


