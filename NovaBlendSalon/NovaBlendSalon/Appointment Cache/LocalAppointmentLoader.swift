//
//  LocalAppointmentLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation

public class LocalAppointmentLoader: AppointmentCache {
    let store: AppointmentStore
    
    public enum Error: Swift.Error {
        case insertion
        case retrieval
    }
    
    public init(store: AppointmentStore) {
        self.store = store
    }
    
    public func save(_ appointment: Appointment) async throws{
        do {
            try await store.insert(appointment.toLocal())
        } catch {
            throw Error.insertion
        }
    }
    
    public func load() async throws -> [Appointment]{
        do {
            return try await store.retrieve().toModels()
        } catch  {
            throw Error.retrieval
        }
    }
}

private extension Appointment {
    func toLocal() -> LocalAppointmentItem {
        return LocalAppointmentItem(id: id, time: time, phone: phone, email: email, notes: notes)
    }
}

private extension Array where Element == LocalAppointmentItem {
    func toModels() -> [Appointment] {
        return map{Appointment(id: $0.id, time: $0.time, phone: $0.phone, email: $0.email, notes: $0.notes)}
    }
}
