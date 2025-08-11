//
//  LoginView.swift
//  TrackJack
//
//  Created by Camden Bettencourt on 8/9/25.
//

import SwiftUI

struct LoginView: View {
    // 0. MARK: - Definitions
    var onSuccess: () -> Void = { }
    
    private let minUsernameLength = 4
    private let minPasswordLength = 8
    
    struct ValidationResult {
        var usernameMessage: String?
        var passwordMessage: String?
        var isValid: Bool { usernameMessage == nil && passwordMessage == nil }
    }
    
    // 1. MARK: - State
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    
    @AppStorage("remember") var rememberMe: Bool = false
    @AppStorage("user_stored") var usernameStore: String = ""
    
    // 2. MARK: - Body
    var body: some View {
        VStack (spacing: 24) {
            // Logo placeholder
            Image(systemName: "music.note.house")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
                .padding(.bottom, 8)
            
            // Username
            TextField("Username", text: $username)
                .keyboardType(.default)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .onAppear {
                    if rememberMe, !usernameStore.isEmpty {
                        username = usernameStore
                    }
                }
                
            
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
            
            // "Remember Me" toggle
            Toggle("Remember Me", isOn: $rememberMe)
                
            // Login button
            Button {
                // local validation
                // TODO: validate no special chars in Helpers
                let res = validateUserPass(username: username, password: password)
                if res.isValid {
                    // call auth service here
                    
                    // persist username if remember me
                    if rememberMe {
                        usernameStore = username
                    } else {
                        usernameStore = "" // don't keep stale values
                    }
                    
                    onSuccess()
                } else {
                    alertText = [res.usernameMessage, res.passwordMessage]
                        .compactMap{$0}
                        .joined(separator: "\n")
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
            .alert("Invalid Credentials",
                   isPresented: $showAlert,
                   actions: { Button("OK", role: .cancel) { } },
                   message: {
                       Text(alertText)
                   })
            
            // Spacer pushes content up on taller screens
            Spacer()
        }
        .padding()
    }
    
    // 3. MARK: - Helpers
    private func validateUserPass(username: String, password: String) -> ValidationResult {
        var result = ValidationResult()
        
        // check username length + alphanumerics
        let trimmedUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedUser.count < minUsernameLength {
            result.usernameMessage = "Username must be at least \(minUsernameLength) characters."
        } else if trimmedUser.rangeOfCharacter(from :CharacterSet.alphanumerics.inverted) != nil {
            result.usernameMessage = "Username can only include letters and numbers."
        }
        
        // check password length
        if password.count < minPasswordLength {
            result.passwordMessage = "Password must be at least \(minPasswordLength) characters."
        }
        
        return result
    }
    
}

#Preview {
    LoginView()
}
