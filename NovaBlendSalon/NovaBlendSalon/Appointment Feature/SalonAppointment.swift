//
//  SalonAppointment.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 28/08/24.
//

import Foundation

public struct SalonAppointment: Encodable {
    let id: UUID
    let time: Date
    let phone: String
    let email: String?
    let notes: String?
    
    public init(id: UUID, time: Date, phone: String, email: String?, notes: String?) {
        self.id = id
        self.time = time
        self.phone = phone
        self.email = email
        self.notes = notes
    }
}
