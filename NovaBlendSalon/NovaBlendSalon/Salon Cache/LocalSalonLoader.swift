//
//  LocalSalonLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation

public class LocalSalonLoader {
    let store: SalonStore
    let currentDate: () -> Date
    
    public enum Error: Swift.Error {
        case retrival
    }
    
    public init(store: SalonStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load() async throws -> [Salon] {
        do {
            let cache: CachedSalon = try await store.retrieve()
            if SalonCachePolicy.validate(cache.timestamp, against: currentDate()) {
                return cache.salons.toModels()
            }
            return []
        } catch  {
            throw Error.retrival
        }
    }
    
    public func save(_ salons: [Salon]) async throws {
        try await store.deleteCachedSalons()
        try await store.insert(salons.toLocal(), timestamp: currentDate())
    }
    
}

private extension Array where Element == LocalSalonItem {
    func toModels() -> [Salon] {
        return map{Salon(id: $0.id, name: $0.name, location: $0.location, phone: $0.phone, openTime: $0.openTime, closeTime: $0.closeTime)}
    }
}

private extension Array where Element == Salon {
    func toLocal() -> [LocalSalonItem] {
        return map { LocalSalonItem(id: $0.id, name: $0.name, location: $0.location, phone: $0.phone, openTime: $0.openTime, closeTime: $0.closeTime) }
    }
}
