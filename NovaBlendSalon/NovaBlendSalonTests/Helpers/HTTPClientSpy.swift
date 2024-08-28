//
//  HTTPClientSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 28/08/24.
//

import Foundation
import NovaBlendSalon

class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func getFrom(url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try result.get()
    }
    
    func postTo(url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try result.get()
    }
}
