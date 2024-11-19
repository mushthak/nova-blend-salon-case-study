//
//  SalonAppointment.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 28/08/24.
//

import Foundation

public struct Appointment: Equatable, Encodable {
    public let id: UUID
    public let time: Date
    public let phone: String
    public let email: String?
    public let notes: String?
    
    public init(id: UUID, time: Date, phone: String, email: String?, notes: String?) {
        self.id = id
        self.time = time
        self.phone = phone
        self.email = email
        self.notes = notes
    }
}
