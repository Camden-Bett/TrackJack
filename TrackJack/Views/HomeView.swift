//
//  HomeView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 7/30/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionViewModel
    
    // MARK: local values
    @State private var songOfTheDay: Song? = nil
    @State private var isPickingSong = false
    
    // MARK: body
    var body: some View {
        VStack(spacing: 24) {
            
            // header
            VStack(spacing: 8) {
                Image(systemName: "bird.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .font(.system(size: 40))
                Text("Welcome to TrackJack!")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // current song (conditional view)
            Group {
                if let song = songOfTheDay {
                    CurrentSongCard(song: song) {
                        isPickingSong = true // edit
                    }
                } else {
                    VStack(spacing: 8) {
                        Text("No song picked yet.")
                            .font(.headline)
                        Button {
                            isPickingSong = true
                        } label: {
                            Label("Pick your Song of the Day", systemImage: "music.note.list")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Spacer()
            
            Button(role: .destructive) {
                session.logout()
            } label: {
                Text("Log Out").fontWeight(.semibold)
            }
        }
        .padding()
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if let u = session.username {
                    Label("@\(u)", systemImage: "person.crop.circle")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPickingSong = true
                } label: {
                    Image(systemName: songOfTheDay == nil ? "plus.circle" : "pencil.circle")
                }
                .help(songOfTheDay == nil ? "Pick your Song of the Day" : "Edit your Song of the Day")
            }
        }
        .sheet(isPresented: $isPickingSong) {
            PickSongSheet(
                initial: songOfTheDay,
                onCancel: { isPickingSong = false },
                onSave: { newSong in
                    songOfTheDay = newSong
                    isPickingSong = false
                }
            )
            .presentationDetents([.medium, .large])
        }
    }
}

// MARK: reusable component
private struct CurrentSongCard: View {
    let song: Song
    var onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Song of the Day")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(song.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(song.artist)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            HStack {
                if let url = song.spotifyURL {
                    Link(destination: url) {
                        Label("Open in Spotify", systemImage: "arrow.up.right.square")
                    }
                }
                Spacer()
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
            }
            .font(.callout)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview {
    let session = SessionViewModel()
    session.loginSucceeded(username: "tj")
    
    return NavigationStack{
        HomeView()
            .environmentObject(session)
    }
}
#endif
