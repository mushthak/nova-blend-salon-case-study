//
//  SwiftDataSalonStore.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 25/06/24.
//

import Foundation

public final class SwiftDataSalonStore: SalonStore {
    public init(){}
    
    public func retrieve() async throws -> NovaBlendSalon.CachedSalon {
        return (salons: [], timestamp: Date.init())
    }
    
    public func deleteCachedSalons() async throws {
        
    }
    
    public func insert(_ salons: [NovaBlendSalon.LocalSalonItem], timestamp: Date) async throws {
        
    }
}
