//
//  SalonListSnapshotTests.swift
//  NovaBlendSalonViewTests
//
//  Created by Mushthak Ebrahim on 13/07/24.
//

import XCTest
import SwiftUI
import NovaBlendSalonView

final class SalonListSnapshotTests: XCTestCase {
    
    func test_salonListWithContent() async {
        let vm = PreviewHelper.salonListViewModelPreview
        let view = SalonListView(viewModel: vm)
        let sut =  await UIHostingController(rootView: view)
        await vm.loadSalons()
        
        await assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "SALON_LIST_WITH_CONTENT_light")
        await assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "SALON_LIST_WITH_CONTENT_dark")
        await assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .extraExtraExtraLarge)), named: "SALON_LIST_WITH_CONTENT_light_extraExtraExtraLarge")
    }
}
