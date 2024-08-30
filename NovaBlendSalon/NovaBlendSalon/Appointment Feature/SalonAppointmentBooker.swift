//
//  SalonAppointmentBooker.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 30/08/24.
//

import Foundation

public protocol SalonAppointmentBooker {
    func bookAppointment(appointment: SalonAppointment) async throws
}
