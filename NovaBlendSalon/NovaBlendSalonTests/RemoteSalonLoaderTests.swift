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
        let (_,client) = makeSUT()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let (sut,client) = makeSUT()
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

//MARK: Helper
private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClient) {
    let client = HTTPClient()
    let sut = RemoteSalonLoader(url: url, client: client)
    return(sut, client)
}
