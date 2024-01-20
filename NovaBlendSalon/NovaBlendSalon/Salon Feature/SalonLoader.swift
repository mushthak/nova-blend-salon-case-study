//
//  SalonLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 20/01/24.
//

import Foundation

public protocol SalonLoader {
    func load() async throws -> [Salon]
}
