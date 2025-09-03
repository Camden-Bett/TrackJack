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
        let shape = RoundedRectangle(cornerRadius: corner, style: .continuous)
        
        content
            .padding(12)
            .background(
                shape
                    .fill(.thinMaterial)
                    .shadow(radius: isFocused ? 6 : 0)
            )
            .overlay(
                shape.stroke(isError ? Color.red : (isFocused ? .accentColor : .clear), lineWidth: 1)
            )
            .clipShape(shape)
    }
}

extension View {
    func inputFieldStyle(isError: Bool = false, isFocused: Bool = false) -> some View {
        modifier(InputFieldStyle(isError: isError, isFocused: isFocused))
    }
}
