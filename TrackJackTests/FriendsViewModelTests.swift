//
//  FriendsViewModelTests.swift
//  TrackJackTests
//
//  Created by Camden Bettencourt on 11/11/25.
//

import XCTest
@testable import TrackJack

// A controllable fake (no sleeps, no randomness)
@MainActor
final class FakeFriendStore: FriendStore {
    var storage: [String: Friend] = [:]
    var nextError: Error?

    func list() async throws -> [Friend] {
        if let e = nextError { defer { nextError = nil }; throw e }
        return storage.values.sorted { $0.id < $1.id }
    }

    func add(username: String) async throws -> Friend {
        if let e = nextError { defer { nextError = nil }; throw e }
        guard UsernameValidation.isValid(username) else { throw FriendError.invalidUsername }
        let key = username.lowercased()
        guard storage[key] == nil else { throw FriendError.alreadyFriends }
        let f = Friend(username: username)
        storage[key] = f
        return f
    }

    func remove(id: String) async throws {
        if let e = nextError { defer { nextError = nil }; throw e }
        guard storage.removeValue(forKey: id.lowercased()) != nil else { throw FriendError.notFound }
    }
}

@MainActor
final class FriendsViewModelTests: XCTestCase {

    func testLoadListsFriends() async {
        let store = FakeFriendStore()
        store.storage = ["tj": Friend(username: "TJ"), "jackdaw": Friend(username: "jackdaw")]
        let vm = FriendsViewModel(store: store)

        vm.load()
        // give the Task a tick
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(vm.friends.map(\.id), ["jackdaw","tj"])
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.error)
    }

    func testAddFriendSuccess() async {
        let store = FakeFriendStore()
        let vm = FriendsViewModel(store: store)

        vm.add(username: "rook_9")
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(vm.friends.map(\.id), ["rook_9"])
        XCTAssertNil(vm.error)
    }

    func testAddFriendDuplicateSetsError() async {
        let store = FakeFriendStore()
        store.storage["rook_9"] = Friend(username: "rook_9")
        let vm = FriendsViewModel(store: store)
        
        vm.load() // duplicate by canon id
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        vm.add(username: "ROOK_9") // duplicate by canon id
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertFalse(vm.friends.isEmpty) // still has the original
        XCTAssertEqual(vm.error, FriendError.alreadyFriends.localizedDescription)
    }

    func testRemoveFriend() async {
        let store = FakeFriendStore()
        store.storage["tj"] = Friend(username: "TJ")
        let vm = FriendsViewModel(store: store)

        vm.load()
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertEqual(vm.friends.count, 1)

        vm.remove(_friend: Friend(username: "TJ"))
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertTrue(vm.friends.isEmpty)
    }
}
