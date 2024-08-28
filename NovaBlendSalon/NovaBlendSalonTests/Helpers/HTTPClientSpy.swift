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
    private(set) var postDataObjects = [Data]()
    
    let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func getFrom(url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try result.get()
    }
    
    func postTo(url: URL, data: Data) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        postDataObjects.append(data)
        return try result.get()
    }
}
