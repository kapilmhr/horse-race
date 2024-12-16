//
//  RaceViewModelErrorHandlingTests.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 16/12/2024.
//

import XCTest
@testable import horse_racing

@MainActor
final class RaceViewModelErrorHandlingTests: XCTestCase {
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

    func testRemoveExpiredRace() async {

        let mockRace1 = RaceSummary(
            raceID: "race1",
            raceName: "HorseRace",
            raceNumber: 1,
            meetingID: "meeting1",
            meetingName: "Morning Meeting",
            categoryID: RaceCategory.horse.description,
            advertisedStart: mockAdvertisedStart,
            raceForm: mockRaceForm,
            venueID: "venue1",
            venueName: "Famous Arena",
            venueState: "NSW",
            venueCountry: "Australia"
        )

        // Mock repository to return the mock races
        mockRepository.mockRaceSummaries = [mockRace1]

        // Act
        await viewModel.fetchRaces()  // Load races
        //  print("Races after fetch: \(viewModel.filteredRaces.count)") // Debugging log

        // Assert: Ensure races were fetched correctly
        XCTAssertEqual(viewModel.filteredRaces.count, 1, "Expected 1 race to be fetched.")

        // Call the method to remove expired race
        viewModel.removeExpiredRace(raceId: "race1")
        // Wait for async tasks to complete
        do {
            try await Task.sleep(nanoseconds: 100_000_000) // Wait a bit to ensure async tasks complete
        } catch {
            XCTFail("Task.sleep failed with error: \(error)")
        }

        //         print("Races after removal: \(viewModel.filteredRaces.count)") // Debugging log

        // Assert
        XCTAssertEqual(viewModel.filteredRaces.count, 0)  // Expect no races in the filtered list

    }
}
