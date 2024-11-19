//
//  ManagedAppointmentItem.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 13/11/24.
//

import Foundation
import SwiftData

@Model public class ManagedAppointmentItem {
     public let id: UUID
     let time: Date
     let phone: String
     let email: String?
     let notes: String?
    
     init(id: UUID, time: Date, phone: String, email: String?, notes: String?) {
        self.id = id
        self.time = time
        self.phone = phone
        self.email = email
        self.notes = notes
    }
    
    var local: LocalAppointmentItem {
        return LocalAppointmentItem(id: id, time: time, phone: phone, email: email, notes: notes)
    }
    
    static func appointment(from appointment: LocalAppointmentItem) -> ManagedAppointmentItem {
        return ManagedAppointmentItem(id: appointment.id, time: appointment.time, phone: appointment.phone, email: appointment.email, notes: appointment.notes)
    }
}
