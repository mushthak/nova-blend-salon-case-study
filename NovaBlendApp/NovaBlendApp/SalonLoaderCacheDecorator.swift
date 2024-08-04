//
//  SalonLoaderCacheDecorator.swift
//  NovaBlendApp
//
//  Created by Mushthak Ebrahim on 04/08/24.
//

import Foundation
import NovaBlendSalon

class SalonLoaderCacheDecorator {
    private let decoratee: SalonLoader
    private let cache: SalonCache
    
    init(decoratee: SalonLoader, cache: SalonCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load() async throws -> [Salon] {
        let result = try await decoratee.load()
        try await cache.save(result)
        return result
    }
}
