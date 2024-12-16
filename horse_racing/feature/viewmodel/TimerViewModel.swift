//
//  TimerViewModel.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


import Foundation

/// A view model that handles a countdown timer for a race, updating the time remaining or elapsed.
@MainActor
final class TimerViewModel: ObservableObject {
    @Published var timerText: String = ""
    
    /// A closure that is called when the timer expires.
    var onExpired: (() -> Void)?
    
    private var timerTask: Task<Void, Never>?
    private let advertisedStart: Int
    
    init(advertisedStart: Int, onExpired: (() -> Void)? = nil) {
        self.advertisedStart = advertisedStart
        self.onExpired = onExpired
        startTimer()
    }
    
    deinit {
        timerTask?.cancel()
    }
    
    /// Starts a background task to update the timer every second.
    private func startTimer() {
        timerTask = Task {
            while !Task.isCancelled {
                updateTimer()
                try? await Task.sleep(nanoseconds: 1_000_000_000) // Update every second
            }
        }
    }
    
    /// Updates the timer's text by calculating the remaining or elapsed time.
    private func updateTimer() {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let timeRemaining = max(advertisedStart - currentTimestamp, 0)
        let elapsedTime = max(currentTimestamp - advertisedStart, 0)
        
        // Update the UI on the main thread
        DispatchQueue.main.async{
            if timeRemaining > 0 {
                self.timerText = timeRemaining.formatSecondsToTime() // Countdown
            } else if elapsedTime < 60 {
                self.timerText = "-\(elapsedTime) s" // Elapsed time
            } else {
                self.timerText = "-"
                
                // Call the onExpired closure to notify that the race has expired
                self.onExpired?()
            }
        }
        
    }
}
