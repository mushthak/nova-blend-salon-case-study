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
        HStack {
            Spacer()
            VStack {
                Text(salon.name).font(.title2)
                Text(salon.location)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                if (!salon.phone.isEmpty){
                    HStack {
                        Image(systemName: "phone")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text(salon.phone)
                    }
                }
                Text(salon.hours).font(.subheadline)
                
            }.padding()
            Spacer()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SalonRowView(salon: PreviewHelper.SalonViewModelPreview)
}

#Preview(traits: .sizeThatFitsLayout) {
    SalonRowView(salon: PreviewHelper.SalonViewModelPreview2)
}
