//
//  CacheSalonUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 16/02/24.
//

import XCTest
import NovaBlendSalon

final class CacheSalonUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() async {
        let deletionError = anyNSError()
        let (sut, store) = makeSUT(with: .failure(deletionError))
        
        do {
            try await sut.save(uniqueSalons().models)
            XCTFail("Expected to throw error but got success instead")
        } catch  {
            XCTAssertEqual(store.receivedMessages, [.deleteCachedSalons])
        }
        
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() async {
        let timestamp = Date()
        let feed = uniqueSalons()
        let (sut, store) = makeSUT(with: .success((feed.local, timestamp)),currentDate: { timestamp })
        
        do {
            try await sut.save(feed.models)
            XCTAssertEqual(store.receivedMessages, [.deleteCachedSalons, .insert(feed.local, timestamp)])
        } catch  {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(with result: SalonStoreSpy.Result = .success(([], Date())), currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStoreSpy) {
        let store = SalonStoreSpy(result: result)
        let sut = LocalSalonLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return(sut, store)
    }
    
}
