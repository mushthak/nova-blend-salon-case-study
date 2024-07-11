//
//  TimeFormatter.swift
//  NovaBlendSalonView
//
//  Created by Mushthak Ebrahim on 11/07/24.
//

import Foundation

public enum TimeFormatter {
    public static func convertTo12HourFormat(from time24: Float) -> String? {
        // Extract hours and minutes from the Float value
        let hours = Int(time24)
        let minutes = Int((time24 - Float(hours)) * 100) // Capture the decimal part as minutes
        
        // Format the hours and minutes into a 24-hour time string
        let time24String = String(format: "%02d:%02d", hours, minutes)
        
        let dateFormatter = DateFormatter()
        
        // Set the input format to 24-hour time
        dateFormatter.dateFormat = "HH:mm"
        
        // Convert the input string to a Date object
        guard let date = dateFormatter.date(from: time24String) else {
            return nil
        }
        
        // Set the output format to 12-hour time with AM/PM
        dateFormatter.dateFormat = "h:mm a"
        
        // Convert the Date object back to a string in 12-hour format
        let time12 = dateFormatter.string(from: date)
        
        return time12
    }
}
