//
//  LoadAppointmentsFromRemoteUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/11/24.
//

import XCTest
import NovaBlendSalon

private class RemoteAppointmentLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async throws {
        _ = try await client.getFrom(url: url)
    }
}

final class LoadAppointmentsFromRemoteUseCaseTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL() {
        let (_,client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() async throws{
        let (sut,client) = makeSUT()
        _ = try await sut.load()
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    //MARK: Helper
    private func makeSUT(url: URL = anyURL(),with result: Result<(Data, HTTPURLResponse), Error> = .success((Data.init(_: "{\"appointments\": []}".utf8), anyValidHTTPResponse())), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAppointmentLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteAppointmentLoader(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return(sut, client)
    }
}
