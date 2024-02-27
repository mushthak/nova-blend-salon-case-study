//
//  ValidateSalonFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/02/24.
//

import XCTest
import NovaBlendSalon

final class ValidateSalonFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() async {
        let (sut, store) = makeSUT(with: retrivalError())
        
        await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedSalons])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() async {
        let (sut, store) = makeSUT(with: emptyCacheResult())
        
        await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    //MARK: Helpers
    private func makeSUT(with result: SalonStoreSpy.Result = .success(([], Date())), currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStoreSpy) {
        let store = SalonStoreSpy(result: result)
        let sut = LocalSalonLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return(sut, store)
    }
    
    private func retrivalError() -> SalonStoreSpy.Result {
        return .failure(.retrivalError)
    }
    
    private func emptyCacheResult() ->  SalonStoreSpy.Result {
        return .success(([], Date()))
    }
}
