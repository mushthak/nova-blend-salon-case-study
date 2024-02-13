//
//  LoadSalonFromCacheUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 10/02/24.
//

import XCTest
import NovaBlendSalon

private struct LocalSalonItem: Equatable {
    public let id: UUID
    public let name: String
    public let location: String?
    public let phone: String?
    public let openTime: Float
    public let closeTime: Float
    
    public init(id: UUID, name: String, location: String?, phone: String?, openTime: Float, closeTime: Float) {
        self.id = id
        self.name = name
        self.location = location
        self.phone = phone
        self.openTime = openTime
        self.closeTime = closeTime
    }
}

private class SalonStore {
    typealias CachedSalon = (salons: [Salon], timestamp: Date)
    typealias Result = Swift.Result<CachedSalon, Error>
    
    var receivedMessages = 0
    let result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func retrieve() async throws -> CachedSalon {
        receivedMessages += 1
        return try result.get()
    }
}

private class LocalSalonLoader {
    let store: SalonStore
    let currentDate: () -> Date
    
    enum Error: Swift.Error {
        case retrival
    }
    
    init(store: SalonStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func load() async throws -> [Salon] {
        do {
            let cache: SalonStore.CachedSalon = try await store.retrieve()
            if FeedCachePolicy.validate(cache.timestamp, against: currentDate()) {
                return cache.salons
            }
            return []
        } catch  {
            throw Error.retrival
        }
    }
    
}

private class FeedCachePolicy {
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
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
        let (sut, _) = makeSUT(with: .success(([], Date())))
        
        do {
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
        
    }
    
    func test_load_deliversNoSalonsOnCacheExpiration() async {
        let feed = uniqueSalons()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, _) = makeSUT(with: .success((feed.models, expiredTimestamp)),currentDate: { fixedCurrentDate })
        
        do {
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_load_deliversNoSalonsOnExpiredCache() async {
        let feed = uniqueSalons()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, _) = makeSUT(with: .success((feed.models, expiredTimestamp)),currentDate: { fixedCurrentDate })
        
        do {
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, [])
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    func test_load_deliversCachedSalonsOnNonExpiredCache() async {
        let feed = uniqueSalons()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, _) = makeSUT(with: .success((feed.models, nonExpiredTimestamp)),currentDate: { fixedCurrentDate })
        
        do {
            let result: [Salon] = try await sut.load()
            XCTAssertEqual(result, feed.models)
        } catch {
            XCTFail("Expected success but got \(error) intead")
        }
    }
    
    //MARK: Helpers
    private func makeSUT(with result: SalonStore.Result = .success(([], Date())), currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalSalonLoader, store: SalonStore) {
        let store = SalonStore(result: result)
        let sut = LocalSalonLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store)
        trackForMemoryLeak(sut)
        return(sut, store)
    }
    
    private func uniqueSalons() -> (models: [Salon], local: [LocalSalonItem]) {
        let models = [uniqueSalon(), uniqueSalon()]
        let local = models.map { LocalSalonItem(id: $0.id, name: $0.name, location: $0.location, phone: $0.phone, openTime: $0.openTime, closeTime: $0.closeTime) }
        return (models, local)
    }
    
    func uniqueSalon() -> Salon {
        return Salon(id: UUID(), name: "any", location: "any", phone: "any", openTime: 0.0, closeTime: 0.0)
    }
    
}

private extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -salonCacheMaxAgeInDays)
    }
    
    private var salonCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
