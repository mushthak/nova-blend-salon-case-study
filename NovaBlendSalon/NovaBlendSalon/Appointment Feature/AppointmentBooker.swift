//
//  SalonAppointmentBooker.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 30/08/24.
//

import Foundation

public protocol AppointmentBooker {
    func bookAppointment(appointment: Appointment) async throws -> Appointment
}
