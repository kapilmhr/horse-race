//
//  TimerViewModel.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//


import Foundation

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var timerText: String = ""
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
    
    private func startTimer() {
        timerTask = Task {
            while !Task.isCancelled {
                updateTimer()
                try? await Task.sleep(nanoseconds: 1_000_000_000) // Update every second
            }
        }
    }
    
    private func updateTimer() {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let timeRemaining = max(advertisedStart - currentTimestamp, 0)
        let elapsedTime = max(currentTimestamp - advertisedStart, 0)
        
        DispatchQueue.main.async{
            if timeRemaining > 0 {
                self.timerText = timeRemaining.formatSecondsToTime() // Countdown
            } else if elapsedTime < 60 {
                self.timerText = "-\(elapsedTime) s" // Elapsed time
            } else {
                self.timerText = "-"
                self.onExpired?() // Notify the parent view model that the race is expired
            }
        }
        
    }
}
