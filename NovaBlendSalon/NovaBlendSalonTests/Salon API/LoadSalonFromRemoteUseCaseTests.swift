//
//  NovaBlendSalonTests.swift
//  NovaBlendSalonTests
//
//  Created by Mushthak Ebrahim on 20/01/24.
//

import XCTest
import NovaBlendSalon

final class LoadSalonFromRemoteUseCaseTests: LoadFromRemoteUseCaseTestsBase<SalonLoaderSpec> {}

extension RemoteSalonLoader: RemoteLoader {
    typealias Model = Salon
}
