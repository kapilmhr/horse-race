//
//  MultiSelectSegmentedControl.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


import SwiftUI

import SwiftUI

struct MultiSelectSegmentedControl: View {
    let options: [RaceCategory] // Array of SVG image names
    @Binding var selectedOptions: Set<RaceCategory>
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Filter categories")
            HStack(spacing: 0) { // No spacing between buttons
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        toggleSelection(option)
                    }) {
                        ZStack(alignment: .bottom) {
                            
                            // Load the SVG image
                            Image(option.id.lowercased())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50) // Adjust size as needed
                            
                            // Bottom indicator for selection
                            if selectedOptions.contains(option) {
                                Rectangle()
                                    .fill(Color.primaryColor) // Selected color
                                    .frame(height: 4) // Height of the selection indicator
                                    .padding(.top, 50) // Position it below the image
                            }
                        }
                        .frame(maxWidth: .infinity) // Fill available width
                        .padding(.trailing, 10) // Optional padding for aesthetics
                    }
                }
            }
        }
        .padding()
        .background(Color.rowBackgroundColor)
    }
    
    private func toggleSelection(_ option: RaceCategory) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}
