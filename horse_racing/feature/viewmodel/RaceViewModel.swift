//
//  RaceViewModel.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import Foundation

/// A protocol that defines the functionality of a view model for fetching and managing race data.
protocol RaceViewModel:ObservableObject{
    func fetchRaces() async
    
}

@MainActor
final class RaceViewModelImpl: RaceViewModel{
    
    /// A view state representing the current status of race summaries (e.g., loading, success, error).
    @Published private(set) var raceSummariesViewState:ViewState<[RaceSummary]> = .ideal
    
    /// A set of selected race categories used for filtering the races.
    @Published var selectedOptions: Set<RaceCategory> = []
    
    /// A task responsible for auto-refreshing the race data at regular intervals.
    private var refreshTask: Task<Void, Never>?
    
    /// The repository responsible for fetching race data.
    private let raceRepository: RaceRepository
    
    init(raceRepository: RaceRepository = RaceRepositoryImpl()) {
        self.raceRepository = raceRepository
        startAutoRefresh()
    }
    
    
    /// A filtered list of races based on the selected race categories, showing a maximum of 5 races.
    var filteredRaces :[RaceSummary]{
        
        if case .success(let races) = raceSummariesViewState {
            return Array(races
                .filter { race in
                    selectedOptions.isEmpty ||
                    selectedOptions.map { $0.description }.contains(race.categoryID)
                }
                .prefix(5))
        }
        else {return []}
        
    }
    
    
    // Cancels the refresh task when the view model is deallocated.
    deinit{
        refreshTask?.cancel() // Cancel the task when ViewModel is deallocated
    }
    
    
    /// Asynchronously fetches race data and updates the view state.
    func fetchRaces() async {
        raceSummariesViewState = .loading(placeholder: nil)
        do{
            let response = try await raceRepository.loadRaces()
            
            if response.isEmpty {
                raceSummariesViewState = .empty
            } else {
                raceSummariesViewState = .success(response:response)
            }
        } catch{
            raceSummariesViewState = .error(error: error)
        }
    }
    
    
    
    // Starts an auto-refresh mechanism that periodically fetches race data every 30 seconds.
    func startAutoRefresh() {
        refreshTask = Task {
            while !Task.isCancelled {
                await fetchRaces()
                try? await Task.sleep(nanoseconds: 30_000_000_000) // Refresh every 30 seconds
            }
        }
    }
    
    
    // Removes an expired race from the list of race summaries.
    /// - Parameter raceId: The ID of the race to be removed.
    func removeExpiredRace(raceId: String) {
        // Ensure this is called on the main thread
        Task { @MainActor in
            if case .success(var races) = raceSummariesViewState {
                races.removeAll { $0.raceID == raceId }
                raceSummariesViewState = .success(response: races)
            }
        }
    }
}
