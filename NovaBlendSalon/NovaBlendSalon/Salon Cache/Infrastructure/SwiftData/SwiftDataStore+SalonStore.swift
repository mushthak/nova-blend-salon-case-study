//
//  SwiftDataSalonStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 25/06/24.
//

import Foundation
import SwiftData

extension SwiftDataStore: SalonStore {
    public func retrieve() async throws -> CachedSalon? {
        guard let cache = try findCache() else { return nil }
        return (salons: cache.salons.compactMap{ $0.local }, timestamp: cache.timestamp)
    }
    
    public func deleteCachedSalons() async throws {
        try deleteCache()
    }
    
    public func insert(_ salons: [NovaBlendSalon.LocalSalonItem], timestamp: Date) async throws {
        let salons = ManagedSalonItem.salons(from: salons)
        let cache = ManagedCache(salons: salons, timestamp: timestamp)
        try await insertUniqueInstance(of: cache)
    }
    
    //MARK: Helpers
    
    private func findCache() throws -> ManagedCache? {
        let descriptor = FetchDescriptor<ManagedCache>()
        return try modelContext.fetch(descriptor).first
    }
    
    private func insertUniqueInstance(of managedCache: ManagedCache) async throws {
        try deleteCache()
        modelContext.insert(managedCache)
        try modelContext.save()
    }
    
    private func deleteCache() throws {
        try modelContext.delete(model: ManagedCache.self)
    }
}
