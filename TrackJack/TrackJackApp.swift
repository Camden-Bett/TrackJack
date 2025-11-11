//
//  TrackJackApp.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 7/30/25.
//

import SwiftUI

@main
struct TrackJackApp: App {
    @StateObject private var session = SessionViewModel()
    
    private let deps = AppDependencies(
        friendStore: MockFriendStore(),
        dateService: DefaultDateService()
    )
    
    var body: some Scene {
        WindowGroup {
            AuthGateView(session: session, deps: deps)
                .environmentObject(session)
                .onAppear { session.restoreIfPossible() }
        }
    }
}

struct AuthGateView: View {
    @ObservedObject var session: SessionViewModel
    let deps: AppDependencies
    
    var body: some View {
        Group {
            if session.isLoggedIn {
                RootView(onLogout: { session.logout() }, deps: deps)
            } else {
                LoginView(onSuccess: { username in
                    session.loginSucceeded(username: username)
                })
            }
        }
        .animation(.default, value: session.isLoggedIn)
    }
}

#if DEBUG
#Preview {
    AuthGateView(session: SessionViewModel(),
                 deps: AppDependencies(
                    friendStore: MockFriendStore(),
                    dateService: DefaultDateService())
    )
}
#endif
