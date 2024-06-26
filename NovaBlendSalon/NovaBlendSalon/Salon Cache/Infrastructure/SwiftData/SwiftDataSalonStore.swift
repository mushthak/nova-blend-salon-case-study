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
    
    public func retrieve() async throws -> NovaBlendSalon.CachedSalon? {
        let descriptor = FetchDescriptor<ManagedSalonItem>()
        let salons = try modelContext.fetch(descriptor)
        return (salons: salons.compactMap{ $0.local }, timestamp: Date.init())
    }
    
    public func deleteCachedSalons() async throws {
        
    }
    
    public func insert(_ salons: [NovaBlendSalon.LocalSalonItem], timestamp: Date) async throws {
        
    }
}
