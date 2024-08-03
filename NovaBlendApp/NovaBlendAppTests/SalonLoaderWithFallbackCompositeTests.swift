//
//  NovaBlendAppTests.swift
//  NovaBlendAppTests
//
//  Created by Mushthak Ebrahim on 22/07/24.
//

import XCTest
import NovaBlendSalon
@testable import NovaBlendApp

final class SalonLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimarySalonsOnPrimaryLoaderSuccess() async {
        do {
            let primarySalon = [uniqueSalon()]
            let fallbackSalon = [uniqueSalon()]
            let sut = makeSUT(primaryResult: .success(primarySalon), fallbackResult: .success(fallbackSalon))
            
            let result = try await sut.load()
            XCTAssertEqual(result, primarySalon)
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
        
    }
    
    func test_load_deliversFallbackFeedOnPrimaryLoaderFailure() async {
        do {
            let fallbackSalon = [uniqueSalon()]
            let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackSalon))
            
            let result = try await sut.load()
            XCTAssertEqual(result, fallbackSalon)
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
    }
    
    func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() async {
        do {
            let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
            
            let result = try await sut.load()
            XCTFail("Expected to throw error items array but got \(result) instead")
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    //MARK: Helpers
    
    private func makeSUT(primaryResult: Result<[Salon], Error>, fallbackResult: Result<[Salon], Error>, file: StaticString = #file, line: UInt = #line) -> SalonLoaderWithFallbackComposite {
        let primaryLoader = SalonLoaderStub(result: primaryResult)
        let fallbackLoader = SalonLoaderStub(result: fallbackResult)
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
}
