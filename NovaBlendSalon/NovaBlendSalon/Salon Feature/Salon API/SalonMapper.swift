//
//  SalonMapper.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 26/01/24.
//

import Foundation

struct SalonMapper {
    
    private struct Root: Decodable {
        let salons: [RemoteSalonItem]
    }
    
    private struct RemoteSalonItem: Decodable {
        public let id: UUID
        public let name: String
        public let location: String?
        public let phone: String?
        public let open_time: Float
        public let close_time: Float
        
        init(id: UUID, name: String, location: String?, phone: String?, open_time: Float, close_time: Float) {
            self.id = id
            self.name = name
            self.location = location
            self.phone = phone
            self.open_time = open_time
            self.close_time = close_time
        }
        
        var salon: Salon {
            return Salon(id: id, name: name, location: location, phone: phone, openTime: open_time, closeTime: close_time)
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Salon] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteSalonLoader.Error.invalidData
        }
        
        return root.salons.map { $0.salon }
    }
}

private extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
