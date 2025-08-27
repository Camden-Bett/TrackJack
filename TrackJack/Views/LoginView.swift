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
    
    enum Field { case username, password }
    
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
    
    @FocusState private var focusedField: Field?
    
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
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .onSubmit { focusedField = .password }
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
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit { attemptLogin() }
                
                Button {
                    let wasFocused = (focusedField == .password)
                    isSecure.toggle()
                    if wasFocused { focusedField = .password } // retain current focus when eye clicked
                } label: {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .padding(.trailing, 16)
                }
            }
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            
            // "Remember Me" toggle
            Toggle("Remember Me", isOn: $rememberMe)
                .onChange(of: rememberMe) {
                    usernameStore = rememberMe ? username : ""
                }
                
            // Login button
            Button {
                attemptLogin()
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // fill space
        .contentShape(Rectangle())
        .onTapGesture { focusedField = nil }
        .padding()
    }
    
    // 3. MARK: - Helpers
    // checks user and pass against validation criteria, outputs validation status and any error messages
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
    
    // controls login to TrackJack (not linked to Spotify!)
    private func attemptLogin() {
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let res = validateUserPass(username: username, password: password)
        if res.isValid {
            // call auth service here
            
            if rememberMe { usernameStore = username } else { usernameStore = "" }
            onSuccess()
        } else {
            alertText = [res.usernameMessage, res.passwordMessage]
                .compactMap{$0}
                .joined(separator: "\n")
            showAlert = true
        }
    }
    
}

#Preview {
    LoginView()
}
