//
//  SalonListViewModel.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 04/07/24.
//

import Foundation

public struct SalonViewModel: Equatable {
    let id: UUID
    let name: String
    let location: String
    let phone: String
    let hours: String
    
    public init(id: UUID, name: String, location: String, phone: String, hours: String) {
        self.id = id
        self.name = name
        self.location = location
        self.phone = phone
        self.hours = hours
    }
}

@Observable
class SalonListViewModel {
    var salons = [SalonViewModel]()
    
    let salonListViewModelAdapter: SalonListViewModelAdapter
    
    init(salonListViewModelAdapter: SalonListViewModelAdapter) {
        self.salonListViewModelAdapter = salonListViewModelAdapter
    }
    
    func loadSalons() async {
        salons = (try? await salonListViewModelAdapter.load()) ?? []
    }
}
