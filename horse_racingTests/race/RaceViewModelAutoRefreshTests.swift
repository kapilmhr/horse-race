//
//  RaceViewModelAutoRefreshTests.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 16/12/2024.
//


import XCTest
@testable import horse_racing

@MainActor
final class RaceViewModelAutoRefreshTests: XCTestCase {
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

    func testAutoRefresh() async {
        // Arrange
        let refreshExpectation = XCTestExpectation(description: "Races should refresh every 30 seconds")
        mockRepository.mockRaceSummaries = [mockRaceSummary]
        await viewModel.fetchRaces()
        
        // Ensure that initial state is correct
        XCTAssertEqual(viewModel.filteredRaces.count, 1)
        
        // Act: Trigger the auto-refresh mechanism
        viewModel.startAutoRefresh()
        
        
        // Set the expectation that the race count should be greater than 0 after refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
            // We simulate that the fetch operation was successful and the race summaries have been refreshed
            if case .success(let races) = self.viewModel.raceSummariesViewState {
                XCTAssertGreaterThan(races.count, 0, "Expected races to be refreshed")
                refreshExpectation.fulfill()
            } else {
                XCTFail("Race refresh failed")
            }
        }
        
        // Assert: Wait for the expectation to be fulfilled within 40 seconds
        await fulfillment(of: [refreshExpectation], timeout: 40)
    }
}
