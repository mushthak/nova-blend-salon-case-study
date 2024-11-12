//
//  AppointmentStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 07/11/24.
//

import Foundation

public protocol AppointmentStore {
    func insert(_ appointment: LocalAppointmentItem) throws
    func retrieve()
}
