//
//  FriendStoreFirestore.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 12/3/25.
//

import FirebaseFirestore

final class FriendStoreFirestore: FriendStore {
    private let db = Firestore.firestore()
    
    func list(uid: String, onChange: @escaping ([FriendEdge]) -> Void) -> Any {
        let ref = db.collection("users").document(uid).collection("friendEdges")
            .order(by:"usernameLower")
        // return a token to stop listening later
        let listener = ref.addSnapshotListener { snap, _ in
            guard let docs = snap?.documents else { return }
            let edges = docs.compactMap { d -> FriendEdge? in
                let data = d.data()
                guard let username = data["username"] as? String,
                      let ts = data["createdAt"] as? Timestamp else { return nil }
                return FriendEdge(id: d.documentID, username: username, createdAt: ts.dateValue())
            }
            onChange(edges)
        }
        return listener // NSO (ListenerRegistration)
    }
    
    func add(uid: String, username: String) async throws {
        let lower = username.lowercased()
        let doc = db.collection("users").document(uid).collection("friendEdges").document(lower)
        try await db.runTransaction { tx, _ in
            if tx.getDocument(doc).exists { return nil } // deduplicate
            tx.setData([
                "username": username,
                "usernameLower": lower,
                "createdAt": FieldValue.serverTimestamp()
            ], forDocument: doc)
            return nil
        }
    }
    
    func remove(uid: String, canonicalId: String) async throws {
        let doc = db.collection("users").document(uid).collection("friendEdges").document(canonicalId)
        try await doc.delete()
    }
}
