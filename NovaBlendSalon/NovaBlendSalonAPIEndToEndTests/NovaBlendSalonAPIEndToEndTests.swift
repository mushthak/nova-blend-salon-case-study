//
//  NovaBlendSalonAPIEndToEndTests.swift
//  NovaBlendSalonAPIEndToEndTests
//
//  Created by Mushthak Ebrahim on 03/02/24.
//

import XCTest
import NovaBlendSalon

final class NovaBlendSalonAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGetSalons_matchesFixedTestAccountData() async {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteSalonLoader(url: URL(string: "https://mushthak.github.io/nova-salon-api/salons")!, client: client)
        trackForMemoryLeak(client)
        trackForMemoryLeak(loader)
        do {
            let salons = try await loader.load()
            XCTAssertEqual(salons.count, 4, "Expected 4 salons in the test account for salon get result")
            XCTAssertEqual(salons[0], expectedSalon(at: 0))
            XCTAssertEqual(salons[1], expectedSalon(at: 1))
            XCTAssertEqual(salons[2], expectedSalon(at: 2))
            XCTAssertEqual(salons[3], expectedSalon(at: 3))
        }catch {
            XCTFail("Expected successfull result but got \(error) instead")
        }
    }
    
    //MARK: Helpers
    private func expectedSalon(at index: Int) -> Salon {
        return Salon(id: id(at: index),
                     name: name(at: index),
                     location: location(at: index),
                     phone: phone(at: index),
                     openTime: openTime(at: index),
                     closeTime: closeTime(at: index))
    }
    
    private func id(at index: Int) -> UUID {
        return UUID(uuidString: [
            "4a832c92-2486-4407-b338-aab2b26c0894",
            "cc38f4e5-f351-435b-a764-165482942457",
            "649a9243-c110-4420-8057-923e9055fc9a",
            "0c38e395-5cfc-4be5-a922-9676eac0c267"
        ][index])!
    }
    
    private func name(at index: Int) -> String {
        return [
            "Nova alpha salon",
            "Nova beta salon",
            "Nova gamma salon",
            "Nova salon kids"
        ][index]
    }
    
    private func location(at index: Int) -> String {
        return [
            "3051 Lucky Duck Drive, Pittsburgh, Pennsylvania",
            "214 Whitetail Lane, Richardson, Texas",
            "4998 Yorkie Lane, Ellabelle, Georgia",
            "3300 Main Street, Bothell, Washington"
        ][index]
    }
    
    private func phone(at index: Int) -> String? {
        return [
            "4128623526",
            nil,
            nil,
            nil
        ][index]
    }
    
    private func openTime(at index: Int) -> Float {
        return [
            10.00,
            10.30,
            8.00,
            11.00
        ][index]
    }
    
    private func closeTime(at index: Int) -> Float {
        return [
            22.00,
            20.30,
            14.00,
            16.00
        ][index]
    }
}


extension NovaBlendSalonAPIEndToEndTests {
    func test_endToEndTestServerBookApppointment_matchesFixedTestAppointmentBookedResponse() async {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let booker = RemoteAppointmentBooker(url: URL(string: "https://run.mocky.io/v3/c45a1211-3a83-48a1-a2c9-643efa2f0d7b")!, client: client)
        trackForMemoryLeak(client)
        trackForMemoryLeak(booker)
        do {
            let appointment = makeAppointmentItem()
            let result = try await booker.bookAppointment(appointment: appointment)
            XCTAssertEqual(result, appointment)
        }catch {
            XCTFail("Expected successfull result but got \(error) instead")
        }
    }
    
    //MARK: Helpers
    private func makeAppointmentItem() -> (Appointment) {
        return Appointment(id: UUID(uuidString: "9208E424-2EA9-4862-BD1B-0A1DA148382A")!,
                                time: Date.init(timeIntervalSince1970: 1731418080),
                                          phone: "a phone number",
                                          email: nil,
                                          notes: nil)
    }
}
