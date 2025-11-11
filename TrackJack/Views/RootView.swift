//
//  RootView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

import SwiftUI

struct RootView: View {
    let onLogout: () -> Void
    let deps: AppDependencies
    @State private var path = NavigationPath()
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationTitle("Home")
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            
            NavigationStack {
                FriendsView(deps: deps)
                    .navigationTitle("Friends")
            }
            .tabItem { Label("Friends", systemImage: "person.2.fill") }
            
            // profile tab (placeholder
            // ProfileView()
            // .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .navigationTitle("TrackJack")
        
    }
}
