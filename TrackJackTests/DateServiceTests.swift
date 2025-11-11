//
//  DateServiceTests.swift
//  TrackJackTests
//
//  Created by Camden Bettencourt on 11/11/25.
//

import XCTest
@testable import TrackJack

final class DateServiceTests: XCTestCase {
    func testUtcDayKeyAroundBoundaries() {
        let svc = DefaultDateService()
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)! // UTC

        // 2025-11-11 00:05 UTC → "20251111"
        let d1 = cal.date(from: DateComponents(year: 2025, month: 11, day: 11, hour: 0, minute: 5))!
        XCTAssertEqual(svc.utcDayKey(now: d1), "20251111")

        // 2025-11-10 23:59 UTC → "20251110"
        let d2 = cal.date(from: DateComponents(year: 2025, month: 11, day: 10, hour: 23, minute: 59))!
        XCTAssertEqual(svc.utcDayKey(now: d2), "20251110")
    }
}
