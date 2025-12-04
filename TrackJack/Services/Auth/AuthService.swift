//
//  AuthService.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/28/25.
//

import FirebaseAuth

enum AuthState {
    case signedIn(uid: String)
    case signedOut
}

final class AuthService {
    static let shared = AuthService()
    
    private(set) var state: AuthState = .signedOut
    
    func ensureSignedIn() async throws -> String {
        if let current = Auth.auth().currentUser {
            state = .signedIn(uid: current.uid)
            return current.uid
        }
        let result = try await Auth.auth().signInAnonymously()
        let uid = result.user.uid
        state = .signedIn(uid: uid)
        return uid
    }
    
    func onAuthChanges(_ handler: @escaping (AuthState) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            if let uid = user?.uid { handler(.signedIn(uid: uid)) }
            else { handler(.signedOut) }
        }
    }
}
