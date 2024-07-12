//
//  SalonRowView.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 12/07/24.
//

import SwiftUI

struct SalonRowView: View {
    let salon: SalonViewModel
    
    var body: some View {
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
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SalonRowView(salon: PreviewHelper.SalonViewModelPreview)
}
