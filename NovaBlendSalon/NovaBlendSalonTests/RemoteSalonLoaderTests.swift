//
//  NovaBlendSalonTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 20/01/24.
//

import XCTest

private final class RemoteSalonLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.requestedURL = url
    }
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteSalonLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL() {
        let client = HTTPClient()
        let _ = RemoteSalonLoader(url: URL(string: "http://a-url.com")!, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient()
        let sut = RemoteSalonLoader(url: URL(string: "http://a-url.com")!, client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
