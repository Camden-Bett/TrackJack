//
//  FriendsView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

import SwiftUI

struct FriendsView: View {
    var isActive: Bool = true
    
    @StateObject private var vm: FriendsViewModel
    
    @State private var showAdd = false
    @State private var query = ""
    
    init(deps: AppDependencies? = nil) {
        let d = deps ?? AppDependencies(
            friendStore: MockFriendStore(),
            dateService: DefaultDateService()
        )
        _vm = StateObject(wrappedValue: FriendsViewModel(store: d.friendStore))
    }
    
    // derived list
    private var filtered: [Friend] {
        guard !query.isEmpty else { return vm.friends }
        let q = query.lowercased()
        return vm.friends.filter { f in
            f.username.lowercased().contains(q)
        }
    }
    
    var body: some View {
        content
            .navigationTitle("Friends")
            .toolbar {
                Button { showAdd = true } label: {
                    Label("Add", systemImage: "person.fill.badge.plus")
                }
            }
            .modifier(SearchIfActive(isActive: isActive, text: $query))
            .onAppear { vm.load() }
            .onDisappear { query = "" }
            .sheet(isPresented: $showAdd) {
                AddFriendSheet { username in vm.add(username: username) }
                    .presentationDetents([.medium])
            }
            .refreshable { vm.load() }
            .alert("Oops", isPresented: .constant(vm.error != nil), presenting: vm.error) { _ in
                Button("OK") { vm.error = nil }
            } message: { Text($0) }
    }
    
    @ViewBuilder
    private var content: some View {
        if vm.friends.isEmpty && !vm.isLoading {
            EmptyState(
                title: "No friends yet",
                message: "Add a friend by their username to see daily picks.",
                actionTitle: "Add Friend",
                action: { showAdd = true }
            )
        } else {
            friendsList
                .redacted(reason: vm.isLoading ? .placeholder : [])
        }
    }
    
    private var friendsList: some View {
        List {
            ForEach(filtered) { friend in
                NavigationLink {
                    FriendDetailView(friend: friend)
                } label: {
                    Text(friend.username)
                }
                .swipeActions {
                    Button(role: .destructive) { vm.remove(_friend: friend) } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        }
    }
}

private struct SearchIfActive: ViewModifier {
    let isActive: Bool
    @Binding var text: String
    func body(content: Content) -> some View {
        if isActive {
            content.searchable(text: $text, prompt: "Search friends")
        } else {
            content
        }
    }
}

#if DEBUG
#Preview {
    FriendsView()
}
#endif
