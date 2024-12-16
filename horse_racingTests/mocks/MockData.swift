//
//  MockStub.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//

import Foundation
@testable import horse_racing

// Mock data for AdvertisedStart
let mockAdvertisedStart = AdvertisedStart(seconds: 100000)

// Mock data for InfoType (used in RaceForm)
let mockTrackCondition = InfoType(id: "1", name: "Good", shortName: "Good", iconURI: nil)
let mockWeather = InfoType(id: "2", name: "Clear", shortName: "Clear", iconURI: nil)

// Mock data for RaceForm
let mockRaceForm = RaceForm(
    distance: 1600,
    distanceType: mockTrackCondition,
    distanceTypeID: "1",
    trackCondition: mockTrackCondition,
    trackConditionID: "1",
    weather: mockWeather,
    weatherID: "2",
    raceComment: "Fast-paced race",
    additionalData: "Extra data",
    generated: 123456,
    silkBaseURL: "https://example.com/silk",
    raceCommentAlternative: "Alternative race comment"
)

// Mock data for RaceSummary
let mockRaceSummary = RaceSummary(
    raceID: "race1",
    raceName: "Grand Prix",
    raceNumber: 1,
    meetingID: "meeting1",
    meetingName: "Morning Meeting",
    categoryID: "4a2788f8-e825-4d36-9894-efd4baf1cfae",
    advertisedStart: mockAdvertisedStart,
    raceForm: mockRaceForm,
    venueID: "venue1",
    venueName: "Famous Arena",
    venueState: "NSW",
    venueCountry: "Australia"
)

let mockRaceSummaries: [String: RaceSummary] = [
    "race1": mockRaceSummary
]

// Mock data for the RaceResponse
let mockRaceResponse = RaceResponse(
    status: 200,
    data: DataClass(nextToGoIDS: ["1", "2", "3"], raceSummaries: mockRaceSummaries),
    message: "Success"
)
