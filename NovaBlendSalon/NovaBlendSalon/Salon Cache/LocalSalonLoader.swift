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
                return cache.salons
            }
            return []
        } catch  {
            throw Error.retrival
        }
    }
    
}
