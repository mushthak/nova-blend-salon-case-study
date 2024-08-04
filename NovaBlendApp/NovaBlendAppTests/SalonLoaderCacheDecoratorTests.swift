//
//  FeedLoaderCacheDecoratorTests.swift
//  NovaBlendAppTests
//
//  Created by Mushthak Ebrahim on 03/08/24.
//

import XCTest
import NovaBlendSalon

class SalonLoaderCacheDecorator {
    private let decoratee: SalonLoader
    private let cache: SalonCache
    
    init(decoratee: SalonLoader, cache: SalonCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load() async throws -> [Salon] {
        let result = try await decoratee.load()
        try await cache.save(result)
        return result
    }
}

final class SalonLoaderCacheDecoratorTests: XCTestCase {
    
    func test_load_deliversSalonsOnLoaderSuccess() async {
        let salon = uniqueSalon()
        let sut = makeSUT(result: .success([salon]))
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [salon])
        } catch  {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
    }
    
    func test_load_deliversErrorOnLoaderFailure() async {
        let sut = makeSUT(result: .failure(anyNSError()))
        
        do {
            let result = try await sut.load()
            XCTFail("Expected to throw error items array but got \(result) instead")
        } catch  {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_load_cachesLoadedSalonsOnLoaderSuccess() async {
        let salons = [uniqueSalon()]
        let cache = CacheSpy()
        let sut = makeSUT(result: .success(salons),cache: cache)
        
        do {
            _ = try await sut.load()
            XCTAssertEqual(cache.messages , [.save(salons)])
        } catch  {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
    }
    
    func test_load_doesNotCacheOnLoaderFailure() async {
        let cache = CacheSpy()
        let sut = makeSUT(result: .failure(anyNSError()),cache: cache)
        
        do {
            let result = try await sut.load()
            XCTFail("Expected to throw error items array but got \(result) instead")
        } catch  {
            XCTAssertEqual(cache.messages , [])
        }
    }
    
    //MARK: Helpers
    private func makeSUT(result: Result<[Salon], Error>, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> SalonLoaderCacheDecorator {
        let loader = SalonLoaderStub(result: result)
        let sut = SalonLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private class CacheSpy: SalonCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save([Salon])
        }
        
        func save(_ salons: [Salon]) async throws {
            messages.append(.save(salons))
        }}
}
