//
//  SalonListViewModelAdapter.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 11/07/24.
//

import Foundation
import NovaBlendSalon

public class SalonListViewModelAdapter {
    let loader: SalonLoader
    
    public init(loader: SalonLoader) {
        self.loader = loader
    }
    
    public func load() async throws -> [SalonViewModel]  {
        let result = try await loader.load()
        return result.map { SalonViewModel(id: $0.id, name: $0.name, location: $0.location, phone: $0.phone ?? "", hours: prepareShopHours(openTime: $0.openTime, closeTime: $0.closeTime)) }
    }
    
    //MARK: Helpers
    private func prepareShopHours(openTime: Float, closeTime: Float) -> String{
        guard let openTimeConverted = TimeFormatter.convertTo12HourFormat(from: openTime), let closeTimeConverted = TimeFormatter.convertTo12HourFormat(from: closeTime) else {
            return ""
        }
        return "Today’s hours : \(openTimeConverted) - \(closeTimeConverted)"
    }
}
