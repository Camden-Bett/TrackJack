//
//  FriendDetailView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

import SwiftUI

struct FriendDetailView: View {
    let friend: Friend
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // header
                VStack(spacing: 6) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 56))
                    Text("@\(friend.username)")
                        .font(.title2).bold()
                        .textSelection(.enabled)
                }
                
                // today's pick placeholder
                GroupBox("Today's Pick") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("None yet!")
                            .font(.headline)
                        Text("Once Spotify is linked, you'll see \(friend.username)'s daily track here!")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // future actions (stubbed)
                Group {
                    Button {
                        // TODO: start a compare view of today's picks? maybe this is where we put pick history...
                    } label: {
                        Label("Nudge for today's pick", systemImage: "hand.point.up.left.fill")
                    }
                    .buttonStyle(.bordered)
                    
                    Menu {
                        Button(role: .destructive) {
                            //handled from parent for now
                        } label: {
                            Label("Remove Friend", systemImage: "trash")
                        }
                        Button {
                            // TODO: block/report in a later session
                        } label: {
                            Label("Report / Block", systemImage: "exclamationmark.triangle")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
                .padding(.top, 4)
                
                Spacer(minLength: 12)
            }
            .padding()
        }
        .navigationTitle("Friend")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    FriendDetailView(friend: Friend(username: "TJ"))
}
#endif
