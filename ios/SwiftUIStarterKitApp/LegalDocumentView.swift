import SwiftUI
import WebKit

struct LegalDocumentView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {

        let web = WKWebView()

        web.load(URLRequest(url: url))

        return web
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}