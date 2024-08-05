//
//  NovaBlendAppApp.swift
//  NovaBlendApp
//
//  Created by Mushthak Ebrahim on 19/07/24.
//

import SwiftUI
import NovaBlendSalon
import NovaBlendSalonView
import SwiftData

@main
struct NovaBlendApp: App {
    var body: some Scene {
        let remoteURL = URL(string: "https://mushthak.github.io/nova-salon-api/salons")!
        let remoteClient = makeRemoteClient()
        let remoteSalonLoader = RemoteSalonLoader(url: remoteURL, client: remoteClient)
        
        let store = SwiftDataSalonStore(modelContainer: getContainer())
        let localSalonLoader = LocalSalonLoader(store: store, currentDate: Date.init)
        
        let salonLoader = SalonLoaderWithFallbackComposite(primary: SalonLoaderCacheDecorator(decoratee: remoteSalonLoader, cache: localSalonLoader), fallback: localSalonLoader)
        let salonListViewModelAdapter = SalonListViewModelAdapter(loader: salonLoader)
        let salonListViewModel = SalonListViewModel(salonListViewModelAdapter: salonListViewModelAdapter)
        
        WindowGroup {
            SalonListView(viewModel: salonListViewModel)
        }
    }
    
    //MARK: Helpers
    private func makeRemoteClient() -> HTTPClient {
        switch UserDefaults.standard.string(forKey: "connectivity") {
        case "offline":
            return AlwaysFailingHTTPClient()
            
        default:
            return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        }
    }
    
    private class AlwaysFailingHTTPClient: HTTPClient {
        func getFrom(url: URL) async throws -> (Data, HTTPURLResponse) {
            throw NSError(domain: "offline", code: 0)
        }
    }
    
    private func getContainer() -> ModelContainer {
        let container =  try! ModelContainer(for: ManagedCache.self)
        if CommandLine.arguments.contains("-reset") {
            let modelContext = ModelContext(container)
            try! modelContext.delete(model: ManagedCache.self)
        }
        return container
    }
}
