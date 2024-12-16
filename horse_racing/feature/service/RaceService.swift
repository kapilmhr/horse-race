//
//  RaceService.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 16/12/2024.
//

import Foundation

/// A protocol defining the functionality of a service that fetches race data.
protocol RaceService {

    /// Fetches a list of race summaries asynchronously.
    /// - Returns: An array of `RaceSummary` objects.
    /// - Throws: An error if the network request fails or if data parsing fails.

    func getRaces() async throws -> [RaceSummary]

}

public final class RaceServiceImpl: RaceService {

    /// A reference to the network manager used for making API requests.
    private let networkManager: NetworkManagerImpl!

    init(networkManager: NetworkManagerImpl = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    /// Fetches race data from the network and returns a sorted array of race summaries.
    /// - Returns: A sorted array of `RaceSummary` objects.
    /// - Throws: An error if the network request fails or if data parsing fails.

    func getRaces() async throws -> [RaceSummary] {
        let res = try await networkManager.request(session: .shared,
                                                   .racing(method: "nextraces", count: 10),
                                                   type: RaceResponse.self)

        var raceSummaries = res.data.raceSummaries.map { $0.value }

        // Sort the race summaries by the advertised start time (ascending).
        raceSummaries = raceSummaries.sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }

        return raceSummaries
    }
}
