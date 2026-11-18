//
//  QuickLoginView.swift
//  SwiftUIStarterKitApp
//

import SwiftUI

struct QuickLoginView: View {
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode

    @State private var agreedToTerms: Bool = false

    @State private var selectedLanguage: AppLanguage = .zh

    enum AppLanguage: String {
        case zh = "中文"
        case en = "English"
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── Navigation bar ─────────────────────────────────────────────
            HStack {
                Button(action: {
                    settings.navigateNowToQuickLogin = false
                    settings.navigateNowToLogIn = true
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }

                Spacer()

                Menu {
                    Button {
                        selectedLanguage = .zh
                        switchLanguage(.zh)
                    } label: {
                        if selectedLanguage == .zh {
                            Label("中文", systemImage: "checkmark")
                        } else {
                            Text("中文")
                        }
                    }

                    Button {
                        selectedLanguage = .en
                        switchLanguage(.en)
                    } label: {
                        if selectedLanguage == .en {
                            Label("English", systemImage: "checkmark")
                        } else {
                            Text("English")
                        }
                    }

                } label: {
                    HStack(spacing: 4) {
                        Image("language_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text("Language")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 32)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)

            Spacer().frame(height: 40)

            // ── App logo ───────────────────────────────────────────────────
            Image("authboot_app_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(12)

            Spacer()

            // ── Buttons ────────────────────────────────────────────────────
            VStack(spacing: 16) {
                // 微信登录
                Button(action: {
                    guard agreedToTerms else { showTermsAlert(); return }
                    print("WeChat login")
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Text("微信登录")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(red: 7/255, green: 193/255, blue: 96/255))
                    .cornerRadius(27)
                }

                // 一键登录
                Button(action: {
                    guard agreedToTerms else { showTermsAlert(); return }
                    settings.loggedIn = true
                }) {
                    Text("一键登录")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                        .cornerRadius(27)
                }

                // 其他方式登录
                Button(action: {
                    settings.navigateNowToQuickLogin = false
                    settings.navigateNowToLogIn = true
                }) {
                    Text("其他方式登录")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 153/255, green: 153/255, blue: 153/255))
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 32)

            // ── Terms checkbox ─────────────────────────────────────────────
            HStack(alignment: .top, spacing: 10) {
                Button(action: { agreedToTerms.toggle() }) {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(agreedToTerms ? Color(red: 7/255, green: 193/255, blue: 96/255) : Color(red: 200/255, green: 200/255, blue: 200/255), lineWidth: 1.5)
                        .background(
                            agreedToTerms
                                ? Color(red: 7/255, green: 193/255, blue: 96/255).cornerRadius(4)
                                : Color.clear.cornerRadius(4)
                        )
                        .overlay(
                            agreedToTerms
                                ? Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                : nil
                        )
                        .frame(width: 18, height: 18)
                }
                .padding(.top, 1)

                Group {
                    Text("已阅读并同意")
                        .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                    + Text("《用户协议》")
                        .foregroundColor(Color(red: 7/255, green: 193/255, blue: 96/255))
                    + Text("和")
                        .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                    + Text("《隐私政策》")
                        .foregroundColor(Color(red: 7/255, green: 193/255, blue: 96/255))
                    + Text("，允许应用统一管理本人账号信息")
                        .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                }
                .font(.system(size: 12))
                .lineSpacing(4)
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 24)

            // ── Footer links ───────────────────────────────────────────────
            HStack(spacing: 16) {
                Button("服务热线") { print("服务热线") }
                Button("举报监督电话") { print("举报监督电话") }
                Button("资质证照") { print("资质证照") }
            }
            .font(.system(size: 12))
            .foregroundColor(Color(red: 153/255, green: 153/255, blue: 153/255))

            Spacer().frame(height: 34)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private func showTermsAlert() {
        // 实际项目中可弹窗提示先勾选协议
        print("请先同意用户协议和隐私政策")
    }

    private func switchLanguage(_ language: AppLanguage) {
        print("切换语言：\(language.rawValue)")

        // TODO:
        // UserDefaults 保存语言
        // Bundle 切换语言
        // 通知整个 App 刷新
    }
}

#if DEBUG
struct QuickLoginView_Previews: PreviewProvider {
    static var previews: some View {
        QuickLoginView()
            .environmentObject(UserSettings())
    }
}
#endif
