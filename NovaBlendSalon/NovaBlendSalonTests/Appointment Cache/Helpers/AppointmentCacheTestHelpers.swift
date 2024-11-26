//
//  AppointmentCacheTestHelpers.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 12/11/24.
//

import Foundation
import NovaBlendSalon

func insetionError() -> AppointmentStoreSpy.Result {
    return .failure(.insertionError)
}

func retrievalError() -> AppointmentStoreSpy.Result {
    return .failure(.retrievalError)
}

func getLocalAppointment(from model: Appointment) -> LocalAppointmentItem {
    return LocalAppointmentItem(id: model.id,
                                time: model.time,
                                phone: model.phone,
                                email: model.email,
                                notes: model.notes)
}
