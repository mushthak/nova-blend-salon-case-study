//
//  SalonListView.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 04/07/24.
//

import SwiftUI
import NovaBlendSalon

struct SalonListView: View {
    @State var viewModel: SalonListViewModel
    
    var body: some View {
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
