//
//  AppointmentStoreSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation
import NovaBlendSalon

class AppointmentStoreSpy: AppointmentStore {
    var receivedMessages = 0
    var error: AppointmentStoreSpy.Error?
    var appointments: [LocalAppointmentItem] = []
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    enum Error: Swift.Error {
        case insertionError
    }
    
    func insert(_ appointment: LocalAppointmentItem) throws {
        receivedMessages += 1
        appointments.append(appointment)
        if let error {
            throw error
        }
    }
}
