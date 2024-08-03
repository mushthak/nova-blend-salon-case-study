//
//  SharedTestHelpers.swift
//  NovaBlendAppTests
//
//  Created by Mushthak Ebrahim on 03/08/24.
//

import Foundation
import NovaBlendSalon

func uniqueSalon() -> Salon {
    return Salon(id: UUID(), name: "any", location: "any", phone: "any", openTime: 0.0, closeTime: 0.0)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
