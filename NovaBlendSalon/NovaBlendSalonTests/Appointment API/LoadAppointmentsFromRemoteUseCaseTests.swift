//
//  LoadAppointmentsFromRemoteUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/11/24.
//

import XCTest
import NovaBlendSalon

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
            XCTAssertEqual(error as? RemoteAppointmentLoader.Error, .connectivity)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async throws {
        let samples = [199, 201, 300, 400, 500]
        let emptyListJSON = makeItemsJSON(items: [])
        await withThrowingTaskGroup(of: [Appointment].self) { group in
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
                    XCTAssertEqual(error as? RemoteAppointmentLoader.Error, .invalidData)
                case .success:
                    XCTFail("Expected to throw \(RemoteAppointmentLoader.Error.invalidData) but got success instead")
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
            XCTFail("Expected to throw \(RemoteAppointmentLoader.Error.invalidData) but got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteAppointmentLoader.Error, .invalidData)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() async throws {
        let emptyListJSON = makeItemsJSON(items: [])
        let (sut,_) = makeSUT(with: .success((emptyListJSON, anyValidHTTPResponse())))
        
        do {
            let appointments: [Appointment] = try await sut.load()
            XCTAssertEqual(appointments, [])
        } catch {
            XCTFail("Expected to receive empty items array but got \(error) instead")
        }
    }
    
    func test_load_deliversItemsArrayOn200HTTPResponseWithJSONList() async throws {
        let item1 = makeItem(id: UUID(),
                             time: Date(),
                             phone: "any phone")
        
        let item2 = makeItem(id: UUID(),
                             time: Date(),
                             phone: "another phone")
        
        let json = makeItemsJSON(items: [item1.json, item2.json])
        let (sut,_) = makeSUT(with: .success((json, anyValidHTTPResponse())))
        
        do {
            let appointments: [Appointment] = try await sut.load()
            XCTAssertEqual(appointments, [item1.model, item2.model])
        } catch {
            XCTFail("Expected to receive items array but got \(error) instead")
        }
        
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
