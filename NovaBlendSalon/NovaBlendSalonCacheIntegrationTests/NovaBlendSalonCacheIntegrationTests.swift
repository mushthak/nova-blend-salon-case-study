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
            let sut = makeSUT(container: getContainer())
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_load_deliversItemsSavedOnASeperateInstance() async{
        do {
            let container = getContainer()
            let sutToPerformSave = makeSUT(container: container)
            let sutToPerformLoad = makeSUT(container: container)
            let salons = uniqueSalons().models
            
            try await sutToPerformSave.save(salons)
            
            let result: [Salon] = try await sutToPerformLoad.load()
            XCTAssertEqual(result.count, salons.count)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_save_overridesItemsSavedOnASeparateInstance() async {
        do {
            let container = getContainer()
            let sutToPerformFirstSave = makeSUT(container: container)
            let sutToPerformSecondSave = makeSUT(container: container)
            let sutToPerformLoad = makeSUT(container: container)
            let firstSalon = uniqueSalon()
            let secondSalon = uniqueSalon()
            
            try await sutToPerformFirstSave.save([firstSalon])
            try await sutToPerformSecondSave.save([secondSalon])
            
            let result: [Salon] = try await sutToPerformLoad.load()
            XCTAssertEqual(result, [secondSalon])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(container: ModelContainer, file: StaticString = #file, line: UInt = #line) -> LocalSalonLoader {
        let store = SwiftDataStore(modelContainer: container)
        let sut = LocalSalonLoader(store: store, currentDate: Date.init)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return sut
    }
    
    private func getContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: ManagedSalonItem.self, configurations: config)
    }
}
