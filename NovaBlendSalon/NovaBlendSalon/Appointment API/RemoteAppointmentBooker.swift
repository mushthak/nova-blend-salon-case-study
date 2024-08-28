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
        
        let appointmentData = try! JSONEncoder().encode(appointment)
        
        guard let (_, response) = try? await client.postTo(url: url, data: appointmentData) else {
            throw Error.connectivity
        }
        if response.statusCode != 201 {
            throw Error.AppointmentFailure
        }
    }
}
