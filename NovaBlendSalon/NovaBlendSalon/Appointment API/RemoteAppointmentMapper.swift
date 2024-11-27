//
//  RemoteAppointmentMapper.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 30/08/24.
//

import Foundation

internal enum RemoteAppointmentMapper {
    
    private struct RemoteAppointmentItem: Codable {
        let salonId: UUID
        let appointmentTime: Date
        let phone: String
        let email: String?
        let notes: String?
        
        private init(salonId: UUID, appointmentTime: Date, phone: String, email: String?, notes: String?) {
            self.salonId = salonId
            self.appointmentTime = appointmentTime
            self.phone = phone
            self.email = email
            self.notes = notes
        }
        
        init(appointment: Appointment) {
            self.init(salonId: appointment.id, appointmentTime: appointment.time, phone: appointment.phone, email: appointment.email, notes: appointment.notes)
        }
        
        var appointment: Appointment {
            return Appointment(id: salonId, time: appointmentTime, phone: phone, email: email, notes: notes)
        }
    }
    
    private struct Root: Decodable {
        let appointments: [RemoteAppointmentItem]
    }
    
    static func map(appointment: Appointment) throws -> Data {
        let remoteRequestItem = RemoteAppointmentItem.init(appointment: appointment)
        return try JSONEncoder.iso8601.encode(remoteRequestItem)
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> Appointment {
        guard response.isCreated else {
            throw RemoteAppointmentBooker.Error.AppointmentFailure
        }
        guard let root = try? JSONDecoder.iso8601.decode(RemoteAppointmentItem.self, from: data) else {
            throw RemoteAppointmentBooker.Error.invalidData
        }
        return root.appointment
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Appointment] {
        guard response.isOK, let root = try? JSONDecoder.iso8601.decode(Root.self, from: data) else {
            throw RemoteAppointmentLoader.Error.invalidData
        }
        return root.appointments.map { $0.appointment }
    }
    
}

//MARK: Helper Extensions
private extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    private static var OK_201: Int { return 201 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
    
    var isCreated: Bool {
        return statusCode == HTTPURLResponse.OK_201
    }
}

private extension JSONDecoder {
    static let iso8601: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

private extension JSONEncoder {
    static let iso8601: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}
