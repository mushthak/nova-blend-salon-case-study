//
//  BookAppointmentUseCaseTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 27/08/24.
//

import Foundation
import XCTest
import NovaBlendSalon

final class BookAppointmentUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestAppointment() {
        let (_,client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_bookAppointment_sendsAppointmentRequestToURL() async {
        let (sut, client) = makeSUT()
        let appointment = makeAppointmentItem()
        
        _ = try? await sut.bookAppointment(appointment: appointment)
        
        XCTAssertFalse(client.requestedURLs.isEmpty)
        XCTAssertNotNil(client.postDataObjects.first)
    }
    
    func test_bookAppointment_deliversConnectivityErrorOnClientError() async throws {
        let error = anyError()
        let (sut,_) = makeSUT(with: .failure(error))
        
        do {
            let appointment = makeAppointmentItem()
            _ = try await sut.bookAppointment(appointment: appointment)
            XCTFail("Expected to throw \(RemoteAppointmentBooker.Error.connectivity) error. But got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteAppointmentBooker.Error, .connectivity)
        }
    }
    
    func test_bookAppointment_deliversAppointmentFailureErrorOnNon201HTTPResponse() async {
        let samples = [199, 200, 300, 400, 500]
        let appointment = makeAppointmentItem()
        await withThrowingTaskGroup(of: Void.self) { group in
            for statusCode in samples {
                group.addTask {
                    let response = HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
                    let (sut,_) = self.makeSUT(with: .success((anyData(), response)))
                    
                    _ = try await sut.bookAppointment(appointment: appointment)
                }
            }
            
            while let nextResult = await group.nextResult() {
                switch nextResult {
                case .failure(let error):
                    XCTAssertEqual(error as? RemoteAppointmentBooker.Error, .AppointmentFailure)
                case .success:
                    XCTFail("Expected to throw \(RemoteAppointmentBooker.Error.AppointmentFailure) but got success instead")
                }
            }
        }
    }
    
    func test_load_deliversInvalidDataErrorOn201HTTPResponseWithInvalidJSON() async throws {
        do {
            let appointment = makeAppointmentItem()
            let invalidJSON = Data.init(_: "invalid json".utf8)
            let response = HTTPURLResponse(url: anyURL(), statusCode: 201, httpVersion: nil, headerFields: nil)!
            let (sut,_) = self.makeSUT(with: .success((invalidJSON, response)))
            
            let bookedAppointment = try await sut.bookAppointment(appointment: appointment)
            XCTAssertEqual(bookedAppointment, appointment)
            XCTFail("Expect to throw \(RemoteAppointmentBooker.Error.invalidData) but got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteAppointmentBooker.Error, .invalidData)
        }
    }
    
    func test_bookAppointment_succeedsOn201HTTPResponseWithValidJSON() async {
        do {
            let appointment = makeItem()
            let appointmentData = makeItemJSON(item: appointment.json)
            let response = HTTPURLResponse(url: anyURL(), statusCode: 201, httpVersion: nil, headerFields: nil)!
            let (sut,_) = self.makeSUT(with: .success((appointmentData, response)))
            
            let bookedAppointment = try await sut.bookAppointment(appointment: appointment.model)
            XCTAssertEqual(bookedAppointment, appointment.model)
        } catch {
            XCTFail("Expect to succeed but got \(error) instead")
        }
    }
    
    
    //MARK: Helper
    private func makeSUT(url: URL = anyURL(),with result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyValidHTTPResponse())), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAppointmentBooker, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteAppointmentBooker(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return(sut, client)
    }
    
    private func makeItem() -> (model: Appointment, json: [String: Any]) {
        let model = makeAppointmentItem()
        let json: [String: Any?] = [
            "id" : model.id.uuidString,
            "appointmentTime": ISO8601DateFormatter().string(from: model.time),
            "phone": model.phone,
            "email": model.email,
            "notes": model.notes
        ]
        return (model, json.compactMapValues { $0 })
    }
}



