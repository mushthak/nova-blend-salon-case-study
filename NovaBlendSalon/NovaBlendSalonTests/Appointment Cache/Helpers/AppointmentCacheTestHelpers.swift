//
//  AppointmentCacheTestHelpers.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 12/11/24.
//

import Foundation
import NovaBlendSalon

func makeAppointmentItem() -> SalonAppointment {
    return SalonAppointment(id: UUID(),
                            time: Date.init().roundedToSeconds(),
                            phone: "a phone number",
                            email: nil,
                            notes: nil)
}

func insetionError() -> AppointmentStoreSpy.Result {
    return .failure(.insertionError)
}

func retrievalError() -> AppointmentStoreSpy.Result {
    return .failure(.retrievalError)
}

func getLocalAppointment(from model: SalonAppointment) -> LocalAppointmentItem {
    return LocalAppointmentItem(id: model.id,
                                time: model.time,
                                phone: model.phone,
                                email: model.email,
                                notes: model.notes)
}

private extension Date {
    func roundedToSeconds() -> Date {
        let timeInterval = TimeInterval(Int(self.timeIntervalSince1970))
        return Date(timeIntervalSince1970: timeInterval)
    }
}
