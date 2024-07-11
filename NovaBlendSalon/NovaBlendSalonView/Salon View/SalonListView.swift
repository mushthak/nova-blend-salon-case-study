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
            VStack {
                Text(salon.name).font(.title2)
                Text(salon.location)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                HStack {
                    Image(systemName: "phone")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text(salon.phone)
                }
                Text(salon.hours).font(.subheadline)
                
            }.padding()
        }.task {
            await viewModel.loadSalons()
        }
    }
}

#Preview {
    return SalonListView(viewModel: PreviewHelper.salonListViewModelPreview)
}

#if DEBUG
struct PreviewHelper {
    static let salonListViewModelPreview: SalonListViewModel = {
        struct LoaderSpy: SalonLoader {
            func load() async throws -> [Salon] {
                return [
                    Salon(
                        id: UUID(),
                        name: "Nova alpha salon",
                        location: "3051 Lucky Duck Drive, Pittsburgh, Pennsylvania",
                        phone: "412-862-3526",
                        openTime: 10.0,
                        closeTime: 19.0)]
            }
        }
        
        let loader = LoaderSpy()
        let salonListViewModelAdapter = SalonListViewModelAdapter(loader: loader)
        let salonListViewModel = SalonListViewModel(salonListViewModelAdapter: salonListViewModelAdapter)
        return salonListViewModel
    }()
}
#endif
