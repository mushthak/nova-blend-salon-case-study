//
//  AppointmentStoreSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation
import NovaBlendSalon

class AppointmentStoreSpy: AppointmentStore {
    typealias Result = Swift.Result<[LocalAppointmentItem]?, AppointmentStoreSpy.Error>
    
    let result: Result
    var receivedMessages: [ReceivedMessage] = []
    
    init(result: Result) {
        self.result = result
    }
    
    enum Error: Swift.Error {
        case insertionError
        case retrievalError
        case deleteAllError
    }
    
    enum ReceivedMessage: Equatable {
        case retrieve
        case insert(LocalAppointmentItem)
        case insertAll([LocalAppointmentItem])
        case deleteAll
    }
    
    func insert(_ appointment: LocalAppointmentItem) throws {
        receivedMessages.append(.insert(appointment))
        switch result {
        case .failure(let error) where error == .insertionError:
            throw error
        case .success(_), .failure(_):
            break
        }
    }
    
    func insert(_ appointments: [LocalAppointmentItem]) async throws {
        receivedMessages.append(.insertAll(appointments))
        switch result {
        case .failure(let error) where error == .insertionError:
            throw error
        case .success(_), .failure(_):
            break
        }
    }
    
    func retrieve() throws -> [LocalAppointmentItem] {
        receivedMessages.append(.retrieve)
        return try result.get() ?? []
    }
    
    func deleteAll() async throws {
        receivedMessages.append(.deleteAll)
        switch result {
        case .failure(let error) where error == .deleteAllError:
            throw error
        case .success(_), .failure(_):
            break
        }
    }
}
