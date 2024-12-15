//
//  RaceListView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


import SwiftUI

struct RaceListView: View {
    let races: [RaceSummary]
    let onExpired: (String) -> Void
    
    var body: some View {
        List(races, id: \.raceID) { race in
            RaceRowView(race: race, onExpired: {
                onExpired(race.raceID)
            })
        }
        .listStyle(PlainListStyle())
    }
}
