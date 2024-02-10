//
//  LoadSalonFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 10/02/24.
//

import XCTest

private class SalonStore {
    typealias Result = Error?
    
    var receivedMessages = 0
    let result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func retrieve() async throws {
        receivedMessages += 1
        if result != nil {
            throw result!
        }
    }
}

private class LocalSalonLoader {
    let store: SalonStore
    
    enum Error: Swift.Error {
        case retrival
    }
    
    init(store: SalonStore) {
        self.store = store
    }
    
    func load() async throws {
        do {
            try await store.retrieve()
        } catch  {
            throw Error.retrival
        }
    }
    
}

final class LoadSalonFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, 0)
    }
    
    func test_load_requestsCacheRetrival() async throws {
        let (sut, store) = makeSUT()
        
        try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, 1)
    }
    
    func test_load_twice_requestsCacheRetrivalTwice() async throws {
        let (sut, store) = makeSUT()
        
        try await sut.load()
        try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, 2)
    }
    
    func test_load_failsOnRetrivalError() async {
        let (sut, _) = makeSUT(with: anyNSError())
        
        do {
            _ = try await sut.load()
            XCTFail("Expected to throw error but got success intead")
        } catch {
            XCTAssertEqual(error as? LocalSalonLoader.Error, .retrival)
        }
        
    }
    
    //MARK: Helpers
    private func makeSUT(with result: SalonStore.Result = nil,file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStore) {
        let store = SalonStore(result: result)
        let sut = LocalSalonLoader(store: store)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return(sut, store)
    }
    
}
