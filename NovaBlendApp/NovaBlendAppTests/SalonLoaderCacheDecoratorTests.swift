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
    
    init(decoratee: SalonLoader) {
        self.decoratee = decoratee
    }
    
    func load() async throws -> [Salon] {
        return try await decoratee.load()
    }
}

final class SalonLoaderCacheDecoratorTests: XCTestCase {
    
    func test_load_deliversSalonsOnLoaderSuccess() async {
        let salon = uniqueSalon()
        let loader = SalonLoaderStub(result: .success([salon]))
        let sut = SalonLoaderCacheDecorator(decoratee: loader)
        
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, [salon])
        } catch  {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
    }
    
    func test_load_deliversErrorOnLoaderFailure() async {
        let loader = SalonLoaderStub(result: .failure(anyNSError()))
        let sut = SalonLoaderCacheDecorator(decoratee: loader)
        
        do {
            let result = try await sut.load()
            XCTFail("Expected to throw error items array but got \(result) instead")
        } catch  {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
}

//MARK: Helpers
private func uniqueSalon() -> Salon {
    return Salon(id: UUID(), name: "any", location: "any", phone: "any", openTime: 0.0, closeTime: 0.0)
}

private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
