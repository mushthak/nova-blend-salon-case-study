//
//  SalonLoaderWithFallbackComposite.swift
//  NovaBlendApp
//
//  Created by Mushthak Ebrahim on 23/07/24.
//

import Foundation
import NovaBlendSalon

class SalonLoaderWithFallbackComposite: SalonLoader {
    
    private let primary: SalonLoader
    private let fallback: SalonLoader
    
    init(primary: SalonLoader, fallback: SalonLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load() async throws -> [NovaBlendSalon.Salon] {
        do {
            return try await primary.load()
        } catch {
            return try await fallback.load()
        }
    }
}
