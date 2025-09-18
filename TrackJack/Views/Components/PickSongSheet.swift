//
//  PickSongSheet.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 9/17/25.
//

import SwiftUI

struct PickSongSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var artist: String
    @State private var urlText: String
    
    var onCancel: () -> Void
    var onSave: (Song) -> Void
    
    init(initial: Song?, onCancel: @escaping () -> Void, onSave: @escaping (Song) -> Void) {
        _title = State(initialValue: initial?.title ?? "")
        _artist = State(initialValue: initial?.artist ?? "")
        _urlText = State(initialValue: initial?.spotifyURL?.absoluteString ?? "")
        self.onCancel = onCancel
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Song") {
                    TextField("Title", text: $title)
                    TextField("Artist", text: $artist)
                    TextField("Spotify URL (optional)", text: $urlText)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
            }
            .navigationTitle("Pick Song")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let url = URL(string: urlText.trimmingCharacters(in: .whitespacesAndNewlines))
                        onSave(.init(title: title.trimmed, artist: artist.trimmed, spotifyURL: url))
                        dismiss()
                    }
                    .disabled(title.trimmed.isEmpty || artist.trimmed.isEmpty)
                }
            }
        }
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}

#Preview {
    PickSongSheet(initial: nil, onCancel: {}, onSave: { _ in })
}
