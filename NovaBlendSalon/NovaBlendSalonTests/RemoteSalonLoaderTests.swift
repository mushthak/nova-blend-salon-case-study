//
//  NovaBlendSalonTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 20/01/24.
//

import XCTest
import NovaBlendSalon

final class RemoteSalonLoaderTests: XCTestCase {
    
    func test_init_doesnotRequestDataFromURL() {
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() async throws{
        let (sut,client) = makeSUT()
        try await sut.load()
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() async throws{
        let url = URL(string: "http://a-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        try await sut.load()
        try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() async throws {
        let (sut,client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        
        do {
            try await sut.load()
        } catch {
            XCTAssertEqual(error as? RemoteSalonLoader.Error, .connectivity)
        }
    }
}

//MARK: Helper
private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteSalonLoader(url: url, client: client)
    return(sut, client)
}

private class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    var error: Error?
    
    func getFrom(url: URL) async throws {
        if let error = error {
            throw error
        }
        requestedURLs.append(url)
    }
}
