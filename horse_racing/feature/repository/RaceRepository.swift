//
//  RaceService.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import Foundation

protocol RaceRepository {
    func getRaces() async throws-> [RaceSummary]
    
}

final class RaceRepositoryImpl: RaceRepository{
    
    private let networkManager: NetworkManagerImpl!
    
    init(networkManager: NetworkManagerImpl = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    
    func getRaces() async throws -> [RaceSummary] {
        
        let res = try await networkManager.request(session: .shared,
                                                   .racing(method: "nextraces", count:10),
                                                   type:RaceResponse.self)
        
        var raceSummaries = res.data.raceSummaries.map { $0.value }
        
        raceSummaries = raceSummaries.sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
        
        return raceSummaries;
        
    }
}

