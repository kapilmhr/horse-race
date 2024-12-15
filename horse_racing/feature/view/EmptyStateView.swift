//
//  EmptyStateView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 16) {
                Image(systemName: "chevron.down.dotted.2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.primaryColor)
                Text("Empty")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct EmptyStateView_Preview: PreviewProvider{
    static var previews: some View{
        EmptyStateView()
    }
}
