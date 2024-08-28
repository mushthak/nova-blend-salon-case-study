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
        let (appointment,appointmentData) = makeAppointmentItem()
        
        try? await sut.bookAppointment(appointment: appointment)
        
        XCTAssertFalse(client.requestedURLs.isEmpty)
        XCTAssertEqual(client.postDataObjects, [appointmentData])
    }
    
    func test_bookAppointment_deliversConnectivityErrorOnClientError() async throws {
        let error = anyError()
        let (sut,_) = makeSUT(with: .failure(error))
        
        do {
            let (appointment,_) = makeAppointmentItem()
            _ = try await sut.bookAppointment(appointment: appointment)
            XCTFail("Expected to throw \(RemoteAppointmentBooker.Error.connectivity) error. But got success instead")
        } catch {
            XCTAssertEqual(error as? RemoteAppointmentBooker.Error, .connectivity)
        }
    }
    
    func test_bookAppointment_deliversAppointmentFailureErrorOnNon201HTTPResponse() async {
        let samples = [199, 200, 300, 400, 500]
        let (appointment,_) = makeAppointmentItem()
        await withThrowingTaskGroup(of: Void.self) { group in
            for statusCode in samples {
                group.addTask {
                    let response = HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
                    let (sut,_) = self.makeSUT(with: .success((anyData(), response)))
                    
                    try await sut.bookAppointment(appointment: appointment)
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
    
    func test_bookAppointment_succeedsOn201HTTPResponse() async {
        do {
            let response = HTTPURLResponse(url: anyURL(), statusCode: 201, httpVersion: nil, headerFields: nil)!
            let (sut,_) = self.makeSUT(with: .success((anyData(), response)))
            
            let (appointment,_) = makeAppointmentItem()
            try await sut.bookAppointment(appointment: appointment)
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
    
    private func makeAppointmentItem() -> (SalonAppointment, Data) {
        let appointment = SalonAppointment(id: UUID(),
                                          time: Date.init(),
                                          phone: "a phone number",
                                          email: "an email",
                                          notes: "a note")
        let appointmentData = try! JSONEncoder().encode(appointment)
        return (appointment, appointmentData)
    }
}




