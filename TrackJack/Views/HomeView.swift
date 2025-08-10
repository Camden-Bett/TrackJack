//
//  HomeView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 7/30/25.
//

import SwiftUI

struct HomeView: View {
    var onLogout: () -> Void = { }
    
    var body: some View {
        NavigationStack{
            VStack {
                Image(systemName: "bird.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Welcome to TrackJack!")
                Button("Log Out", action: onLogout)
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
