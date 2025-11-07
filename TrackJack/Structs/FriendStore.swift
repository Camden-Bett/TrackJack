//
//  FriendStore.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//
//  gettin' friends at the friend store

import Foundation

protocol FriendStore: Sendable {
    func list() async throws -> [Friend]
    func add(username: String) async throws -> Friend
    func remove(id: String) async throws
}

enum FriendError: LocalizedError {
    case invalidUsername
    case alreadyFriends
    case notFound
    var errorDescription: String? {
        switch self {
        case .invalidUsername: return "Usernames are 3-20 characters. Only letters, numbers, and underscore."
        case .alreadyFriends: return "You already follow this user."
        case .notFound: return "User not found."
        }
    }
}

@MainActor
final class MockFriendStore: FriendStore {
    private var friendsById: [String: Friend] = [
        "tj": Friend(username: "TJ"),
        "jackdaw": Friend(username: "jackdaw")
    ]
    
    func list() async throws -> [Friend] {
        friendsById.values.sorted { $0.id < $1.id }
    }
    
    func add(username: String) async throws -> Friend {
        guard UsernameValidation.isValid(username) else { throw FriendError.invalidUsername }
        let key = UsernameValidation.canonical(username)
        guard friendsById[key] == nil else { throw FriendError.alreadyFriends }
        let f = Friend(username: username)
        friendsById[key] = f
        return f
    }
    
    func remove(id: String) async throws {
        let key = UsernameValidation.canonical(id)
        guard friendsById.removeValue(forKey: key) != nil else { throw FriendError.notFound }
    }
}
