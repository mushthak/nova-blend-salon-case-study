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
        _ = try await sut.load()
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() async throws{
        let url = anyURL()
        let (sut,client) = makeSUT(url: url)
        
        _ = try await sut.load()
        _ = try await sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() async throws {
        let error = anyError()
        let (sut,_) = makeSUT(with: .failure(error))
        
        do {
            _ = try await sut.load()
        } catch {
            XCTAssertEqual(error as? RemoteSalonLoader.Error, .connectivity)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async throws {
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            
            Task {
                let response = HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
                let (sut,_) = makeSUT(with: .success((Data(), response)))
                
                do {
                    _ = try await sut.load()
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
            _ = try await sut.load()
            XCTFail("Expected to throw \(RemoteSalonLoader.Error.invalidData) but got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteSalonLoader.Error, .invalidData)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() async throws {
        let emptyListJSON = Data.init(_: "{\"salons\": []}".utf8)
        let (sut,_) = makeSUT(with: .success((emptyListJSON, anyValidHTTPResponse())))
        
        do {
            let salons: [Salon] = try await sut.load()
            XCTAssertEqual(salons, [])
        } catch {
            XCTFail("Expected to receive empty items array but got \(error) instead")
        }
    }
    
    func test_load_deliversItemsArrayOn200HTTPResponseWithJSONList() async throws {
        let item1 = Salon(id: UUID(),
                          name: "a name",
                          location: nil,
                          phone: nil,
                          openTime: 0.0,
                          closeTime: 1.0)
        
        let item1JSON = [ "id" : item1.id.uuidString,
                          "name": item1.name,
                          "openTime": item1.openTime,
                          "closeTime": item1.closeTime
        ] as [String : Any]
        
        let item2 = Salon(id: UUID(),
                          name: "another name",
                          location: "another location",
                          phone: "another phone",
                          openTime: 2.0,
                          closeTime: 3.0)
        
        let item2JSON = [ "id" : item2.id.uuidString,
                          "name": item2.name,
                          "location": item2.location!,
                          "phone": item2.phone!,
                          "openTime": item2.openTime,
                          "closeTime": item2.closeTime
        ] as [String : Any]
        
        let itemsJSON = [
            "salons" : [item1JSON, item2JSON]
        ]
        let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
        let (sut,_) = makeSUT(with: .success((json, anyValidHTTPResponse())))
        
        do {
            let salons: [Salon] = try await sut.load()
            XCTAssertEqual(salons, [item1, item2])
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
        
    }
}

//MARK: Helper
private func makeSUT(url: URL = anyURL(),with result: Result<(Data, HTTPURLResponse), Error> = anyValidResponse(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy(result: result)
    let sut = RemoteSalonLoader(url: url, client: client)
    return(sut, client)
}

private  func anyValidResponse() -> Result<(Data, HTTPURLResponse), Error> {
    return .success((Data.init(_: "{\"salons\": []}".utf8), anyValidHTTPResponse()))
}

private func anyValidHTTPResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

private func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

private func anyError() -> Error {
    return NSError(domain: "Test", code: 0)
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
