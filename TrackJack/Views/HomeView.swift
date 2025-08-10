//
//  HomeView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 7/30/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "bird.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to TrackJack!")
            Button("Tap Me")
            {
                print("Button Tapped!")
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
