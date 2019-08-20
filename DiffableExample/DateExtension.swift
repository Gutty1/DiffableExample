//
//  DateExtension.swift
//  GitHubRepos
//
//  Created by Arie Guttman on 29/08/2017.
//  Copyright © 2017 Arie Guttman. All rights reserved.
//

import Foundation


extension Date {
    ///return Date string in format "yyyy-MM-dd" - E.g.: 2017-05-18
    var asQueryDate: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: self)
        }
    }
    
    ///Adds number of days to current date
    func addDays(days:Int) -> Date {
        if days == 0 {
            return self
        }
        let dayValue:Double = 24*60*60.0
        return self.addingTimeInterval(Double(days) * dayValue)
    }
    
    ///Adds number of months to current date based on Gregorian calendar and in GMT timezone
    func addMonths(months:Int) -> Date {
        if months == 0 {
            return self
        }
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months
        return calendar.date(byAdding: components, to: self)!
    }
    
}
