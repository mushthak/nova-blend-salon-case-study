//
//  SwiftDataSalonStoreTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/06/24.
//

import Foundation
import NovaBlendSalon
import XCTest
import SwiftData

class SwiftDataSalonStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieve()
            
            XCTAssertNil(result?.salons)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            var result = try await sut.retrieve()
            XCTAssertNil(result?.salons)
            result = try await sut.retrieve()
            XCTAssertNil(result?.salons)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_retrive_deliversFoundValuesOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            let uniqueTimeStamp = Date.init()
            let uniqueLocalSalons = uniqueSalons().local
            try await sut.insert(uniqueLocalSalons, timestamp: uniqueTimeStamp)
            
            let result = try await sut.retrieve()
            
            XCTAssertEqual(result?.timestamp, uniqueTimeStamp)
            XCTAssertEqual(result?.salons.count, uniqueLocalSalons.count)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            let result = try await sut.retrieve()
            XCTAssertNil(result)
            
            try await sut.insert(uniqueSalons().local, timestamp: Date.init())
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_insert_deliversNoErrorNonOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            try await sut.insert(uniqueSalons().local, timestamp: Date.init())
            let result = try await sut.retrieve()
            XCTAssertNotNil(result)
            
            try await sut.insert(uniqueSalons().local, timestamp: Date.init())
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() async{
        let sut = await makeSUT()
        do {
            try await sut.insert(uniqueSalons().local, timestamp: Date.init())
            
            let uniqueTimeStamp = Date.init()
            let uniqueSalons = uniqueSalons().local
            try await sut.insert(uniqueSalons, timestamp: uniqueTimeStamp)
            
            let result = try await sut.retrieve()
            XCTAssertEqual(result?.timestamp, uniqueTimeStamp)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            try await sut.deleteCachedSalons()
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async {
        let sut = await makeSUT()
        do {
            var result = try await sut.retrieve()
            XCTAssertNil(result?.salons)
            
            try await sut.deleteCachedSalons()
            
            result = try await sut.retrieve()
            XCTAssertNil(result?.salons)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() async {
        let sut = await makeSUT()
        do {
            try await sut.insert(uniqueSalons().local, timestamp: Date.init())
            try await sut.deleteCachedSalons()
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_insert_emptiesPreviouslyInsertedCache() async {
        let sut = await makeSUT()
        do {
            try await sut.insert(uniqueSalons().local, timestamp: Date.init())
            try await sut.deleteCachedSalons()
            let result = try await sut.retrieve()
            XCTAssertNil(result)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }

    //MARK: Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) async -> SalonStore {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: ManagedSalonItem.self, configurations: config)
        let sut = SwiftDataSalonStore(modelContainer: container)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}


