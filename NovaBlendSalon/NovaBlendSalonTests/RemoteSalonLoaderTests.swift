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
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async throws {
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            
            Task {
                let response = HTTPURLResponse(url: URL(string: "http://a-url.com")!, statusCode: code, httpVersion: nil, headerFields: nil)!
                let (sut,_) = makeSUT(with: .success((Data(), response)))
                
                do {
                    try await sut.load()
                    XCTFail("Expected to throw \(RemoteSalonLoader.Error.invalidData) but got success instead")
                } catch {
                    XCTAssertEqual(error as? RemoteSalonLoader.Error, .invalidData)
                }
            }
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() async throws {
        let response = anyValidHTTPResponse()
        let invalidJSON = Data.init(_: "invalid json".utf8)
        let (sut,_) = makeSUT(with: .success((invalidJSON, response)))
        
        do {
            try await sut.load()
            XCTFail("Expected to throw \(RemoteSalonLoader.Error.invalidData) but got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteSalonLoader.Error, .invalidData)
        }
    }
}

//MARK: Helper
private func makeSUT(url: URL = URL(string: "http://a-url.com")!,with result: Result<(Data, HTTPURLResponse), Error> = anyValidResponse(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy(result: result)
    let sut = RemoteSalonLoader(url: url, client: client)
    return(sut, client)
}

private  func anyValidResponse() -> Result<(Data, HTTPURLResponse), Error> {
    return .success((Data.init(_: "[]".utf8), anyValidHTTPResponse()))
}

private func anyValidHTTPResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: URL(string: "http://a-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
}

private class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func getFrom(url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try result.get()
    }
}
