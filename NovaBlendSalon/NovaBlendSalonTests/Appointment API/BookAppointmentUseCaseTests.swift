//
//  BookAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 27/08/24.
//

import Foundation
import XCTest

private protocol HTTPClient {
    func postTo(url: URL) async throws -> (Data, HTTPURLResponse)
}

private class RemoteAppointmentBooker {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func bookAppointment() async {
        _ = try! await client.postTo(url: url)
    }
}

final class BookAppointmentUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestAppointment() {
        let (_,client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_bookAppointment_sendsAppointmentRequestToURL() async {
        let (sut, client) = makeSUT()
        await sut.bookAppointment()
        
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    //MARK: Helper
    private func makeSUT(url: URL = anyURL(),with result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyValidHTTPResponse())), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAppointmentBooker, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteAppointmentBooker(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return(sut, client)
    }
}

private class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func postTo(url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try result.get()
    }
}




