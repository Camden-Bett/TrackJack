//
//  FriendStoreFirestore.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 12/3/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class FriendStoreFirestore: FriendStore {
    private let db = Firestore.firestore()
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
    }
    
    // MARK: - Helpers
    
    private func edgesCollection(for uid: String) -> CollectionReference {
        db.collection("users")
            .document(uid)
            .collection("friendEdges")
    }
    
    // MARK: - FriendStore
    
    func list() async throws -> [Friend] {
        let uid = try await authService.ensureSignedIn()
        let query = edgesCollection(for: uid)
            .order(by: "usernameLower")
        
        let snapshot = try await query.getDocumentsAsync()
        
        return snapshot.documents.compactMap { (doc) -> Friend? in
            let data = doc.data()
            guard let username = data["username"] as? String else { return nil }
            
            return Friend(username: username)
        }
    }
    
    func add(username: String) async throws -> Friend {
        guard UsernameValidation.isValid(username) else {
            throw FriendError.invalidUsername
        }
        
        let canonical = UsernameValidation.canonical(username)
        let uid = try await authService.ensureSignedIn()
        let doc = edgesCollection(for: uid).document(canonical)
        
        // check if already friends
        let existing = try await doc.getDocumentAsync()
        if existing.exists {
            throw FriendError.alreadyFriends
        }
        
        try await doc.setDataAsync([
            "username": username,
            "usernameLower": canonical,
            "createdAt": FieldValue.serverTimestamp()
        ])
        
        return Friend(username: username)
    }
    
    func remove(id: String) async throws {
        let canonical = UsernameValidation.canonical(id)
        let uid = try await authService.ensureSignedIn()
        let doc = edgesCollection(for: uid).document(canonical)
        
        let snap = try await doc.getDocumentAsync()
        guard snap.exists else {
            throw FriendError.notFound
        }
        
        try await doc.deleteAsync()
    }
}
