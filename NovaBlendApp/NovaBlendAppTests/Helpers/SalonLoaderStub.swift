//
//  LoaderStub.swift
//  NovaBlendAppTests
//
//  Created by Mushthak Ebrahim on 03/08/24.
//

import Foundation
import NovaBlendSalon

class SalonLoaderStub: SalonLoader {
    private let result: Result<[Salon], Error>
    
    init(result: Result<[Salon], Error>) {
        self.result = result
    }
    
    func load() async throws -> [Salon] {
        return try result.get()
    }
}
