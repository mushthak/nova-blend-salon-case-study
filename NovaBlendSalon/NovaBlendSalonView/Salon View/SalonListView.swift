//
//  SalonListView.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 04/07/24.
//

import SwiftUI
import NovaBlendSalon

public struct SalonListView: View {
    
    public init(viewModel: SalonListViewModel) {
        self.viewModel = viewModel
    }
    
    @State var viewModel: SalonListViewModel
    
    public var body: some View {
        List(viewModel.salons, id: \.id) { salon in
            SalonRowView(salon: salon)
        }.task {
            await viewModel.loadSalons()
        }
    }
}

#Preview {
    return SalonListView(viewModel: PreviewHelper.salonListViewModelPreview)
}
