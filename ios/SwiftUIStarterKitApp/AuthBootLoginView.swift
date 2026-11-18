//
//  AuthBootLoginView.swift
//  SwiftUIStarterKitApp
//

import SwiftUI

enum LoginMode {
    case emailPassword
    case phone
}

struct AuthBootLoginView: View {
    @EnvironmentObject var settings: UserSettings

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false

    @State private var loginMode: LoginMode = .emailPassword
    @State private var phone: String = ""
    @State private var smsCode: String = ""
    @State private var codeSent: Bool = false
    @State private var countdown: Int = 0
    @State private var countdownTimer: Timer? = nil

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Logo ──────────────────────────────────────────────────
                    Image("authboot_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 69)
                        .padding(.top, 60)
                        .padding(.bottom, 32)

                    // ── Title & subtitle ──────────────────────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sign in to your Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 26/255, green: 28/255, blue: 30/255))
                            .lineSpacing(4)

                        Text(loginMode == .emailPassword
                             ? "Enter your email and password to log in"
                             : "Enter your phone number to receive a verification code")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))
                            .animation(.easeInOut, value: loginMode)
                    }
                    .padding(.bottom, 32)

                    // ── Form fields ───────────────────────────────────────────
                    if loginMode == .emailPassword {
                        emailPasswordFields
                    } else {
                        phoneFields
                    }

                    // ── Log In button ─────────────────────────────────────────
                    Button(action: {
                        settings.loggedIn = true
                        settings.navigateNowToLogIn = false
                        settings.navigateNowToSignup = false
                    }) {
                        Text("Log In")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color(red: 29/255, green: 97/255, blue: 231/255))
                            .cornerRadius(10)
                            .shadow(color: Color(red: 37/255, green: 62/255, blue: 167/255).opacity(0.48), radius: 2, x: 0, y: 1)
                    }
                    .padding(.bottom, 24)

                    // ── Divider with "Or" ─────────────────────────────────────
                    HStack(spacing: 16) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(red: 237/255, green: 241/255, blue: 243/255))
                        Text("Or")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(red: 237/255, green: 241/255, blue: 243/255))
                    }
                    .padding(.bottom, 24)

                    // ── Social login buttons ──────────────────────────────────
                    HStack(spacing: 15) {
                        SocialLoginButton(
                            imageName: "g.circle", useSystemImage: true,
                            tintColor: Color(red: 234/255, green: 67/255, blue: 53/255),
                            isSelected: false
                        ) { loginMode = .emailPassword }

                        SocialLoginButton(
                            imageName: "f_logo_RGB-Blue_58", useSystemImage: false,
                            tintColor: nil,
                            isSelected: false
                        ) { loginMode = .emailPassword }

                        SocialLoginButton(
                            imageName: "applelogo", useSystemImage: true,
                            tintColor: .black,
                            isSelected: false
                        ) { loginMode = .emailPassword }

                        SocialLoginButton(
                            imageName: "phone", useSystemImage: true,
                            tintColor: loginMode == .phone
                                ? Color(red: 29/255, green: 97/255, blue: 231/255)
                                : Color(red: 108/255, green: 114/255, blue: 120/255),
                            isSelected: loginMode == .phone
                        ) {
                            withAnimation(.easeInOut) { loginMode = .phone }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 16)

                    Spacer()

                    // ── Sign Up link ──────────────────────────────────────────
                    HStack(spacing: 6) {
                        Spacer()
                        Text("Don't have an account?")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))
                        Button(action: { settings.navigateNowToSignup = true }) {
                            Text("Sign Up")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 77/255, green: 129/255, blue: 231/255))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 24)
                .frame(width: geometry.size.width)
                .background(Color(red: 248/255, green: 249/255, blue: 250/255).ignoresSafeArea())
            }
            .background(Color(red: 248/255, green: 249/255, blue: 250/255).ignoresSafeArea())
        }
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    // ── Email + Password fields ───────────────────────────────────────────────
    @ViewBuilder
    private var emailPasswordFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Email")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))

            TextField("Loisbecket@gmail.com", text: $email)
                .font(.system(size: 14, weight: .medium))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 14)
                .frame(height: 46)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 237/255, green: 241/255, blue: 243/255), lineWidth: 1))
                .shadow(color: Color(red: 228/255, green: 229/255, blue: 231/255).opacity(0.24), radius: 1, x: 0, y: 1)
        }
        .padding(.bottom, 16)

        VStack(alignment: .leading, spacing: 2) {
            Text("Password")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))

            HStack {
                Group {
                    if isPasswordVisible {
                        TextField("*******", text: $password)
                    } else {
                        SecureField("*******", text: $password)
                    }
                }
                .font(.system(size: 14, weight: .medium))
                .autocapitalization(.none)
                .disableAutocorrection(true)

                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .resizable().scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 237/255, green: 241/255, blue: 243/255), lineWidth: 1))
            .shadow(color: Color(red: 228/255, green: 229/255, blue: 231/255).opacity(0.24), radius: 1, x: 0, y: 1)
        }
        .padding(.bottom, 8)

        HStack {
            Spacer()
            Button(action: { print("Forgot password") }) {
                Text("Forgot Password ?")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 77/255, green: 129/255, blue: 231/255))
            }
        }
        .padding(.bottom, 24)
    }

    // ── Phone + SMS code fields ───────────────────────────────────────────────
    @ViewBuilder
    private var phoneFields: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Phone Number")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))

            HStack {
                TextField("+86 138 0000 0000", text: $phone)
                    .font(.system(size: 14, weight: .medium))
                    .keyboardType(.phonePad)

                Button(action: sendCode) {
                    Text(countdown > 0 ? "\(countdown)s" : "Send Code")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(countdown > 0 ? Color.gray : Color(red: 29/255, green: 97/255, blue: 231/255))
                }
                .disabled(phone.isEmpty || countdown > 0)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 237/255, green: 241/255, blue: 243/255), lineWidth: 1))
            .shadow(color: Color(red: 228/255, green: 229/255, blue: 231/255).opacity(0.24), radius: 1, x: 0, y: 1)
        }
        .padding(.bottom, 16)

        if codeSent {
            VStack(alignment: .leading, spacing: 2) {
                Text("Verification Code")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 108/255, green: 114/255, blue: 120/255))

                TextField("Enter 6-digit code", text: $smsCode)
                    .font(.system(size: 14, weight: .medium))
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 14)
                    .frame(height: 46)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 237/255, green: 241/255, blue: 243/255), lineWidth: 1))
                    .shadow(color: Color(red: 228/255, green: 229/255, blue: 231/255).opacity(0.24), radius: 1, x: 0, y: 1)
            }
            .padding(.bottom, 8)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }

        Spacer().frame(height: codeSent ? 24 : 32)
    }

    private func sendCode() {
        guard !phone.isEmpty else { return }
        codeSent = true
        countdown = 60
        print("Sending SMS code to \(phone)")
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown -= 1
            if countdown <= 0 { timer.invalidate() }
        }
    }
}

// ── Social login button helper ────────────────────────────────────────────────
private struct SocialLoginButton: View {
    let imageName: String
    let useSystemImage: Bool
    let tintColor: Color?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if useSystemImage {
                    Image(systemName: imageName)
                        .resizable().scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(tintColor ?? .primary)
                } else {
                    Image(imageName)
                        .resizable().scaledToFit()
                        .frame(width: 18, height: 18)
                }
            }
            .frame(width: 62.5, height: 48)
            .background(isSelected ? Color(red: 29/255, green: 97/255, blue: 231/255).opacity(0.08) : Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color(red: 29/255, green: 97/255, blue: 231/255) : Color(red: 239/255, green: 240/255, blue: 246/255), lineWidth: isSelected ? 1.5 : 1)
            )
            .shadow(color: Color(red: 244/255, green: 245/255, blue: 250/255).opacity(0.6), radius: 3, x: 0, y: -3)
        }
    }
}

#if DEBUG
struct AuthBootLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AuthBootLoginView()
            .environmentObject(UserSettings())
    }
}
#endif
