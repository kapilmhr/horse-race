//
//  MockRaceService.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 16/12/2024.
//
import XCTest
@testable import horse_racing

final class MockRaceService: RaceService {
    init(){}
    public var stubRaceResponse: Result<[RaceSummary], Error>?
    
    public var didGeRaces: (() -> Void)?
    
    public var getRacesCallCount: Int = 0


    func getRaces() async throws -> [horse_racing.RaceSummary] {
        defer {didGeRaces?()}
        
        getRacesCallCount += 1
        
        return try stubRaceResponse!.get()
    }
    
    
}
