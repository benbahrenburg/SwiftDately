//
//  SwiftDately.swift
//  SwiftDately
//
//  Created by Ben Bahrenburg (bencoding).
//  Copyright © 2016 Benjamin Bahrenburg. All rights reserved.
//

import Foundation


public extension NSDate {
    
    convenience init?(year : Int, month : Int? = nil, day : Int? = nil,
        hours : Int? = nil, minutes : Int? = nil, seconds : Int? = nil,
        timeZone : NSTimeZone? = nil)
    {
        let tz = timeZone ?? NSTimeZone.localTimeZone()
        let components = NSDate().getComponents(tz)
        components.year = year
        components.month = month ?? components.month
        components.day = day ?? components.day
        components.hour = hours ?? components.hour
        components.minute = minutes ?? components.month
        components.second = seconds ?? components.second
        self.init(timeIntervalSince1970 : (NSCalendar.currentCalendar().dateFromComponents(components)?.timeIntervalSince1970)!)
    }
    
    convenience init?(dateString : String, format : String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        self.init(timeIntervalSince1970 : (dateFormatter.dateFromString(dateString)?.timeIntervalSince1970)!)
    }
    
    private func getCalendar() -> NSCalendar {
        return self.getCalendar(NSTimeZone.localTimeZone())
    }
    
    private func getCalendar(timeZone : NSTimeZone) -> NSCalendar {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = timeZone
        return calendar
    }
    
    private func getComponents() -> NSDateComponents {
        return self.getComponents(NSTimeZone.localTimeZone())
    }
    
    private func getComponents(timeZone : NSTimeZone) -> NSDateComponents {
        return self.getCalendar(timeZone).components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: self)
    }
    
    func get(unit: NSCalendarUnit, inUnit: NSCalendarUnit, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.getCalendar(timeZone).ordinalityOfUnit(unit, inUnit: inUnit, forDate: self)
    }
    
    func set(timeZone timeZone : NSTimeZone? = nil,
        year: Int? = nil, month: Int? = nil, day: Int? = nil,
        hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> NSDate
    {
        let tz = timeZone ?? NSTimeZone.localTimeZone()
        let calendar = self.getCalendar(tz)
        let components = calendar.components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: self)
        components.year = year ?? self.year(tz)
        components.month = month ?? self.month(tz)
        components.day = day ?? self.day(tz)
        components.hour = hour ?? self.hours(tz)
        components.minute = minute ?? self.minutes(tz)
        components.second = second ?? self.seconds(tz)
        return calendar.dateFromComponents(components)!
    }
    
    func day(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return NSCalendar.currentCalendar().componentsInTimeZone(timeZone, fromDate: self).day
    }
    
    func setDay(value : Int, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.set(timeZone:timeZone, day:value)
    }
    
    func year(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return NSCalendar.currentCalendar().componentsInTimeZone(timeZone, fromDate: self).year
    }
    
    func setYear(value : Int, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.set(timeZone:timeZone, year:value)
    }
    
    func month(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.get(.Month, inUnit: .Year, timeZone: timeZone)
    }
    
    func setMonth(value : Int, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.set(timeZone:timeZone, month:value)
    }
    
    func hours(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.get(.Hour, inUnit: .Day, timeZone: timeZone)
    }
    
    func setHours(value : Int, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.set(timeZone:timeZone, hour:value)
    }
    
    func minutes(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.get(.Minute, inUnit: .Hour, timeZone: timeZone)
    }
    
    func setMinutes(value : Int, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.set(timeZone:timeZone, minute:value)
    }
    
    func seconds(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.get(.Second, inUnit: .Minute, timeZone: timeZone)
    }
    
    func setSeconds(value : Int, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.set(timeZone:timeZone, second:value)
    }
    
    func dayInMonth(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int{
        return self.get(.Day, inUnit: .Month, timeZone: timeZone)
    }
    
    func dayOfWeek(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.getCalendar(timeZone).componentsInTimeZone(timeZone, fromDate: self).weekday
    }
    
    func weekOfMonth(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.get(.WeekOfMonth, inUnit: .Month, timeZone: timeZone)
    }
    
    func getWeekOfYear(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.getCalendar(timeZone).componentsInTimeZone(timeZone, fromDate: self).weekOfYear
    }
    
    func dayOfYear(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Int {
        return self.get(.Day, inUnit: .Year, timeZone: timeZone)
    }
    
    func add(unit : NSCalendarUnit, amount : Int) -> NSDate {
        return self.getCalendar().dateByAddingUnit(
            unit, value: amount, toDate: self,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
    func subtract(unit : NSCalendarUnit, amount : Int) -> NSDate {
        return self.add(unit, amount: (amount * -1))
    }
    
    func getTime() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func tomorrow(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        return self.add(.Day, amount: 1).set(timeZone:timeZone, hour:0, minute:0, second:0)
    }
    
    func yesterday(timeZone : NSTimeZone = NSTimeZone.localTimeZone())->NSDate {
        return self.subtract(.Day, amount: 1).set(timeZone:timeZone, hour:0, minute:0, second:0)
    }
    
    func between(toDate : NSDate, units : NSCalendarUnit = [NSCalendarUnit.Day] ) -> NSDateComponents {
        return self.getCalendar().components(units, fromDate: self, toDate: toDate, options: [])
    }
    
    func isSameDay(compareDate: NSDate,timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> Bool {
        let comp1 = self.getCalendar(timeZone).components([.Year, .Month, .Weekday, .Day], fromDate: self)
        let comp2 = self.getCalendar(timeZone).components([.Year, .Month, .Weekday, .Day], fromDate: compareDate)
        return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
    }
    
    public func isGreaterThan(date: NSDate) -> Bool {
        return (self.compare(date) == .OrderedDescending)
    }
    
    public func isLessThan(date: NSDate) -> Bool {
        return (self.compare(date) == .OrderedAscending)
    }
    
    func daysInMonth () -> Int {
        return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self).length
    }
    
    func beginningOfMonth(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        let components = self.getComponents(timeZone)
        components.day = 1
        return self.getCalendar(timeZone).dateFromComponents(components)!
    }
    
    func endOfMonth(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        let components = self.getComponents(timeZone)
        components.month += 1
        components.day = 0
        return self.getCalendar(timeZone).dateFromComponents(components)!
    }
    
    func beginningOfWeek(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        let calendar = self.getCalendar(timeZone)
        let flags :NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday]
        let components = calendar.components(flags, fromDate: self)
        components.weekday = calendar.firstWeekday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components)!
    }
    
    func endOfWeek(timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> NSDate {
        let calendar = self.getCalendar(timeZone)
        let flags :NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday]
        let components = calendar.components(flags, fromDate: self)
        components.weekday = calendar.firstWeekday + 6
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.dateFromComponents(components)!
    }
    
    func formatDate(style : NSDateFormatterStyle, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = style
        formatter.timeZone = timeZone
        return formatter.stringFromDate(self)
    }
    
    func formatTime(style : NSDateFormatterStyle, timeZone : NSTimeZone = NSTimeZone.localTimeZone()) -> String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = style
        formatter.timeZone = timeZone
        return formatter.stringFromDate(self)
    }
    
    func toString(dateStyle dateStyle: NSDateFormatterStyle = .FullStyle, timeStyle: NSDateFormatterStyle = .LongStyle,
        doesRelativeDateFormatting: Bool = false, timeZone : NSTimeZone = NSTimeZone.localTimeZone(),
        locale : NSLocale = NSLocale.currentLocale() ) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.stringFromDate(self)
    }
    
    func toString(formatString : String, timeZone : NSTimeZone = NSTimeZone.localTimeZone(), locale : NSLocale = NSLocale.currentLocale() ) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatString
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.stringFromDate(self)
    }
    
    func dayName() -> String {
        return NSDateFormatter().weekdaySymbols[self.dayOfWeek()-1] as String
    }
    
    func dayAbbreviation() -> String {
        return NSDateFormatter().shortWeekdaySymbols[self.dayOfWeek()-1] as String
    }
    
    func monthName() -> String {
        return NSDateFormatter().monthSymbols[self.month()-1] as String
    }
    
    func monthAbbreviation() -> String {
        return NSDateFormatter().shortMonthSymbols[self.month()-1] as String
    }
    
    func fromNow()->String {
        
        let seconds =   NSDate().timeIntervalSince1970 - self.timeIntervalSince1970
        let isInPast = (seconds > 0 )
        let secs = abs(seconds)
        
        if (secs < 60) {
            return NSLocalizedString("just now", comment: "Show the relative time from a date")
        }
        
        let minutes = round(secs/60)
        
        if minutes == 1 {
            let template =  NSLocalizedString((isInPast ? "1 minute ago" : "in 1 minute"),
                comment: "Show the relative time from a date")
            return String(format: template)
        }
        
        if minutes < 60 {
            let template = NSLocalizedString((isInPast ? "%.f minutes ago" : "in %.f minutes"),
                comment: "Show the relative time from a date")
            return String(format: template, minutes)
        }
        
        let hours = round(minutes/60)
        
        if hours == 1 {
            return NSLocalizedString(((isInPast) ? "1 hour ago" : "in 1 hour"),
                comment: "Show the relative time from a date")
        }
        
        if hours < 24 {
            let template = NSLocalizedString((isInPast ? "%.f hours ago" : "in %.f hours"),
                comment: "Show the relative time from a date")
            return String(format: template, hours)
        }
        
        let days = round(hours/24)
        
        if days == 1 {
            return NSLocalizedString(((isInPast) ? "1 day ago" : "in 1 day"),
                comment: "Show the relative time from a date")
        }
        
        let nowComp = NSCalendar.currentCalendar().components([.WeekOfYear, .Month, .Year],fromDate: NSDate())
        let dateComp = NSCalendar.currentCalendar().components([.WeekOfYear, .Month, .Year],fromDate: self)
        let isSameYear = nowComp.year == dateComp.year
        let weekDiff = abs(nowComp.weekOfYear - dateComp.weekOfYear)
        
        if ((weekDiff == 0) && (isSameYear)) {
            return NSLocalizedString("this week",
                comment: "Show the relative time from a date")
        }
        
        if ((weekDiff == 1) && (isSameYear)) {
            return NSLocalizedString((isInPast ? "last week" : "next week"),
                comment: "Show the relative time from a date")
        }
        
        let monthDiff = abs(nowComp.month - dateComp.month)
        
        if ((monthDiff == 0) && (days <= 31) && (isSameYear)) {
            let template = NSLocalizedString((isInPast ? "%.i days ago": "in %.i days"),
                comment: "Show the relative time from a date")
            return String(format: template, days)
        }
        
        if ((monthDiff == 1) && (isSameYear)) {
            return NSLocalizedString((isInPast ? "last month" : "next month"),
                comment: "Show the relative time from a date")
        }
        
        if ((monthDiff <= 12) && (isSameYear)) {
            let template = NSLocalizedString((isInPast ? "%.f months ago" :"in %.i months"),
                comment: "Show the relative time from a date")
            return String(format: template, monthDiff)
        }
        
        if abs(nowComp.year - dateComp.year) == 1 {
            return NSLocalizedString((isInPast ? "last year" : "in a year"), comment: "Show the relative time from a date")
        }
        
        return NSLocalizedString((isInPast ? "years ago" : "in years"),
            comment: "Show the relative time from a date")
        
    }
    
}

