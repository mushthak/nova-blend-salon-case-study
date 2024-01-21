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
    
    enum Error {
        case connectivity
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Error) -> Void) {
        client.getFrom(url: url) { error in
            completion(.connectivity)
        }
    }
}

protocol HTTPClient {
    func getFrom(url: URL, completion: @escaping (Error) -> Void)
}

final class RemoteSalonLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL() {
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let (sut,client) = makeSUT()
        sut.load { _ in }
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "http://a-url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut,client) = makeSUT()
        
        client.error = NSError(domain: "Test", code: 0)
        var capturedError: RemoteSalonLoader.Error?
        sut.load { error in
            capturedError = error
        }
        
        XCTAssertEqual(capturedError, .connectivity)
    }
}

//MARK: Helper
private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteSalonLoader(url: url, client: client)
    return(sut, client)
}

private class HTTPClientSpy: HTTPClient {
    var requestedURLs = [URL]()
    var error: Error?
    
    func getFrom(url: URL, completion: @escaping (Error) -> Void) {
        if let error = error {
            completion(error)
        }
        requestedURLs.append(url)
    }
}
