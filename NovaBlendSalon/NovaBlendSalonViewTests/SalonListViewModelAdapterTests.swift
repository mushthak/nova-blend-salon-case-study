//
//  SalonListViewModelAdapterTests.swift
//  NovaBlendSalonViewTests
//
//  Created by Mushthak Ebrahim on 10/07/24.
//

import XCTest
import NovaBlendSalon
import NovaBlendSalonView

class SalonListViewModelAdapter {
    let loader: SalonLoader
    init(loader: SalonLoader) {
        self.loader = loader
    }
    
    func load() async throws -> [SalonViewModel]  {
        let result = try await loader.load()
        return result.map { SalonViewModel(id: $0.id, name: $0.name, location: $0.location ?? "", phone: $0.phone ?? "", hours: prepareShopHours(openTime: $0.openTime, closeTime: $0.closeTime)) }
    }
    
    private func prepareShopHours(openTime: Float, closeTime: Float) -> String{
        guard let openTimeConverted = TimeFormatter.convertTo12HourFormat(from: openTime), let closeTimeConverted = TimeFormatter.convertTo12HourFormat(from: closeTime) else {
            return ""
        }
        return "Today’s hours : \(openTimeConverted) - \(closeTimeConverted)"
    }
}

class SpyLoader: SalonLoader {
    let salons:[NovaBlendSalon.Salon]
    
    init(salons: [NovaBlendSalon.Salon]) {
        self.salons = salons
    }
    func load() async throws -> [NovaBlendSalon.Salon] {
        return salons
    }
}

final class SalonListViewModelAdapterTests: XCTestCase {
    
    func test_map_salonsToSalonViewModels() async {
        let salon = uniqueSalon(with: (open: 10, close: 19), hoursString: "Today’s hours : 10:00 AM - 7:00 PM")
        let loader = SpyLoader(salons: [salon.model])
        let sut = SalonListViewModelAdapter(loader: loader)
        
        do {
            let resultViewModel = try await sut.load()
            XCTAssertEqual(resultViewModel, [salon.viewModel])
        }catch {
            XCTFail("Expected to receive salon array but got \(error) instead")
        }
    }
    
    //MARK: Helpers
    func uniqueSalon(with hours:(open: Float, close: Float), hoursString: String) -> (model: Salon, viewModel: SalonViewModel) {
        let model = uniqueSalon(with: hours)
        let viewModel = SalonViewModel(id: model.id, name: model.name, location: model.location ?? "", phone: model.phone ?? "", hours: hoursString)
        return (model, viewModel)
    }
    
    func uniqueSalon(with hours:(open: Float, close: Float)) -> Salon {
        return Salon(id: UUID(), name: "any", location: "any", phone: "any", openTime: hours.open, closeTime: hours.close)
    }
}
