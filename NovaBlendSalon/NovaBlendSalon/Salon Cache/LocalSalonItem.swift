//
//  LocalSalonItem.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation

public struct LocalSalonItem: Equatable {
    public let id: UUID
    public let name: String
    public let location: String
    public let phone: String?
    public let openTime: Float
    public let closeTime: Float
    
    public init(id: UUID, name: String, location: String, phone: String?, openTime: Float, closeTime: Float) {
        self.id = id
        self.name = name
        self.location = location
        self.phone = phone
        self.openTime = openTime
        self.closeTime = closeTime
    }
}
