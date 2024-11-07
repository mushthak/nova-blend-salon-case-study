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
            try store.insert(appointment.toLocal())
        } catch {
            throw Error.insertion
        }
    }
}

private extension SalonAppointment {
    func toLocal() -> LocalAppointmentItem {
        return LocalAppointmentItem(id: id, time: time, phone: phone, email: email, notes: notes)
    }
}
