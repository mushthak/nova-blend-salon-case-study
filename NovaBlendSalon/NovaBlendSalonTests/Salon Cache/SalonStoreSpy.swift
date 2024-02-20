//
//  SalonStoreSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation
import NovaBlendSalon

class SalonStoreSpy: SalonStore {
    typealias Result = Swift.Result<CachedSalon, Error>
    
    enum ReceivedMessage: Equatable {
        case deleteCachedSalons
        case retrieve
        case insert([LocalSalonItem], Date)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    let result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func retrieve() async throws -> CachedSalon {
        receivedMessages.append(.retrieve)
        return try result.get()
    }
    
    func deleteCachedSalons() async throws{
        receivedMessages.append(.deleteCachedSalons)
        _ = try result.get()
    }
    
    func insert(_ feed: [LocalSalonItem], timestamp: Date) async throws {
        receivedMessages.append(.insert(feed, timestamp))
    }
}
