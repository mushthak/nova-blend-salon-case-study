//
//  SalonAppointmentCache.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation

public protocol AppointmentCache {
    func save(_ appointment: Appointment) async throws
    func load() async throws -> [Appointment]
}
