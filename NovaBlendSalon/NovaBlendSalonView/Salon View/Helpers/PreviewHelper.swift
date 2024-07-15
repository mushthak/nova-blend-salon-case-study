//
//  PreviewHelper.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 12/07/24.
//

import Foundation
import NovaBlendSalon

#if DEBUG
struct PreviewHelper {
    static let salonListViewModelPreview: SalonListViewModel = {
        struct LoaderSpy: SalonLoader {
            func load() async throws -> [Salon] {
                return [
                    Salon(
                        id: UUID(),
                        name: "Nova alpha salon",
                        location: "3051 Lucky Duck Drive, Pittsburgh, Pennsylvania",
                        phone: "412-862-3526",
                        openTime: 10.0,
                        closeTime: 19.0),
                    Salon(
                        id: UUID(),
                        name: "Nova beta salon",
                        location: "214 Whitetail Lane, Richardson, Texas",
                        phone: "412-862-3512",
                        openTime: 10.30,
                        closeTime: 20.30)]
            }
        }
        
        let loader = LoaderSpy()
        let salonListViewModelAdapter = SalonListViewModelAdapter(loader: loader)
        let salonListViewModel = SalonListViewModel(salonListViewModelAdapter: salonListViewModelAdapter)
        return salonListViewModel
    }()
    
    static let SalonViewModelPreview: SalonViewModel = {
        SalonViewModel(id: UUID(), name: "Nova alpha salon", location: "3051 Lucky Duck Drive, Pittsburgh, Pennsylvania", phone: "412-862-3526", hours: "Today’s hours : 10:00 AM - 7:00 PM")
    }()
}
#endif
