//
//  RemoteSalonLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 21/01/24.
//

import Foundation

public protocol HTTPClient {
    func getFrom(url: URL) async throws -> (Data, HTTPURLResponse)
}

public final class RemoteSalonLoader {
    private let url: URL
    private let client: HTTPClient
    
    private let OK_200 = 200
    
    private struct Root: Decodable {
        let salons: [Salon]
    }
    
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
        
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.salons
    }
}


