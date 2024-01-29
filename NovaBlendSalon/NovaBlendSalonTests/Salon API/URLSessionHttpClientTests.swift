//
//  URLSessionHttpClientTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 28/01/24.
//

import XCTest
import NovaBlendSalon

public final class URLSessionHTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func getFrom(url: URL) async throws {
        let _ = try await session.data(from: url)
    }
    
}

final class URLSessionHttpClientTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performsGETRequestWithURL() async throws {
        let url = anyURL()
        do {
            _ = try await makeSUT().getFrom(url: url)
            
            let request = URLProtocolStub.urlRequest
            XCTAssertEqual(request?.url, url)
            XCTAssertEqual(request?.httpMethod, "GET")
        } catch  {
            XCTFail("Expected to perform a GET request with url \(url) with but got \(error) instead")
        }
    }
    
    func test_getFromURL_failsOnRequestError() async throws {
        let url = anyURL()
        let requestError = anyNSError() 
        do {
            URLProtocolStub.error = requestError
            try await makeSUT().getFrom(url: url)
            XCTFail("Expected to throw error \(requestError) but got success instead")
        } catch  {
            let receivedError = error as NSError
            XCTAssertEqual(receivedError.code, requestError.code)
            XCTAssertEqual(receivedError.domain, requestError.domain)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }

}
