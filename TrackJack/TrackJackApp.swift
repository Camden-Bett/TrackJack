//
//  TrackJackApp.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 7/30/25.
//

import SwiftUI

@main
struct TrackJackApp: App {
    @State private var isLoggedIn = false           // used in Unit 2
    
    var body: some Scene {
        WindowGroup {
            AuthGateView(isLoggedIn: $isLoggedIn)
        }
    }
}

struct AuthGateView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        Group {
            if isLoggedIn {
                let deps = AppDependencies(
                    friendStore: MockFriendStore(),
                    dateService: DefaultDateService()
                )
                
                RootView(onLogout: { isLoggedIn = false }, deps: deps)
            } else {
                LoginView(onSuccess: { isLoggedIn = true })
            }
        }
        .animation(.default, value: isLoggedIn)
    }
}

#Preview {
    @Previewable @State var isLoggedIn = false
    AuthGateView(isLoggedIn: $isLoggedIn)
}
