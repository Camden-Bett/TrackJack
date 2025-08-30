//
//  InputFieldStyle.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 8/29/25.
//

import SwiftUI

// MARK: - Reusable input style

struct InputFieldStyle: ViewModifier {
    var isError: Bool = false
    var isFocused: Bool = false
    var corner: CGFloat = 12
    
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(isError ? Color.red : (isFocused ? .accentColor : .clear), lineWidth: 1)
            )
            .shadow(radius: isFocused ? 3 : 0)
    }
}

extension View {
    func inputFieldStyle(isError: Bool = false, isFocused: Bool = false) -> some View {
        modifier(InputFieldStyle(isError: isError, isFocused: isFocused))
    }
}
