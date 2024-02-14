//
//  SalonStoreSpy.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 13/02/24.
//

import Foundation
import NovaBlendSalon

class SalonStoreSpy: SalonStore {
    typealias Result = Swift.Result<CachedSalon, Error>
    
    var receivedMessages = 0
    let result: Result
    
    init(result: Result) {
        self.result = result
    }
    
    func retrieve() async throws -> CachedSalon {
        receivedMessages += 1
        return try result.get()
    }
}
