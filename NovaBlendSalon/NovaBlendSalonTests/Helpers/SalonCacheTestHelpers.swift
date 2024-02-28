//
//  SalonCacheTestHelpers.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 18/02/24.
//

import Foundation
import NovaBlendSalon

func uniqueSalons() -> (models: [Salon], local: [LocalSalonItem]) {
    let models = [uniqueSalon(), uniqueSalon()]
    let local = models.map { LocalSalonItem(id: $0.id, name: $0.name, location: $0.location, phone: $0.phone, openTime: $0.openTime, closeTime: $0.closeTime) }
    return (models, local)
}

func uniqueSalon() -> Salon {
    return Salon(id: UUID(), name: "any", location: "any", phone: "any", openTime: 0.0, closeTime: 0.0)
}

extension Date {
    func minusSalonCacheMaxAge() -> Date {
        return adding(days: -salonCacheMaxAgeInDays)
    }
    
    private var salonCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
