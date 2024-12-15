//
//  RaceRowView.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


import SwiftUI

struct RaceRowView: View {
    let race: RaceSummary
    
    @StateObject private var timerViewModel: TimerViewModel
    
    init(race: RaceSummary, onExpired: @escaping () -> Void) {
        _timerViewModel = StateObject(wrappedValue: TimerViewModel(advertisedStart: race.advertisedStart.seconds, onExpired: onExpired))
        self.race = race
    }
    
    var body: some View {
        HStack {
            Image(getImageName(categoryId: race.categoryID))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text("R\(race.raceNumber)")
                .bold()
                .font(.headline)
                .accessibilityLabel("Race Number: \(race.raceNumber)")
            Text(race.meetingName)
                .font(.subheadline)
            Spacer()
            Text(timerViewModel.timerText)
                .font(.caption)
                .foregroundColor(timerViewModel.timerText.starts(with: "-") ? .red : .black)
        }
        .padding(8)
    }
    
    private func getImageName(categoryId: String) -> String {
        switch categoryId {
        case RaceCategory.horse.description:
            return RaceCategory.horse.id.lowercased()
        case RaceCategory.greyhound.description:
            return RaceCategory.greyhound.id.lowercased()
        case RaceCategory.harness.description:
            return RaceCategory.harness.id.lowercased()
        default:
            return ""
        }
    }
}
