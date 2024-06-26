//
//  SwiftDataSalonStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 25/06/24.
//

import Foundation
import SwiftData

public final class SwiftDataSalonStore: SalonStore {
    var modelContext: ModelContext
    
    public init(modelContext: ModelContext){
        self.modelContext = modelContext
    }
    
    public func retrieve() async throws -> CachedSalon? {
        let descriptor = FetchDescriptor<ManagedCache>()
        let result = try modelContext.fetch(descriptor)
        guard let cache = result.first else { return nil }
        return (salons: cache.salons.compactMap{ $0.local }, timestamp: cache.timestamp)
    }
    
    public func deleteCachedSalons() async throws {
        
    }
    
    public func insert(_ salons: [NovaBlendSalon.LocalSalonItem], timestamp: Date) async throws {
        let salons = ManagedSalonItem.salons(from: salons)
        let cache = ManagedCache(salons: salons, timestamp: timestamp)
        modelContext.insert(cache)
    }
}
