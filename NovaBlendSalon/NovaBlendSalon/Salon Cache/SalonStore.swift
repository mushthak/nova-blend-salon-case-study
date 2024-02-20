//
//  SalonStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation

public typealias CachedSalon = (salons: [LocalSalonItem], timestamp: Date)

public protocol SalonStore {
    func retrieve() async throws -> CachedSalon
    func deleteCachedSalons() async throws
    func insert(_ feed: [LocalSalonItem], timestamp: Date) async throws
}


