//
//  RemoteAppointmentBooker.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 28/08/24.
//

import Foundation

public class RemoteAppointmentBooker {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case AppointmentFailure
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func bookAppointment(appointment: SalonAppointment) async throws {
        let remoteAppointmentData = try RemoteAppointmentMapper.map(appointment: appointment)
        guard let (_, response) = try? await client.postTo(url: url, data: remoteAppointmentData) else {
            throw Error.connectivity
        }
        if response.statusCode != 201 {
            throw Error.AppointmentFailure
        }
    }
}

enum RemoteAppointmentMapper {
    
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
