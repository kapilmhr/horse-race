//
//  LoadingView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import SwiftUI

struct ErrorView: View {

    let errorText: String

    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 16) {
                Image(systemName: "tornado")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.primaryColor)
                Text(errorText)
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

#Preview {
    ErrorView(errorText: "Server Error")
}
