//
//  RemoteSalonLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 21/01/24.
//

import Foundation

public final class RemoteSalonLoader: SalonLoader {
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
    
    public func load() async throws -> [Salon] {
        guard let (data, response) = try? await client.getFrom(url: url) else {
            throw Error.connectivity
        }
        return try SalonMapper.map(data, from: response)
    }
}
