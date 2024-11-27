//
//  RemoteAppointmentLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 26/11/24.
//

import Foundation

public class RemoteAppointmentLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() async throws -> [Appointment] {
        guard let (data, response) = try? await client.getFrom(url: url) else {
            throw Error.connectivity
        }
        return try RemoteAppointmentMapper.map(data, from: response)
    }
    
}
