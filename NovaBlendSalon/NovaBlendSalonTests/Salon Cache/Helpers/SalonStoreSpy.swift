//
//  SalonStoreSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation
import NovaBlendSalon

class SalonStoreSpy: SalonStore {
    typealias Result = Swift.Result<CachedSalon?, SalonStoreSpy.Error>
    
    enum ReceivedMessage: Equatable {
        case deleteCachedSalons
        case retrieve
        case insert([LocalSalonItem], Date)
    }
    
    enum Error: Swift.Error {
        case retrivalError
        case deletionError
        case insertionError
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    let result: Result
    let deletionError : Swift.Error?
    
    init(result: Result, deletionError: Swift.Error? = nil) {
        self.result = result
        self.deletionError = deletionError
    }
    
    func retrieve() async throws -> CachedSalon? {
        receivedMessages.append(.retrieve)
        return try result.get()
    }
    
    func deleteCachedSalons() async throws{
        receivedMessages.append(.deleteCachedSalons)
        
        if deletionError != nil {
            throw deletionError!
        }

        switch result {
        case .failure(let error) where error == .deletionError:
            throw error
        case .success(_), .failure(_):
            break
        }
    }
    
    func insert(_ salons: [LocalSalonItem], timestamp: Date) async throws {
        receivedMessages.append(.insert(salons, timestamp))
        
        switch result {
        case .failure(let error) where error == .insertionError:
            throw error
        case .success(_), .failure(_):
            break
        }
    }
}
