//
//  ManagedSalonItem.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 25/06/24.
//

import Foundation
import SwiftData

@Model public class ManagedSalonItem {
    public let id: UUID
    let name: String
    let location: String?
    let phone: String?
    let openTime: Float
    let closeTime: Float
    
    public init(id: UUID, name: String, location: String?, phone: String?, openTime: Float, closeTime: Float) {
        self.id = id
        self.name = name
        self.location = location
        self.phone = phone
        self.openTime = openTime
        self.closeTime = closeTime
    }
    
    var local: LocalSalonItem {
        return LocalSalonItem(id: id, name: name, location: location, phone: phone, openTime: openTime, closeTime: closeTime)
    }
}
