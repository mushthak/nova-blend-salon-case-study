//
//  SalonLoaderSpec.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 11/08/25.
//

import NovaBlendSalon
import Foundation

struct SalonLoaderSpec: RemoteLoaderTestable {
    typealias LoaderError = RemoteSalonLoader.Error
    
    static var connectivityError: LoaderError { .connectivity }
    static var invalidDataError: LoaderError { .invalidData }
    
    static func makeLoader(url: URL, client: HTTPClientSpy) -> RemoteSalonLoader {
        RemoteSalonLoader(url: url, client: client)
    }
    
    static func makeItemsJSON(items: [[String : Any]]) -> Data {
        let json = ["salons": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    static func makeItem(id: UUID, name: String, location: String, phone: String? = nil, openTime: Float, closeTime: Float) -> (model: Salon, json: [String: Any]) {
        let model = Salon(id: id,
                          name: name,
                          location: location,
                          phone: phone,
                          openTime: openTime,
                          closeTime: closeTime)
        
        let json: [String: Any?] = [
            "id" : model.id.uuidString,
            "name": model.name,
            "location": location,
            "phone":  phone,
            "open_time": model.openTime,
            "close_time": model.closeTime
        ]
        
        return (model, json.compactMapValues { $0 })
    }
    
    static func makeSampleItems() -> (json: [[String : Any]], models: [Salon]) {
        let item = makeItem(id: UUID(),
                             name: "a name",
                             location: "a location",
                             phone: nil,
                             openTime: 0.0,
                             closeTime: 1.0)
        
        return (json: [item.json], models: [item.model])
    }
}
