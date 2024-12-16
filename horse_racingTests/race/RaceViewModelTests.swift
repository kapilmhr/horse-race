//
//  RaceViewModelTests.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//

import XCTest
@testable import horse_racing

@MainActor
final class RaceViewModelTests: XCTestCase {
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

    func testFetchRaces_SuccessfulResponse() async {
        // Arrange
        let mockRaces = [mockRaceSummary]
        mockRepository.mockRaceSummaries = mockRaces

        // Act
        await viewModel.fetchRaces()

        // Assert the success state
        switch viewModel.raceSummariesViewState {
        case .success(let races):
            XCTAssertEqual(races.count, 1)
            XCTAssertEqual(races.first?.raceID, "race1")
        case .error:
            XCTFail("Expected success but got error")
        case .loading:
            XCTFail("Expected success but got loading state")
        case .ideal:
            XCTFail("Expected success but got ideal state")
        case .empty:
            XCTFail("Expected success but got empty state")
        }
    }

    func testFetchRaces_ErrorResponse() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act
        await viewModel.fetchRaces()

        // Assert
        // Assert the error state
        switch viewModel.raceSummariesViewState {
        case .error:
            XCTAssertTrue(true) // Expected error case
        case .success:
            XCTFail("Expected error but got success")
        case .loading:
            XCTFail("Expected error but got loading state")
        case .ideal:
            XCTFail("Expected error but got ideal state")
        case .empty:
            XCTFail("Expected error but got empty state")
        }
    }

    func testEmptyRaces_ReturnsEmptyState() async {
        // Arrange
        mockRepository.mockRaceSummaries = []

        // Act
        await viewModel.fetchRaces()

        // Assert
        switch viewModel.raceSummariesViewState {
        case .empty:
            XCTAssertTrue(true) // Expected empty state
        default:
            XCTFail("Expected empty state but got \(viewModel.raceSummariesViewState)")
        }
    }

}
