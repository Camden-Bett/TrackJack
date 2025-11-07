//
//  AddFriendSheet.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

import SwiftUI

struct AddFriendSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = ""
    @State private var error: String?
    
    // called when the user confirms a valid username
    let onAdd: (String) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Username") {
                    TextField("e.g. TJ, jackdaw_01", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: username) { _, new in
                            // live validate but don't nag if empty
                            if new.isEmpty { error = nil }
                            else if !UsernameValidation.isValid(new) {
                                error = "3-20 characters, a-z, 0-9, underscore only."
                            } else {
                                error = nil
                            }
                        }
                    
                    if let error {
                        Text(error).font(.footnote).foregroundStyle(.red)
                    } else {
                        Text("Only share your friend code with people you know.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Add Friend")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard UsernameValidation.isValid(username) else {
                            error = "Invalid username format"; return
                        }
                        onAdd(username)
                        dismiss()
                    }
                    .disabled(username.isEmpty || error != nil)
                }
            }
        }
    }
}

#Preview {
    AddFriendSheet { _ in }
}
