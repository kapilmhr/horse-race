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
    
    @Published var selectedOptions: Set<RaceCategory> = []
    
    
    private var refreshTask: Task<Void, Never>?
    
    private let raceRepository: RaceRepository
    
    
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
    
    
    init(raceRepository: RaceRepository) {
        self.raceRepository = raceRepository
        startAutoRefresh()
    }
    
    deinit{
        refreshTask?.cancel() // Cancel the task when ViewModel is deallocated
        
    }
    
    func fetchRaces() async {
        raceSummariesViewState = .loading(placeholder: nil)
        do{
            let response = try await raceRepository.getRaces()
            raceSummariesViewState = .success(response:response)
        } catch{
            raceSummariesViewState = .error(error: error)
        }
    }
    
    
    
    // Set up an auto-refreshing mechanism using a Task
    func startAutoRefresh() {
        refreshTask = Task {
            while !Task.isCancelled {
                await fetchRaces()
                try? await Task.sleep(nanoseconds: 30_000_000_000) // Refresh every 30 seconds
            }
        }
    }
    
    
    // Removes expired race from the list
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
