//
//  SalonListView.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 04/07/24.
//

import SwiftUI

struct SalonListView: View {
    let viewModel = SalonListViewModel()
    
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
            viewModel.loadSalons()
        }
    }
}

#Preview {
    SalonListView()
}
