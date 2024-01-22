//
//  RemoteSalonLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 21/01/24.
//

import Foundation

public protocol HTTPClient {
    func getFrom(url: URL) async throws
}

public final class RemoteSalonLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() async throws {
        do {
            try await client.getFrom(url: url)
        } catch {
            throw Error.connectivity
        }
    }
}
