//
//  DateExtension.swift
//  Twitter
//
//  Created by Richard Hsu on 2020/2/10.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation

// Code obtained from: https://stackoverflow.com/questions/34457434/swift-convert-time-to-time-ago
extension Date {
    func getElapsedInterval() -> String {

        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return "\(year)" + "y"
        } else if let month = interval.month, month > 0 {
            return "\(month)" + "mo"
        } else if let day = interval.day, day > 0 {
            return "\(day)" + "d"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)" + "h"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)" + "m"
        } else if let second = interval.second, second > 0 {
            return "\(second)" + "s"
        } else {
            return "a moment ago"
        }

    }
}
