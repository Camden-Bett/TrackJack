//
//  EmptyState.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 11/6/25.
//

import SwiftUI

struct EmptyState: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2.slash")
                .font(.system(size:44))
            Text(title).font(.title3).bold()
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
