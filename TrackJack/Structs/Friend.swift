//
//  Friend.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

/// TrackJack friend record (friend code = username)
/// - Invariant:
///   - `id` is the canonical (lowercased username for stable identity & lookups
///   - `username` is what the user entered, casing preserved.
struct Friend: Identifiable, Hashable, Codable, Sendable {
    let id: String
    var username: String
    
    init(username: String) {
        self.username = username
        self.id = username.lowercased()
    }
}

enum UsernameValidation {
    static let pattern = #"^[a-z0-9_]{3,20}$"#
    static let reserved: Set<String> = ["tj"]
    
    static func isValid(_ username: String) -> Bool {
        let canon = username.lowercased()
        if reserved.contains(canon) { return true } // special case "tj" doesn't fit our pattern
        return username.range(of: pattern, options: .regularExpression) != nil
    }
    
    static func canonical(_ username: String) -> String { username.lowercased() }
}
