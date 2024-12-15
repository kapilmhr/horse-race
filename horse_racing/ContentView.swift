//
//  ContentView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var raceViewModel = RaceViewModelImpl(
        raceService: RaceServiceImpl()
    )
    
    @State private var selectedOptions: Set<RaceCategory> = []
    
    let options = [
        RaceCategory.horse,
        RaceCategory.greyhound,
        RaceCategory.harness
    ]
    
    var body: some View {
        ZStack {
            switch raceViewModel.raceSummariesViewState {
            case .loading, .ideal:
                LoadingView(text: "Loading")
            case .empty:
                EmptyStateView()
            case .success(let response):
                VStack {
                    MultiSelectSegmentedControl(
                        options: options,
                        selectedOptions: $selectedOptions
                    )
                    
                    let filteredRaces = Array(response
                        .filter { race in
                            selectedOptions.isEmpty ||
                            selectedOptions.map { $0.description }.contains(race.categoryID)
                        }
                        .prefix(5))
                    
                    if filteredRaces.isEmpty {
                        EmptyStateView()
                    } else {
                        RaceListView(
                            races: filteredRaces,
                            onExpired: { raceID in
                                raceViewModel.removeExpiredRace(raceID: raceID)
                            }
                        )
                    }
                }
            case .error(error: let error):
                Text(error.localizedDescription)
            }
        }
    }
}
#Preview {
    ContentView()
}
