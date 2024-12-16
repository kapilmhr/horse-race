//
//  RaceViewModelFilteringTests.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 16/12/2024.
//

import XCTest
@testable import horse_racing

@MainActor
final class RaceViewModelFilteringTests: XCTestCase {
    private var mockRepository: MockRaceRepository!
    private var viewModel: RaceViewModelImpl!

    override func setUp() {
        super.setUp()
        mockRepository = MockRaceRepository()
        viewModel = RaceViewModelImpl(raceRepository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    // When no categories are selected, the filtered races should return all races.
    func testFilteredRaces_NoSelectedOptions_ReturnsAll() async {
        // Arrange
        mockRepository.mockRaceSummaries = [mockRaceSummary]
        await viewModel.fetchRaces()

        // Act
        viewModel.selectedOptions = []

        // Assert
        XCTAssertEqual(viewModel.filteredRaces.count, 1)
    }

    func testFilteredRaces_SelectedOptions_MatchesCategory() async {
        // Arrange
        let mockCategoryID = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
        let mockCategoryID2 = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
        // Mock data for RaceSummary
        let mockRace1 = RaceSummary(
            raceID: "race1",
            raceName: "HorseRace 1",
            raceNumber: 1,
            meetingID: "meeting1",
            meetingName: "Morning Meeting",
            categoryID: mockCategoryID,
            advertisedStart: mockAdvertisedStart,
            raceForm: mockRaceForm,
            venueID: "venue1",
            venueName: "Famous Arena",
            venueState: "NSW",
            venueCountry: "Australia"
        )
        let mockRace2 = RaceSummary(
            raceID: "race2",
            raceName: "HorseRace 2",
            raceNumber: 1,
            meetingID: "meeting1",
            meetingName: "Morning Meeting",
            categoryID: mockCategoryID2,
            advertisedStart: mockAdvertisedStart,
            raceForm: mockRaceForm,
            venueID: "venue1",
            venueName: "Famous Arena",
            venueState: "NSW",
            venueCountry: "Australia"
        )

        // Mock repository to return the mock races
        mockRepository.mockRaceSummaries = [mockRace1, mockRace2]

        // Act
        await viewModel.fetchRaces()

        // Set selected options
        viewModel.selectedOptions = [
            RaceCategory.horse,
            RaceCategory.greyhound
        ]
        // Debug: Print out the selected options and race category IDs to verify matching
        print("Filtered Races Count: \(viewModel.filteredRaces.count)")
        viewModel.filteredRaces.forEach {
            print("Filtered Race ID: \($0.raceID), Category ID: \($0.categoryID)")
        }
        // Assert
        XCTAssertEqual(viewModel.filteredRaces.count, 2)
    }
}
