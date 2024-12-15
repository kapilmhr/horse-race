//
//  RaceViewModel.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import Foundation

protocol RaceViewModel:ObservableObject{
    func fetchRaces() async
}

@MainActor
final class RaceViewModelImpl: RaceViewModel{
    
    @Published private(set) var raceSummariesViewState:ViewState<[RaceSummary]> = .ideal
    
    private var refreshTask: Task<Void, Never>?
    
    private let raceService: RaceService
    
    
    init(raceService: RaceService){
        self.raceService = raceService
        startAutoRefresh()
    }
    
    deinit{
        refreshTask?.cancel() // Cancel the task when ViewModel is deallocated
        
    }
    
    func fetchRaces() async {
        raceSummariesViewState = .loading(placeholder: nil)
        do{
            let response = try await raceService.getRaces()
            raceSummariesViewState = .success(response:response)
        } catch{
            raceSummariesViewState = .error(error: error)
        }
    }
    
    
    
    // Set up an auto-refreshing mechanism using a Task
    private func startAutoRefresh() {
        refreshTask = Task {
            while !Task.isCancelled {
                await fetchRaces()
                try? await Task.sleep(nanoseconds: 30_000_000_000) // Refresh every 30 seconds
            }
        }
    }
    
    // Start a timer to update race countdowns
    //    private func startTimers() {
    //        timerTask = Task {
    //            while !Task.isCancelled {
    //                updateRaceTimers()
    //                try? await Task.sleep(nanoseconds: 1_000_000_000) // Update every 1 second
    //            }
    //        }
    //    }
  /*
    private func updateRaceTimers() {
        guard case let .success(raceSummaries) = raceSummariesViewState else { return }
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let updatedRaces = raceSummaries.map { race -> RaceSummary? in
            var updatedRace = race
            let timeRemaining = max(updatedRace.advertisedStart.seconds - currentTimestamp, 0)
            let elapsedTime = max(currentTimestamp - updatedRace.advertisedStart.seconds, 0)
            
            if timeRemaining > 0 {
                updatedRace.timer = timeRemaining.formatSecondsToTime() // Countdown
            } else if elapsedTime < 60 {
                updatedRace.timer = "-\(elapsedTime) s" // Elapsed time
            } else {
                //                updatedRace.timer = "Event has started!"
                return nil
            }
            return updatedRace
        }.compactMap { $0 }
        raceSummariesViewState = .success(response: updatedRaces)
    }
    */
    
    // Removes expired race from the list
    func removeExpiredRace(raceID: String) {
        // Ensure this is called on the main thread
        Task { @MainActor in
            if case .success(var races) = raceSummariesViewState {
                races.removeAll { $0.raceID == raceID }
                raceSummariesViewState = .success(response: races)
            }
        }
    }
}
