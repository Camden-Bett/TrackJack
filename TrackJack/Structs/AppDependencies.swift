//
//  AppDependencies.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/11/25.
//

import Foundation

// central registry for app dependencies
struct AppDependencies {
    var friendStore: FriendStore
    var dateService: DateService
}

// abstract date logic (daily UTC rollover)
protocol DateService {
    func utcDayKey(now: Date) -> String
}

struct DefaultDateService: DateService {
    private let calendar = Calendar(identifier: .gregorian)
    
    func utcDayKey(now: Date) -> String {
        var cal = calendar
        cal.timeZone = TimeZone(secondsFromGMT: 0)! // force UTC
        let comps = cal.dateComponents([.year, .month, .day], from: now)
        return String(format: "%04d%02d%02d", comps.year!, comps.month!, comps.day!)
    }
}
