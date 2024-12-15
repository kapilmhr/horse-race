//
//  RaceService.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 13/12/2024.
//

import Foundation
import Combine

protocol RaceService {
    func getRaces() async throws-> [RaceSummary]
    
}

final class RaceServiceImpl: RaceService{
  
    
    func getRaces() async throws -> [RaceSummary] {
        
        let res = try await NetworkManager.shared.request(.racing,type:RaceResponse.self)
        var raceSummaries = res.data.raceSummaries.map { $0.value }
        raceSummaries = raceSummaries.sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
        
        return raceSummaries;

    }
    
    func getRacesOld() async throws -> [RaceSummary] {
        let (data,_) = try await URLSession.shared.data(from: URL(string:ApiConstant.baseUrl)!)
        let decoder = JSONDecoder()
        let response = try decoder.decode(RaceResponse.self, from: data)
        var raceSummaries = response.data.raceSummaries.map { $0.value }
        raceSummaries = raceSummaries.sorted { $0.advertisedStart.seconds < $1.advertisedStart.seconds }
        
        return raceSummaries;

    }
    
    //Combine
    func fetchResponse() -> AnyPublisher<RaceResponse, Error> {
        guard let url = URL(string: ApiConstant.baseUrl) else {
               return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
           }

        return URLSession.shared.dataTaskPublisher(for: url)
               .map(\.data)
               .decode(type: RaceResponse.self, decoder: JSONDecoder())
               .eraseToAnyPublisher()
       }
}

