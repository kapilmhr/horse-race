//
//  RaceCategory.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


enum RaceCategory: String, CaseIterable, Identifiable {
    case horse = "Horse"
    case harness = "Harness"
    case greyhound = "Greyhound"
    
    var id: String { self.rawValue }
    
    // Provide a localized description if needed
        var description: String {
            switch self {
            case .horse:
                return "4a2788f8-e825-4d36-9894-efd4baf1cfae"
            case .harness:
                return "161d9be2-e909-4326-8c2c-35ed71fb460b"
            case .greyhound:
                return "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
            }
        }
}
