//
//  HTTPClient.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 24/01/24.
//

import Foundation

public protocol HTTPClient {
    func getFrom(url: URL) async throws -> (Data, HTTPURLResponse)
}
