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
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }
}
