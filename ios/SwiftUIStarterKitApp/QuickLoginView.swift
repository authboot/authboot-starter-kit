//
//  QuickLoginView.swift
//  SwiftUIStarterKitApp
//

import SwiftUI
import WebKit
import WechatOpenSDK

struct QuickLoginView: View {
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode

    @State private var agreedToTerms: Bool = false

    @State private var selectedLanguage: AppLanguage = .zh

    enum AppLanguage: String {
        case zh = "中文"
        case en = "English"
    }

    @State private var showWebSheet = false
    @State private var webSheetURL: URL?
    @State private var webSheetTitle: String = ""

    @State private var isWeChatInstalled = false

    var body: some View {
        ZStack {
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
                if isWeChatInstalled {
                    Button(action: {
                        guard agreedToTerms else { showTermsAlert(); return }
                        print("WeChat login")

                        startWeChatLogin()
                    }) {
                        HStack(spacing: 10) {
                            Image("wechat_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)

                            Text("微信登录")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color(red: 7/255, green: 193/255, blue: 96/255))
                        .cornerRadius(27)
                    }
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
            .onAppear {
                isWeChatInstalled = WXApi.isWXAppInstalled()
                print("isWeChatInstalled: \(isWeChatInstalled)")
            }

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

                TermsTextView { url in
                    if url.scheme == "terms" {
                        webSheetTitle = "用户服务协议"
                        webSheetURL = URL(string: "https://www.authboot.com/user_agreement.html")
                        withAnimation(.easeInOut) {
                            showWebSheet = true
                        }
                    } else if url.scheme == "privacy" {
                        webSheetTitle = "隐私政策"
                        webSheetURL = URL(string: "https://www.authboot.com/pricacy_policy.html")
                        withAnimation(.easeInOut) {
                            showWebSheet = true
                        }
                    }
                }
                .frame(height: 36)
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
            
            // Custom Bottom Sheet Overlay
            if showWebSheet, let url = webSheetURL {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showWebSheet = false
                        }
                    }
                
                VStack {
                    Spacer()
                    WebSheetView(title: webSheetTitle, url: url, isPresented: $showWebSheet)
                        .frame(height: UIScreen.main.bounds.height * 0.75)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, -16) // Hide the bottom corners
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
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

    private func startWeChatLogin() {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = UUID().uuidString

        WXApi.send(req)
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

struct WebSheetView: View {
    let title: String
    let url: URL
    @Binding var isPresented: Bool
    @State private var progress: Double = 0.0

    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            ZStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                
                HStack {
                    Button(action: {
                        withAnimation {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color.white)
            
            // Progress Bar
            if progress < 1.0 {
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 7/255, green: 193/255, blue: 96/255)))
                    .frame(height: 2)
            } else {
                Divider()
            }
            
            // WebView
            InlineWebView(url: url, progress: $progress)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct InlineWebView: UIViewRepresentable {
    let url: URL
    @Binding var progress: Double

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: InlineWebView
        var webView: WKWebView?

        init(_ parent: InlineWebView) {
            self.parent = parent
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                if let wv = object as? WKWebView {
                    DispatchQueue.main.async {
                        self.parent.progress = wv.estimatedProgress
                    }
                }
            }
        }
        
        deinit {
            webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // No update logic required here for simple loading
    }
}

struct TermsTextView: UIViewRepresentable {
    var action: (URL) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = context.coordinator
        
        let fullString = "已阅读并同意《用户协议》和《隐私政策》，允许应用统一管理本人账号信息"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributedString = NSMutableAttributedString(string: fullString)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0),
            .paragraphStyle: paragraphStyle
        ]
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 7/255, green: 193/255, blue: 96/255, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle
        ]
        
        attributedString.addAttributes(normalAttributes, range: NSRange(location: 0, length: fullString.count))
        
        if let termsRange = fullString.range(of: "《用户协议》") {
            attributedString.addAttribute(.link, value: "terms://", range: NSRange(termsRange, in: fullString))
        }
        if let privacyRange = fullString.range(of: "《隐私政策》") {
            attributedString.addAttribute(.link, value: "privacy://", range: NSRange(privacyRange, in: fullString))
        }
        
        textView.linkTextAttributes = linkAttributes
        textView.attributedText = attributedString
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TermsTextView

        init(_ parent: TermsTextView) {
            self.parent = parent
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            parent.action(URL)
            return false
        }
    }
}
