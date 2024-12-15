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
            // Error case is expected
            break
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
    
    
    // When no categories are selected, the filtered races should return all races.
    func testFilteredRaces_EmptySelectedOptions() async {
        // Arrange
        mockRepository.mockRaceSummaries = [mockRaceSummary]
        await viewModel.fetchRaces()
        
        // Act
        viewModel.selectedOptions = []
        
        // Assert
        XCTAssertEqual(viewModel.filteredRaces.count, 1)
    }
    

    
    func testFilteredRaces_SelectedOptions() async {
        // Arrange
        let mockCategoryID = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
        let mockCategoryID2 = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
        // Mock data for RaceSummary
        let mockRace1 = RaceSummary(
            raceID: "race1",
            raceName: "Grand Prix",
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
            raceName: "Grand Prix",
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
        viewModel.selectedOptions = [RaceCategory.horse, RaceCategory.greyhound]  // Assuming RaceCategory.horse.description = "horse"
        // Debug: Print out the selected options and race category IDs to verify matching
        print("Filtered Races Count: \(viewModel.filteredRaces.count)")
        viewModel.filteredRaces.forEach {
            print("Filtered Race ID: \($0.raceID), Category ID: \($0.categoryID)")
        }
        // Assert
        XCTAssertEqual(viewModel.filteredRaces.count, 2)
    }
    
    
    func testRemoveExpiredRace() async {
        
        let mockRace1 = RaceSummary(
            raceID: "race1",
            raceName: "Grand Prix",
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
         print("Races after fetch: \(viewModel.filteredRaces.count)") // Debugging log
         
        // Assert: Ensure races were fetched correctly
         XCTAssertEqual(viewModel.filteredRaces.count, 1, "Expected 1 race to be fetched.")
         
         // Call the method to remove expired race
         viewModel.removeExpiredRace(raceId: "race1")
        // Wait for async tasks to complete
        // Wait for async tasks to complete
           do {
               try await Task.sleep(nanoseconds: 100_000_000) // Wait a bit to ensure async tasks complete
           } catch {
               XCTFail("Task.sleep failed with error: \(error)")
           }
        
         print("Races after removal: \(viewModel.filteredRaces.count)") // Debugging log

         // Assert
         XCTAssertEqual(viewModel.filteredRaces.count, 0)  // Expect no races in the filtered list


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
