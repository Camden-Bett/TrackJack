//
//  FriendsViewModel.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

import Foundation
import Observation

@MainActor
final class FriendsViewModel: ObservableObject {
    @Published private(set) var friends: [Friend] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let store: FriendStore
    init(store: FriendStore) { self.store = store }
    
    func load() {
        Task {
            isLoading = true; defer { isLoading = false }
            do { friends = try await store.list() }
            catch { self.error = error.localizedDescription }
        }
    }
    
    func add(username: String) {
        Task {
            do {
                _ = try await store.add(username: username)
                friends = try await store.list()
            } catch { self.error = error.localizedDescription }
        }
    }
    
    func remove(_friend: Friend) {
        Task {
            do {
                try await store.remove(id: _friend.id)
                friends = try await store.list()
            } catch { self.error = error.localizedDescription }
        }
    }
}
