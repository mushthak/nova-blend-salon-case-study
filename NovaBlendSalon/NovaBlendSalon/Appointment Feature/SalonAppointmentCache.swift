//
//  SalonAppointmentCache.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation

public protocol SalonAppointmentCache {
    func save(_ appointment: SalonAppointment) async throws
    func load() async throws -> [SalonAppointment]
}
