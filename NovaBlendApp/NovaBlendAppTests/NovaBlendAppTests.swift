//
//  NovaBlendAppTests.swift
//  NovaBlendAppTests
//
//  Created by Mushthak Ebrahim on 22/07/24.
//

import XCTest
import NovaBlendSalon

class SalonLoaderWithFallbackComposite: SalonLoader {
    
    private let primary: SalonLoader
    
    init(primary: SalonLoader, fallback: SalonLoader) {
        self.primary = primary
    }
    
    func load() async throws -> [NovaBlendSalon.Salon] {
        try await primary.load()
    }
}

final class SalonLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimarySalonsOnPrimaryLoaderSuccess() async {
        do {
            let primarySalon = [uniqueSalon()]
            let fallbackSalon = [uniqueSalon()]
            let sut = makeSUT(primaryResult: primarySalon, fallbackResult: fallbackSalon)
            
            let result = try await sut.load()
            XCTAssertEqual(result, primarySalon)
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
        
    }
    
    //MARK: Helpers
    
    private func makeSUT(primaryResult: [Salon], fallbackResult: [Salon], file: StaticString = #file, line: UInt = #line) -> SalonLoaderWithFallbackComposite {
        let primaryLoader = LoaderStub(result: primaryResult)
        let fallbackLoader = LoaderStub(result: fallbackResult)
        let sut = SalonLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func uniqueSalon() -> Salon {
        return Salon(id: UUID(), name: "any", location: "any", phone: "any", openTime: 0.0, closeTime: 0.0)
    }
    
    private class LoaderStub: SalonLoader {
        private let result: [Salon]
        
        init(result: [Salon]) {
            self.result = result
        }
        
        func load() async throws -> [Salon] {
            return result
        }
    }
}
