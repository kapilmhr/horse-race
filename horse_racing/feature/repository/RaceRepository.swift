//
//  RaceService.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import Foundation

/// A protocol defining the functionality of a repository that loads race data.
protocol RaceRepository {

    /// Asynchronously loads a list of race summaries.
    /// - Returns: An array of `RaceSummary` objects.
    /// - Throws: An error if the race data cannot be loaded.
    func loadRaces() async throws -> [RaceSummary]

}

final class RaceRepositoryImpl: RaceRepository {

    private let raceService: RaceService

    init(raceService: RaceService = RaceServiceImpl() ) {
        self.raceService = raceService
    }

    func loadRaces() async throws -> [RaceSummary] {

        // Delegates the call to the RaceService to fetch the race data.
        return try await raceService.getRaces()

    }
}
