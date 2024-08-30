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
#if DEBUG
        if let connectivity = UserDefaults.standard.string(forKey: "connectivity") {
            return DebuggingHTTPClient(connectivity: connectivity)
        }
#endif
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
#if DEBUG
    private class DebuggingHTTPClient: HTTPClient {
        
        private let connectivity: String
        
        init(connectivity: String) {
            self.connectivity = connectivity
        }
        
        func getFrom(url: URL) async throws -> (Data, HTTPURLResponse) {
            guard connectivity == "online" else {
                throw NSError(domain: "offline", code: 0)}
            return makeSuccessfulResponse(for: url)
        }
        
        func postTo(url: URL, data: Data) async throws -> (Data, HTTPURLResponse) {
            //TODO: Implement this when composing post functionality
            throw NSError(domain: "implementation pending", code: 0)
        }
        
        private func makeSuccessfulResponse(for url: URL) -> (Data, HTTPURLResponse) {
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (makeFeedData(), response)
        }
        
        private func makeFeedData() -> Data {
            return try! JSONSerialization.data(withJSONObject: ["salons": [
                ["id": UUID().uuidString,
                 "name": "Nova alpha salon",
                 "location": "3051 Lucky Duck Drive, Pittsburgh, Pennsylvania",
                 "phone": "4128623526",
                 "open_time": 10.00,
                 "close_time": 22.00],
                ["id": UUID().uuidString,
                 "name": "Nova beta salon",
                 "location": "214 Whitetail Lane, Richardson, Texas",
                 "open_time": 10.30,
                 "close_time": 20.30],
                ["id": UUID().uuidString,
                 "name": "Nova gamma salon",
                 "location": "4998 Yorkie Lane, Ellabelle, Georgia",
                 "open_time": 8.00,
                 "close_time": 14.00],
                ["id": UUID().uuidString,
                 "name": "Nova salon kids",
                 "location": "3300 Main Street, Bothell, Washington",
                 "open_time": 11.00,
                 "close_time": 16.00]
            ]])
        }
    }
#endif
    
    private func getContainer() -> ModelContainer {
        let container =  try! ModelContainer(for: ManagedCache.self)
#if DEBUG
        if CommandLine.arguments.contains("-reset") {
            let modelContext = ModelContext(container)
            try! modelContext.delete(model: ManagedCache.self)
        }
#endif
        return container
    }
}
