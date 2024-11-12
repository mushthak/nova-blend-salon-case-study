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
    }
    
    enum ReceivedMessage: Equatable {
        case retrieve
        case insert(LocalAppointmentItem)
    }
    
    func insert(_ appointment: LocalAppointmentItem) throws {
        receivedMessages.append(.insert(appointment))
        _ = try result.get()
    }
    
    func retrieve() throws -> [LocalAppointmentItem] {
        receivedMessages.append(.retrieve)
        return try result.get() ?? []
    }
}
