//
//  NovaBlendSalonTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 20/01/24.
//

import XCTest
import NovaBlendSalon

final class LoadSalonFromRemoteUseCaseTests: XCTestCase {
    
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
        let emptyListJSON = makeItemsJSON(items: [])
        await withThrowingTaskGroup(of: [Salon].self) { group in
            for statusCode in samples {
                group.addTask {
                    let response = HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
                    let (sut,_) = self.makeSUT(with: .success((emptyListJSON, response)))
                    
                    return try await sut.load()
                }
            }
            
            while let nextResult = await group.nextResult() {
                switch nextResult {
                case .failure(let error):
                    XCTAssertEqual(error as? RemoteSalonLoader.Error, .invalidData)
                case .success:
                    XCTFail("Expected to throw \(RemoteSalonLoader.Error.invalidData) but got success instead")
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
        let emptyListJSON = makeItemsJSON(items: [])
        let (sut,_) = makeSUT(with: .success((emptyListJSON, anyValidHTTPResponse())))
        
        do {
            let salons: [Salon] = try await sut.load()
            XCTAssertEqual(salons, [])
        } catch {
            XCTFail("Expected to receive empty items array but got \(error) instead")
        }
    }
    
    func test_load_deliversItemsArrayOn200HTTPResponseWithJSONList() async throws {
        let item1 = makeItem(id: UUID(),
                             name: "a name",
                             location: "a location",
                             phone: nil,
                             openTime: 0.0,
                             closeTime: 1.0)
        
        let item2 = makeItem(id: UUID(),
                             name: "another name",
                             location: "another location",
                             phone: "a phone",
                             openTime: 2.0,
                             closeTime: 3.0)
        
        let json = makeItemsJSON(items: [item1.json, item2.json])
        let (sut,_) = makeSUT(with: .success((json, anyValidHTTPResponse())))
        
        do {
            let salons: [Salon] = try await sut.load()
            XCTAssertEqual(salons, [item1.model, item2.model])
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
        
    }
    
    //MARK: Helper
    private func makeSUT(url: URL = anyURL(),with result: Result<(Data, HTTPURLResponse), Error> = .success((Data.init(_: "{\"salons\": []}".utf8), anyValidHTTPResponse())), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteSalonLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteSalonLoader(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return(sut, client)
    }
    
    private  func anyValidResponse() -> Result<(Data, HTTPURLResponse), Error> {
        return .success((Data.init(_: "{\"salons\": []}".utf8), anyValidHTTPResponse()))
    }
    
    private func makeItem(id: UUID, name: String, location: String, phone: String? = nil, openTime: Float, closeTime: Float) -> (model: Salon, json: [String: Any]) {
        let model = Salon(id: id,
                          name: name,
                          location: location,
                          phone: phone,
                          openTime: openTime,
                          closeTime: closeTime)
        
        let json: [String: Any?] = [
            "id" : model.id.uuidString,
            "name": model.name,
            "location": location,
            "phone":  phone,
            "open_time": model.openTime,
            "close_time": model.closeTime
        ]
        
        return (model, json.compactMapValues { $0 })
    }
    
    private func makeItemsJSON(items: [[String : Any]]) -> Data {
        let json = ["salons": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
