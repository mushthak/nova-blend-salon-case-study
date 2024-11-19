//
//  RemoteAppointmentBooker.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 28/08/24.
//

import Foundation

public class RemoteAppointmentBooker: AppointmentBooker {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case AppointmentFailure
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func bookAppointment(appointment: Appointment) async throws -> Appointment {
        let remoteAppointmentData = try RemoteAppointmentMapper.map(appointment: appointment)
        guard let (data, response) = try? await client.postTo(url: url, data: remoteAppointmentData) else {
            throw Error.connectivity
        }
        return try RemoteAppointmentMapper.map(data, from: response)
    }
}
