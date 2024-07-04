//
//  SalonListViewModel.swift
//  NovaBlendSalonUI
//
//  Created by Mushthak Ebrahim on 04/07/24.
//

import Foundation

@Observable
class SalonListViewModel {
    
    struct SalonViewModel {
        let id: UUID
        let name: String
        let location: String
        let phone: String
        let hours: String
    }
    
    var salons = [SalonViewModel]()
    
    func loadSalons() {
        salons = SalonListViewModel.prototypeSalons
    }
}

extension SalonListViewModel {
    static var prototypeSalons: [SalonViewModel] {
        return [
            SalonViewModel(
                id: UUID(),
                name: "Nova alpha salon",
                location: "3051 Lucky Duck Drive, Pittsburgh, Pennsylvania",
                phone: "412-862-3526",
                hours: "Today’s hours : 10am -7pm"
            ),
            SalonViewModel(
                id: UUID(),
                name: "Nova beta salon",
                location: "214 Whitetail Lane, Richardson, Texas",
                phone: "312-862-3526",
                hours: "Today’s hours : 10am -7pm"
            ),
            SalonViewModel(
                id: UUID(),
                name: "Nova gamma salon",
                location: "4998 Yorkie Lane, Ellabelle, Georgia",
                phone: "212-862-3526",
                hours: "Today’s hours : 10am -7pm"
            ),
            SalonViewModel(
                id: UUID(),
                name: "Nova salon kids",
                location: "3300 Main Street, Bothell, Washington",
                phone: "112-862-3526",
                hours: "Today’s hours : 10am -7pm"
            ),
        ]
    }
}
