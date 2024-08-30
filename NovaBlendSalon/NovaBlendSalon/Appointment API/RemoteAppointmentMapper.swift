//
//  RemoteAppointmentMapper.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 30/08/24.
//

import Foundation

internal enum RemoteAppointmentMapper {
    
    private struct RemoteAppointmentRequestItem: Encodable {
        let id: UUID
        let appointmentTime: Date
        let phone: String
        let email: String?
        let notes: String?
        
        private init(id: UUID, appointmentTime: Date, phone: String, email: String?, notes: String?) {
            self.id = id
            self.appointmentTime = appointmentTime
            self.phone = phone
            self.email = email
            self.notes = notes
        }
        
        init(appointment: SalonAppointment) {
            self.init(id: appointment.id, appointmentTime: appointment.time, phone: appointment.phone, email: appointment.email, notes: appointment.notes)
        }
        
    }
    
    static func map(appointment: SalonAppointment) throws -> Data {
        let remoteRequestItem = RemoteAppointmentRequestItem.init(appointment: appointment)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(remoteRequestItem)
    }
    
}
