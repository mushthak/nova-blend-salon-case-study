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
        let error = NSError(domain: "Test", code: 0)
        let (sut,_) = makeSUT(with: .failure(error))
        
        do {
            try await sut.load()
        } catch {
            XCTAssertEqual(error as? RemoteSalonLoader.Error, .connectivity)
        }
    }
}

//MARK: Helper
private func makeSUT(url: URL = URL(string: "http://a-url.com")!,with result: Result<Void, Error> = anyValidResponse(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy(result: result)
    let sut = RemoteSalonLoader(url: url, client: client)
    return(sut, client)
}

private  func anyValidResponse() -> Result<Void, Error> {
    return .success(())
}

private class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    let result: Result<Void, Error>
    
    init(requestedURLs: [URL] = [URL](), result: Result<Void, Error>) {
        self.requestedURLs = requestedURLs
        self.result = result
    }
    
    func getFrom(url: URL) async throws {
        requestedURLs.append(url)
        return try result.get()
    }
}
