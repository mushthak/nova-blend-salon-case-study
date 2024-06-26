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
        guard let cache = try ManagedCache.find(in: modelContext) else { return nil }
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
