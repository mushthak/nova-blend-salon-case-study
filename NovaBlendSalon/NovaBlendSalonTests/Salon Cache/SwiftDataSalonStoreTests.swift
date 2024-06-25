//
//  SwiftDataSalonStoreTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/06/24.
//

import Foundation
import NovaBlendSalon
import XCTest

class SwiftDataSalonStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() async {
        let sut = makeSUT()
        do {
            let result = try await sut.retrieve()
            XCTAssertEqual(result.salons, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        let sut = makeSUT()
        do {
            var result = try await sut.retrieve()
            XCTAssertEqual(result.salons, [])
            result = try await sut.retrieve()
            XCTAssertEqual(result.salons, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }

    //MARK: Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> SalonStore {
        let sut = SwiftDataSalonStore()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}


