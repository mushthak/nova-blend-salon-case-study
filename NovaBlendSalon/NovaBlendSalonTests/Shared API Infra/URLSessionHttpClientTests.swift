//
//  URLSessionHttpClientTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 28/01/24.
//

import XCTest
import NovaBlendSalon

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
        let responseError = anyNSError()
        do {
            URLProtocolStub.stub(error: responseError, data: nil, response: nil)
            _ = try await makeSUT().getFrom(url: url)
            XCTFail("Expected to throw error \(responseError) but got success instead")
        } catch  {
            let receivedError = error as NSError
            XCTAssertEqual(receivedError.code, responseError.code)
            XCTAssertEqual(receivedError.domain, responseError.domain)
        }
    }
    
    func test_getFromURL_failsOnNonHTTPURLResponse() async throws {
        do {
            let data = anyData()
            let response = nonHTTPURLResponse()
            URLProtocolStub.stub(error: nil, data: data, response: response)
            _ = try await makeSUT().getFrom(url: anyURL())
            XCTFail("Expected to throw error but got success instead")
        } catch  {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() async throws {
        do {
            let data = anyData()
            let response = anyHTTPURLResponse()
            URLProtocolStub.stub(error: nil, data: data, response: response)
            let (receivedData, receivedResponse) = try await makeSUT().getFrom(url: anyURL())
            XCTAssertEqual(receivedData, data)
            XCTAssertEqual(receivedResponse.url, response.url)
            XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
        } catch  {
            XCTFail("Expected to succeed but thrown error \(error) instead")
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


extension URLSessionHttpClientTests {
    func test_postToURL_performsPOSTRequestToURL() async throws {
        let url = anyURL()
        do {
            _ = try await makeSUT().postTo(url: url)
            
            let request = URLProtocolStub.urlRequest
            XCTAssertEqual(request?.url, url)
            XCTAssertEqual(request?.httpMethod, "POST")
        } catch  {
            XCTFail("Expected to perform a GET request with url \(url) with but got \(error) instead")
        }
    }
    
    func test_postToURL_failsOnRequestError() async throws {
        let url = anyURL()
        let responseError = anyNSError()
        do {
            URLProtocolStub.stub(error: responseError, data: nil, response: nil)
            _ = try await makeSUT().postTo(url: url)
            XCTFail("Expected to throw error \(responseError) but got success instead")
        } catch  {
            let receivedError = error as NSError
            XCTAssertEqual(receivedError.code, responseError.code)
            XCTAssertEqual(receivedError.domain, responseError.domain)
        }
    }
    
    func test_postToURL_failsOnNonHTTPURLResponse() async throws {
        do {
            let data = anyData()
            let response = nonHTTPURLResponse()
            URLProtocolStub.stub(error: nil, data: data, response: response)
            _ = try await makeSUT().postTo(url: anyURL())
            XCTFail("Expected to throw error but got success instead")
        } catch  {
            XCTAssertNotNil(error)
        }
    }
    
    func test_postToURL_succeedsOnHTTPURLResponseWithData() async throws {
        do {
            let data = anyData()
            let response = anyHTTPURLResponse()
            URLProtocolStub.stub(error: nil, data: data, response: response)
            let (receivedData, receivedResponse) = try await makeSUT().postTo(url: anyURL())
            XCTAssertEqual(receivedData, data)
            XCTAssertEqual(receivedResponse.url, response.url)
            XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
        } catch  {
            XCTFail("Expected to succeed but thrown error \(error) instead")
        }
    }
}
