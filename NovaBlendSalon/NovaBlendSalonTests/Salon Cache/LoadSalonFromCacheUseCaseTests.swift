//
//  LoadSalonFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 10/02/24.
//

import XCTest

private class SalonStore {
    var receivedMessages = 0
}

private class LocalSalonLoader {
    let store: SalonStore
    
    init(store: SalonStore) {
        self.store = store
    }
    
}

final class LoadSalonFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let store = SalonStore()
        let _ = LocalSalonLoader(store: store)
        XCTAssertEqual(store.receivedMessages, 0)
    }
    
}
