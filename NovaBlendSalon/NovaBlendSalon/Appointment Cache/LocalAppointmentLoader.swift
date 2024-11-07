//
//  LocalAppointmentLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation

public class LocalAppointmentLoader: SalonAppointmentCache {
    let store: AppointmentStore
    
    public enum Error: Swift.Error {
        case insertion
    }
    
    public init(store: AppointmentStore) {
        self.store = store
    }
    
    public func save(_ appointment: SalonAppointment) throws{
        do {
            try store.insert(appointment)
        } catch {
            throw Error.insertion
        }
    }
}
