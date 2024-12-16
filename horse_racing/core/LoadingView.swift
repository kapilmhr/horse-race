//
//  LoadingView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import SwiftUI

// A custom SwiftUI view that displays a loading spinner and a text label.
struct LoadingView: View {

    let text: String

    var body: some View {

        VStack(spacing: 8) {
            ProgressView()
                .tint(.primaryColor)
            Text(text)
        }
    }
}

#Preview {
    LoadingView(text: "Loading")
}
