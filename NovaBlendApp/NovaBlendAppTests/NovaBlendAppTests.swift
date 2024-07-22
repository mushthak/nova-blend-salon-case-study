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
            let secondarySalon = [uniqueSalon()]
            let primaryLoader = LoaderStub(result: primarySalon)
            let secondaryLoader = LoaderStub(result: secondarySalon)
            let sut = SalonLoaderWithFallbackComposite(primary: primaryLoader, fallback: secondaryLoader)
            
            let result = try await sut.load()
            XCTAssertEqual(result, primarySalon)
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
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
