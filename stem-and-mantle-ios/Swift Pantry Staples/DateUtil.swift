//
//  DateUtil.swift
//
//  Created by Rob Busack on 7/22/2020.
//

import Foundation

///////////////////////////////////////////////////////////////////////////////////////////////////
// this "class" just exists to create the DateUtil namespace, everything within it is static
class DateUtil {
    
    static let SECONDS_PER_MINUTE = 60
    static let MINUTES_PER_HOUR = 60
    static let HOURS_PER_DAY = 24   // roughly.  Damn Daylight Savings Time sometimes causes 23 and 25 hour days.
    
    // these are in seconds:
    static let ONE_MINUTE = TimeInterval(DateUtil.SECONDS_PER_MINUTE)
    static let ONE_HOUR = TimeInterval(DateUtil.SECONDS_PER_MINUTE * DateUtil.MINUTES_PER_HOUR)
    static let ONE_DAY = TimeInterval(DateUtil.SECONDS_PER_MINUTE * DateUtil.MINUTES_PER_HOUR * DateUtil.HOURS_PER_DAY)
    
    
    ///////////////////////////
    // MARK: Date Formatting //
    ///////////////////////////
    
    static let UTC_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let DAY_STRING_FORMAT = "yyyy-MM-dd"
    
    static let LOG_FILE_TIMESTAMP_FORMAT = "yyyy-MM-dd HH:mm:ss.SSS"
    
    static let utcDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = DateUtil.UTC_DATE_FORMAT
        return dateFormatter
    }()
    
    static let dayStringFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = DateUtil.DAY_STRING_FORMAT
        //dateFormatter.timeZone = // intentionally not set, we want it to default to the same as this device is using
        return dateFormatter
    }()
    
    static let debugDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d, yyyy h:mm:ss a Z"
        return dateFormatter
    }()
    
    static let userFriendlyDateAndTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        // intentionally not setting local timezone or locale, so that the phone defaults are used
        dateFormatter.dateFormat = "MMMM d, h:mma"
        return dateFormatter
    }()
    
    static let userFriendlyTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        // intentionally not setting local timezone or locale, so that the phone defaults are used
        //dateFormatter.dateFormat = "h:mma"
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    static let userFriendlyDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        // intentionally not setting local timezone or locale, so that the phone defaults are used
        //dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter
    }()
    
    static let logFileDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateUtil.LOG_FILE_TIMESTAMP_FORMAT
        return dateFormatter
    }()
    
    static func dateFromUtcString(_ input: String) -> Date? {
        return utcDateFormatter.date(from: input)
    }
    
    static func utcStringFromDate(_ input: Date) -> String {
        return utcDateFormatter.string(from: input)
    }
    
    static func dayOnly(fromUtcDateString utcDateString: String) -> String {
        if let index = utcDateString.lastIndex(of: "T") {
            let dayOnlyString = utcDateString.prefix(upTo: index)
            return String(dayOnlyString)
        } else {
            return "ERROR"
        }
    }
    
    static func dayStringLocalTime(from date: Date) -> String {
        return DateUtil.dayStringFormatter.string(from: date)
    }
    
    static func localDateFromDayString(_ dayString: String) -> Date? {
        return DateUtil.dayStringFormatter.date(from: dayString)
    }
    
    static func userFriendlyTime(from d: Date) -> String {
        return DateUtil.userFriendlyTime.string(from: d).lowercased()
    }
    
    static func userFriendlyDateAndTime(from d: Date) -> String {
        var retVal = DateUtil.userFriendlyDateAndTime.string(from: d)
        retVal = retVal.replacingOccurrences(of: "AM", with: "am")
        retVal = retVal.replacingOccurrences(of: "PM", with: "pm")
        return retVal
    }
    
    static func userFriendlyDay(from d: Date) -> String {
        return DateUtil.userFriendlyDay.string(from: d)
    }
    
    static func timestampForLogFile(using now: Date = Date()) -> String {
        return DateUtil.logFileDateFormatter.string(from: now)
    }
    
    
    ///////////////////////////////
    // MARK: Date-Math Utilities //
    ///////////////////////////////
    
    static func differenceInMinutes(older: Date, newer: Date) -> Double {
        let differenceInSeconds = newer.timeIntervalSince(older)
        return Double(differenceInSeconds) / Double(SECONDS_PER_MINUTE)
    }
    
    /// Returns a date that is precicely on the hour, by removing minutes, seconds, etc.
    /// For example, 3:52pm becomes 3:00pm
    static func dateHourFloor(_ input : Date) -> Date {
        let newDate1 = Calendar.current.date(bySetting: .minute, value: 0, of:input)
        let newDate2 = Calendar.current.date(bySetting: .second, value: 0, of: newDate1!)
        let newDate3 = Calendar.current.date(bySetting: .nanosecond, value: 0, of: newDate2!)
        
        let oneHourInSeconds:Double = 60*60
        let newDate4 = newDate3!.addingTimeInterval(-1.0 * oneHourInSeconds)
        
        return newDate4
    }
    
    static func dateMidnightFloorLocalTimezone(_ input: Date) -> Date {
        let cal = Calendar(identifier: .gregorian)
        let newDate = cal.startOfDay(for: input)    // this seems to automatically take our local timezone into account, that's cool, I'm thankful for that
        
        return newDate
    }
    
    static func dateMidnightCeilingLocalTimezone(_ input: Date) -> Date {
        // are we already on midnight?
        if (input == DateUtil.dateMidnightFloorLocalTimezone(input)) {
            return input
        }
        
        // tomorrow's midnight (aka tomorrow's start time) is the midnight that comes AFTER our input date.
        let oneDay = DateComponents(day:1)
        let tomorrow = Calendar.current.date(byAdding: oneDay, to: input)!
        return DateUtil.dateMidnightFloorLocalTimezone(tomorrow)
    }
    
    static func nextMidnightAfter(_ input: Date) -> Date {
        let midnightBeforeOrEqual = DateUtil.dateMidnightFloorLocalTimezone(input)
        
        let oneDay = DateComponents(day:1)
        let nextMidnight = Calendar.current.date(byAdding: oneDay, to: midnightBeforeOrEqual)!
        return nextMidnight
    }
    
    static func min(_ d1: Date, _ d2: Date?) -> Date {
        guard let d2 = d2 else { return d1 }
        if d1.isBefore(d2) {
            return d1
        } else {
            return d2
        }
    }
    
    static func max(_ d1: Date, _ d2: Date?) -> Date {
        guard let d2 = d2 else { return d1 }
        if d1.isAfter(d2) {
            return d1
        } else {
            return d2
        }
    }
    
    static func getStringFor(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
