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
        case retrieval
    }
    
    public init(store: AppointmentStore) {
        self.store = store
    }
    
    public func save(_ appointment: SalonAppointment) async throws{
        do {
            try await store.insert(appointment.toLocal())
        } catch {
            throw Error.insertion
        }
    }
    
    public func load() async throws -> [SalonAppointment]{
        do {
            return try await store.retrieve().toModels()
        } catch  {
            throw Error.retrieval
        }
    }
}

private extension SalonAppointment {
    func toLocal() -> LocalAppointmentItem {
        return LocalAppointmentItem(id: id, time: time, phone: phone, email: email, notes: notes)
    }
}

private extension Array where Element == LocalAppointmentItem {
    func toModels() -> [SalonAppointment] {
        return map{SalonAppointment(id: $0.id, time: $0.time, phone: $0.phone, email: $0.email, notes: $0.notes)}
    }
}