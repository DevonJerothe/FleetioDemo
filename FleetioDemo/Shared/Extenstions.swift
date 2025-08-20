//
//  Extenstions.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/20/25.
//

import Foundation

extension String {
    /// Converts the string (assumed ISO8601 date) to a formatted date string, or returns self if parsing fails.
    func toDateString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        guard let date = inputFormatter.date(from: self) else {
            return self
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = dateStyle
        outputFormatter.timeStyle = timeStyle
        return outputFormatter.string(from: date)
    }
}
