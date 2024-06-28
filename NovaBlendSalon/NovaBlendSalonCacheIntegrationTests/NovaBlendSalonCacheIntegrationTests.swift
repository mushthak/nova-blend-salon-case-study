//
//  NovaBlendSalonCacheIntegrationTests.swift
//  NovaBlendSalonCacheIntegrationTests
//
//  Created by Mushthak Ebrahim on 27/06/24.
//

import XCTest
import NovaBlendSalon
import SwiftData

final class NovaBlendSalonCacheIntegrationTests: XCTestCase {
    func test_load_deliversNoItemsOnEmptyCache() async{
        do {
            let sut = makeSUT()
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalSalonLoader {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: ManagedSalonItem.self, configurations: config)
        let store = SwiftDataSalonStore(modelContainer: container)
        let sut = LocalSalonLoader(store: store, currentDate: Date.init)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return sut
    }
}
