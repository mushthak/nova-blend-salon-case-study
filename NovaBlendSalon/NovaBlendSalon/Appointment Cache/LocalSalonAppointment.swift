//
//  LocalSalonAppointment.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation

public struct LocalAppointmentItem: Equatable {
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
