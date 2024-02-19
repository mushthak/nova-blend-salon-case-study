//
//  SalonStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation

public typealias CachedSalon = (salons: [Salon], timestamp: Date)

public protocol SalonStore {
    func retrieve() async throws -> CachedSalon
    func deleteCachedSalons() async throws
}


