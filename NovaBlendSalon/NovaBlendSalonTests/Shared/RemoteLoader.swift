//
//  AsyncLoader.swift
//  NovaBlendSalon
//
//  Created by Mushthak Ebrahim on 11/08/25.
//


protocol RemoteLoader: AnyObject {
    associatedtype Model where Model: Equatable
    func load() async throws -> [Model]
}
