//
//  RemoteSalonLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 21/01/24.
//

import Foundation

public protocol HTTPClient {
    func getFrom(url: URL) async throws -> HTTPURLResponse
}

public final class RemoteSalonLoader {
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
    
    public func load() async throws {
        guard let result = try? await client.getFrom(url: url) else {
            throw Error.connectivity
        }
        
        if result.statusCode != 200 {
            throw Error.invalidData
        }
    }
}
