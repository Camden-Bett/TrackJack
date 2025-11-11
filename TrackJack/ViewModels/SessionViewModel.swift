//
//  SessionViewModel.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/11/25.
//

import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    // public session to bind to UI
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var username: String?
    @Published var error: String?
    
    // TODO: add authservice/keychain later
    private let dateService: DateService
    
    init(dateService: DateService = DefaultDateService()) {
        self.dateService = dateService
    }
    
    // MARK: - Intents
    func loginSucceeded(username: String) {
        self.username = username
        self.isLoggedIn = true
    }
    
    func logout() {
        // TODO: revoke Spotify, clear tokens, etc
        self.username = nil
        self.isLoggedIn = false
    }
    
    func restoreIfPossible() {
        // TODO: keychain restore
    }
}
