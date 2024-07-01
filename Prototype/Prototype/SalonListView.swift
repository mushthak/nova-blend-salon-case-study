//
//  ContentView.swift
//  Prototype
//
//  Created by Mushthak Ebrahim on 01/07/24.
//

import SwiftUI

struct SalonListView: View {
    var body: some View {
        List(0 ..< 10) { item in
            VStack {
                Text("Nova alpha salon").font(.title2)
                Text("3051 Lucky Duck Drive, Pittsburgh, Pennsylvania")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                HStack {
                    Image(systemName: "phone")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("412-862-3526")
                }
                Text("Today’s hours : 10am -7pm").font(.subheadline)
                
            }.padding()
        }
    }
}

#Preview {
    SalonListView()
}
