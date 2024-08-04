//
//  NovaBlendAppApp.swift
//  NovaBlendApp
//
//  Created by Mushthak Ebrahim on 19/07/24.
//

import SwiftUI
import NovaBlendSalon
import NovaBlendSalonView

@main
struct NovaBlendApp: App {
    var body: some Scene {
        let remoteURL = URL(string: "https://mushthak.github.io/nova-salon-api/salons")!
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteSalonLoader = RemoteSalonLoader(url: remoteURL, client: remoteClient)
        let salonListViewModelAdapter = SalonListViewModelAdapter(loader: remoteSalonLoader)
        let salonListViewModel = SalonListViewModel(salonListViewModelAdapter: salonListViewModelAdapter)
        
        WindowGroup {
            SalonListView(viewModel: salonListViewModel)
        }
    }
}
