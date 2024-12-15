//
//  MockRaceRepository.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//

import XCTest
@testable import horse_racing

final class MockRaceRepository: RaceRepository {
    var shouldThrowError = false
    var mockRaceSummaries: [RaceSummary] = []
    
    func getRaces() async throws -> [RaceSummary] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 0, userInfo: nil)
        }
        return mockRaceSummaries
    }
}
