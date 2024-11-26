//
//  LoadAppointmentsFromRemoteUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 24/11/24.
//

import XCTest
import NovaBlendSalon

private struct RemoteAppointmentItem: Decodable {
    public let salonId: UUID
    public let appointmentTime: Date
    public let phone: String
    public let email: String?
    public let notes: String?
    
    var appointment: Appointment {
        return Appointment(id: salonId, time: appointmentTime, phone: phone, email: email, notes: notes)
    }
}

private struct Root: Decodable {
    let appointments: [RemoteAppointmentItem]
}

private class RemoteAppointmentLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async throws -> [Appointment] {
        guard let (data, response) = try? await client.getFrom(url: url) else {
            throw Error.connectivity
        }
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteAppointmentLoader.Error.invalidData
        }
        return root.appointments.map { $0.appointment }
    }
    
}

private extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
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
    
    //MARK: Helper
    private func makeSUT(url: URL = anyURL(),with result: Result<(Data, HTTPURLResponse), Error> = .success((Data.init(_: "{\"appointments\": []}".utf8), anyValidHTTPResponse())), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAppointmentLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteAppointmentLoader(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return(sut, client)
    }
    
    private func makeItemsJSON(items: [[String : Any]]) -> Data {
        let json = ["appointments": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
