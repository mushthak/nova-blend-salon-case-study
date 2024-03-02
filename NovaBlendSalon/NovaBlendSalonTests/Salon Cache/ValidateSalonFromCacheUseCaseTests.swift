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
        
        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedSalons])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() async {
        let (sut, store) = makeSUT(with: emptyCacheResult())
        
        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteNonExpiredCache() async {
        let salons = uniqueSalons()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusSalonCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(with: .success((salons.local, expiredTimestamp)),currentDate: { fixedCurrentDate })
        
        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesCacheOnExpiration() async {
        let salons = uniqueSalons()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusSalonCacheMaxAge()
        let (sut, store) = makeSUT(with: .success((salons.local, expiredTimestamp)),currentDate: { fixedCurrentDate })
        
        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedSalons])
    }
    
    func test_validateCache_deletesExpiredCache() async {
        let salons = uniqueSalons()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusSalonCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(with: .success((salons.local, expiredTimestamp)),currentDate: { fixedCurrentDate })
        
        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedSalons])
    }
    
    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() async {
        let (sut, _) = makeSUT(with: retrivalError(), deletionError: anyNSError())
        
        do {
            try await sut.validateCache()
        } catch {
            XCTAssertEqual(error as? LocalSalonLoader.Error, .deletion)
        }
        
    }
    
    //MARK: Helpers
    private func makeSUT(with result: SalonStoreSpy.Result = .success(([], Date())), currentDate: @escaping () -> Date = Date.init, deletionError: Error? = nil, file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStoreSpy) {
        let store = SalonStoreSpy(result: result, deletionError: deletionError)
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
