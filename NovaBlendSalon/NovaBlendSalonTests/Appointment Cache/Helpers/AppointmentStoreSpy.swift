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
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    enum Error: Swift.Error {
        case insertionError
    }
    
    func insert(_ appointment: SalonAppointment) throws {
        receivedMessages += 1
        if let error {
            throw error
        }
    }
}
