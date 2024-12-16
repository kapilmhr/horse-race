//
//  extensions.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 14/12/2024.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        guard let uiColor = UIColor(named: hex) else { return nil }
        self.init(uiColor: uiColor)
    }
}

extension Int {

    func formatTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    func formatSecondsToTime() -> String {
        let minutes = self / 60
        let seconds = self % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }

}
