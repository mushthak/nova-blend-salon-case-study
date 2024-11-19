//
//  SwiftDataSalonStore+AppointmentStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 13/11/24.
//

import Foundation
import SwiftData

extension SwiftDataSalonStore: AppointmentStore {
    public func insert(_ appointment: LocalAppointmentItem) async throws {
        let appointment = ManagedAppointmentItem.appointment(from: appointment)
        try await insertUniqueInstance(of: appointment)
    }
    
    public func retrieve() throws -> [LocalAppointmentItem] {
        let cache = try findAppointmentCache()
        return cache.compactMap{ $0.local }
    }
    
    //MARK: Helpers
    private func findAppointmentCache() throws -> [ManagedAppointmentItem] {
        let descriptor = FetchDescriptor<ManagedAppointmentItem>()
        return try modelContext.fetch(descriptor)
    }
    
    private func insertUniqueInstance(of managedAppointment: ManagedAppointmentItem) async throws {
        modelContext.insert(managedAppointment)
        try modelContext.save()
    }
}
