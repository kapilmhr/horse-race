//
//  ContentView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import SwiftUI

struct RacingView: View {
    @StateObject private var raceViewModel = RaceViewModelImpl()
    
    
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
            case .success(_):
                VStack {
                    MultiSelectSegmentedControl(
                        options: options,
                        selectedOptions: $raceViewModel.selectedOptions
                    )
                    if raceViewModel.filteredRaces.isEmpty {
                        EmptyStateView()
                    } else {
                        RaceListView(
                            races: raceViewModel.filteredRaces,
                            onExpired: { raceID in
                                raceViewModel.removeExpiredRace(raceId: raceID)
                            }
                        )
                    }
                }
            case .error(error: let error):
                ErrorView(errorText: error.localizedDescription)
            }
        }
    }
}
#Preview {
    RacingView()
}
