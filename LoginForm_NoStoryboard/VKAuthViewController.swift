import UIKit
import WebKit

class VKAuthViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    // 🔐 Здесь будут храниться access_token и user_id
    static var accessToken: String?
    static var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Настройка WebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)

        startAuthorization()
    }

    private func startAuthorization() {
        // 📌 Замените CLIENT_ID на ID своего VK-приложения https://vk.com/app53670850
        let clientID = "YOUR_CLIENT_ID" 
        let redirectURI = "https://oauth.vk.com/blank.html"
        let scope = "friends,groups,photos"
        let display = "mobile"
        let responseType = "token"
        let version = "5.131"

        let authURLString = "https://oauth.vk.com/authorize?client_id=\(clientID)&display=\(display)&redirect_uri=\(redirectURI)&scope=\(scope)&response_type=\(responseType)&v=\(version)"
        
        if let authURL = URL(string: authURLString) {
            let request = URLRequest(url: authURL)
            webView.load(request)
        }
    }

    // ✅ Отслеживаем переход на redirect_uri, чтобы вытащить токен
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url,
           url.absoluteString.contains("access_token") {

            if let fragment = url.fragment {
                let params = fragment.components(separatedBy: "&")
                var token = ""
                var userID = ""

                for param in params {
                    let pair = param.components(separatedBy: "=")
                    if pair.count == 2 {
                        if pair[0] == "access_token" {
                            token = pair[1]
                        } else if pair[0] == "user_id" {
                            userID = pair[1]
                        }
                    }
                }

                VKAuthViewController.accessToken = token
                VKAuthViewController.userID = userID

                print("🎉 Access Token: \(token)")
                print("👤 User ID: \(userID)")

                // ➡️ Переход к списку друзей (или другой экран)
                let friendsVC = FriendsViewController()
                navigationController?.pushViewController(friendsVC, animated: true)

                decisionHandler(.cancel)
                return
            }
        }

        decisionHandler(.allow)
    }
}
