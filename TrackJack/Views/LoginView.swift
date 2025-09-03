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
    
    let fieldHeight: CGFloat = 24
    
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
    @State private var usernameError: String?
    @State private var passwordError: String?
    
    @FocusState private var focusedField: Field?
    
    @AppStorage(AppKeys.remember) var rememberMe: Bool = false
    @AppStorage(AppKeys.username) var usernameStore: String = ""
    
    // 2. MARK: - Body
    var body: some View {
        VStack (spacing: 16) {
            // Logo placeholder
            Image(systemName: "music.note.house")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
                .padding(.bottom, 8)
            
            // Username
            TextField("Username", text: $username)
                .keyboardType(.default)
                .textContentType(.username)
                .textFieldStyle(.plain)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onChange(of: username) { _, newValue in
                    usernameError = liveUsernameError(for: newValue)
                }
                .onSubmit { focusedField = .password }
                .onAppear {
                    if rememberMe, !usernameStore.isEmpty {
                        username = usernameStore
                    }
                }
                .frame(height: fieldHeight)
                .inputFieldStyle(
                    isError: usernameError != nil,
                    isFocused: focusedField == .username
                )
            
            if let msg = usernameError {
                Text(msg)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Username error: \(msg)")
            }
            
            // Password (with reveal button)
            ZStack(alignment: .trailing) {
                    if isSecure {
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onChange(of: password) { _, newValue in
                                passwordError = livePasswordError(for: newValue)
                            }
                            .onSubmit { attemptLogin() }
                    } else {
                        TextField("Password", text: $password)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onChange(of: password) { _, newValue in
                                passwordError = livePasswordError(for: newValue)
                            }
                            .onSubmit { attemptLogin() }
                    }
                
                Button {
                    let wasFocused = (focusedField == .password)
                    isSecure.toggle()
                    if wasFocused {
                        // retain current focus when eye clicked
                        DispatchQueue.main.async {
                            focusedField = .password
                        }
                    }
                } label: {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                }
            }
            .frame(height: fieldHeight)
            .inputFieldStyle(
                isError: passwordError != nil,
                isFocused: focusedField == .password
            )
            .animation(.none, value: isSecure)
            
            if let msg = passwordError {
                Text(msg)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityLabel("Password error: \(msg)")
            }
            
            // "Remember Me" toggle
            Toggle("Remember Me", isOn: $rememberMe)
                .onChange(of: rememberMe, initial: true) {
                    usernameStore = rememberMe ? username : ""
                }
            
            // Login button
            Button ("Log In", action: attemptLogin)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12))
                .foregroundColor(.white)
                .disabled(username.isEmpty || password.isEmpty)
                .opacity(username.isEmpty || password.isEmpty ? 0.6 : 1)
                .alert("Invalid Credentials",
                       isPresented: $showAlert,
                       actions: { Button("OK", role: .cancel) { } },
                       message: {
                    Text(alertText)
                })
                .accessibilityHint("Enter username and password to enable login")
            
            // Spacer pushes content up on taller screens
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // fill space
        .contentShape(Rectangle())
        .onTapGesture { focusedField = nil }
        .padding()
        .onAppear {
            if rememberMe, !usernameStore.isEmpty {
                username = usernameStore
            }
        }
    }
    
    // 3. MARK: - Helpers
    private func liveUsernameError(for u: String) -> String? {
        if u.isEmpty { return nil }
        let t = u.trimmingCharacters(in: .whitespacesAndNewlines)
        if t.count < minUsernameLength { return "Username must be at least \(minUsernameLength) characters." }
        if t.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil { return "Username can only include letters and numbers." }
        return nil
    }
    
    private func livePasswordError(for p: String) -> String? {
        if p.isEmpty { return nil }
        if p.count < minPasswordLength { return "Password must be at least \(minPasswordLength) characters." }
        return nil
    }
    
    // controls login to TrackJack (not linked to Spotify!)
    private func attemptLogin() {
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        usernameError = liveUsernameError(for: username)
        passwordError = livePasswordError(for: password)
        
        guard usernameError == nil, passwordError == nil else { return }
        if rememberMe { usernameStore = username } else { usernameStore = "" }
        
        onSuccess()
    }
}

#Preview {
    LoginView()
}
