//
//  AppointmentTestHelpers.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 26/11/24.
//

import Foundation
import NovaBlendSalon

func makeAppointmentItem() -> Appointment {
    return Appointment(id: UUID(),
                            time: Date.init().roundedToSeconds(),
                            phone: "a phone number",
                            email: nil,
                            notes: nil)
}

func makeAppointmentItem(id: UUID, time: Date, phone: String, email: String? = nil, notes: String? = nil) -> Appointment {
    return Appointment(id: id,
                       time: time.roundedToSeconds(),
                       phone: phone, email: email,
                       notes: notes)
}

func makeItem(id: UUID, time: Date, phone: String, email: String? = nil, notes: String? = nil) -> (model: Appointment, json: [String: Any]) {
    let model = makeAppointmentItem(id: id,
                                    time: time,
                                    phone: phone,
                                    email: email,
                                    notes: notes)
    
    let json: [String: Any?] = [
        "salonId" : model.id.uuidString,
        "appointmentTime": DateFormatter.iso8601.string(from: model.time),
        "phone": model.phone,
        "email":  model.email,
        "notes": model.notes
    ]
    
    return (model, json.compactMapValues { $0 })
}

func makeItemsJSON(items: [[String : Any]]) -> Data {
    let json = ["appointments": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

func makeItemJSON(item: [String : Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: item)
}

private extension Date {
    func roundedToSeconds() -> Date {
        let timeInterval = TimeInterval(Int(self.timeIntervalSince1970))
        return Date(timeIntervalSince1970: timeInterval)
    }
}

private extension DateFormatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}
