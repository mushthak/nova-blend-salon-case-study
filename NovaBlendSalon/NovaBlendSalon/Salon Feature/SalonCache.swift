//
//  SalonCache.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 11/03/24.
//

import Foundation

public protocol SalonCache {
    func save(_ salons: [Salon]) async throws
}
