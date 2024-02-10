//
//  LoadSalonFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 10/02/24.
//

import XCTest

private class SalonStore {
    var receivedMessages = 0
    
    func retrieve() {
        receivedMessages += 1
    }
}

private class LocalSalonLoader {
    let store: SalonStore
    
    init(store: SalonStore) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
    }
    
}

final class LoadSalonFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, 0)
    }
    
    func test_load_requestsCacheRetrival() {
        let (sut, store) = makeSUT()
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessages, 1)
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStore) {
        let store = SalonStore()
        let sut = LocalSalonLoader(store: store)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return(sut, store)
    }
    
}
