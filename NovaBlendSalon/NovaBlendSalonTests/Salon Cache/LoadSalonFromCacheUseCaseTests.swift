//
//  LoadSalonFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 10/02/24.
//

import XCTest
import NovaBlendSalon

private class SalonStore {
    typealias Result = Swift.Result<[Salon], Error>
    
    var receivedMessages = 0
    let result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func retrieve() async throws -> [Salon] {
        receivedMessages += 1
        return try result.get()
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
    
    func load() async throws -> [Salon] {
        do {
            return try await store.retrieve()
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
        
        _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, 1)
    }
    
    func test_load_twice_requestsCacheRetrivalTwice() async throws {
        let (sut, store) = makeSUT()
        
        _ = try await sut.load()
        _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, 2)
    }
    
    func test_load_failsOnRetrivalError() async {
        let (sut, _) = makeSUT(with: .failure(anyNSError()))
        
        do {
            _ = try await sut.load()
            XCTFail("Expected to throw error but got success intead")
        } catch {
            XCTAssertEqual(error as? LocalSalonLoader.Error, .retrival)
        }
        
    }
    
    func test_load_deliversEmptySalonsOnEmptyCache() async {
        let (sut, _) = makeSUT(with: .success([]))
        
        do {
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
        
    }
    
    //MARK: Helpers
    private func makeSUT(with result: SalonStore.Result = .success([]),file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStore) {
        let store = SalonStore(result: result)
        let sut = LocalSalonLoader(store: store)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return(sut, store)
    }
    
}
