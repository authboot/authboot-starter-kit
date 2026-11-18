import SwiftUI
import UIKit

enum AgreementLink {
    case terms
    case privacy
}

struct AgreementText: UIViewRepresentable {

    let onTap: (AgreementLink) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    func makeUIView(context: Context) -> UITextView {

        let textView = UITextView()

        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false

        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        let normalColor = UIColor(
            red: 102 / 255,
            green: 102 / 255,
            blue: 102 / 255,
            alpha: 1
        )

        let linkColor = UIColor(
            red: 7 / 255,
            green: 193 / 255,
            blue: 96 / 255,
            alpha: 1
        )

        let attr = NSMutableAttributedString()

        func append(_ text: String,
                    color: UIColor,
                    link: String? = nil) {

            var attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: color
            ]

            if let link {
                attrs[.link] = URL(string: link)!
            }

            attr.append(NSAttributedString(
                string: text,
                attributes: attrs
            ))
        }

        append("已阅读并同意", color: normalColor)
        append("《用户协议》",
               color: linkColor,
               link: "agreement://terms")

        append("和", color: normalColor)

        append("《隐私政策》",
               color: linkColor,
               link: "agreement://privacy")

        append("，允许应用统一管理本人账号信息",
               color: normalColor)

        textView.attributedText = attr

        textView.linkTextAttributes = [
            .foregroundColor: linkColor,
            .underlineStyle: 0
        ]

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {

    }

    final class Coordinator: NSObject, UITextViewDelegate {

        let onTap: (AgreementLink) -> Void

        init(onTap: @escaping (AgreementLink) -> Void) {
            self.onTap = onTap
        }

        func textView(
            _ textView: UITextView,
            shouldInteractWith URL: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {

            switch URL.host {

            case "terms":
                onTap(.terms)

            case "privacy":
                onTap(.privacy)

            default:
                break
            }

            return false
        }
    }
}