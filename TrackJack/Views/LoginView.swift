//
//  LoginView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 8/9/25.
//

import SwiftUI

struct LoginView: View {
    var onSuccess: () -> Void = { }
    
    // 1. MARK: - State
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var showAlert: Bool = false
    
    @AppStorage("remember") var rememberMe = false
    
    // 2. MARK: - Body
    var body: some View {
        VStack (spacing: 24) {
            // Logo placeholder
            Image(systemName: "music.note.house")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
                .padding(.bottom, 8)
            
            // Email
            TextField("Username", text: $username)
                .keyboardType(.default)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            
            // Password (with reveal button)
            ZStack(alignment: .trailing) {
                Group {
                    if isSecure {
                        SecureField("Password", text: $password)
                    } else {
                        TextField("Password", text: $password)
                    }
                }
                .textContentType(.password)
                .padding()
                
                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .padding(.trailing, 16)
                }
            }
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            
            // Login button
            Button {
                // local validation
                if username.count >= 4 && password.count >= 8 {
                    // normally call auth service here
                    onSuccess()
                } else {
                    showAlert = true
                }
            } label: {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.white)
            }
            .disabled(username.isEmpty || password.isEmpty)
            .opacity(username.isEmpty || password.isEmpty ? 0.6 : 1)
            .alert("Invalid credentials",
                   isPresented: $showAlert,
                   actions: { Button("OK", role: .cancel) { } },
                   message: {
                       Text("Check your username and password again.")
                   })
            
            // Spacer pushes content up on taller screens
            Spacer()
        }
        .padding()
    }
    
    // 3. MARK: - Helpers
    // this is where email validation would go...
    // IF I HAD ONE!
    
}

#Preview {
    LoginView()
}
