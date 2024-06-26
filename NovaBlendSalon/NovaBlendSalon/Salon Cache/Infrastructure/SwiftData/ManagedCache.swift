//
//  ManagedCache.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 26/06/24.
//

import Foundation
import SwiftData

@Model class ManagedCache {
    var timestamp: Date
    @Relationship(deleteRule: .cascade, inverse: \ManagedSalonItem.cache)
    var salons = [ManagedSalonItem]()
    
    init(salons: [ManagedSalonItem], timestamp: Date) {
        self.timestamp = timestamp
        self.salons = salons
    }
    
    static func find(in modelContext: ModelContext) throws -> ManagedCache? {
        let descriptor = FetchDescriptor<ManagedCache>()
        return try modelContext.fetch(descriptor).first
    }
}
