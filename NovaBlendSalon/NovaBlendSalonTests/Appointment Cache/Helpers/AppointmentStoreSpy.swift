//
//  AppointmentStoreSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation
import NovaBlendSalon

class AppointmentStoreSpy: AppointmentStore {
    var receivedMessages: [ReceivedMessage] = []
    var error: AppointmentStoreSpy.Error?
    
    init(error: Error? = nil) {
        self.error = error
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
        if let error {
            throw error
        }
    }
    
    func retrieve() throws {
        receivedMessages.append(.retrieve)
        if let error {
            throw error
        }
    }
}
