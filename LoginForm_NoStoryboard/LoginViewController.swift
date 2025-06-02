
import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let clientID = "53670850" // Замените на свой ID приложения VK
        let redirectURI = "https://oauth.vk.com/blank.html"
        let scope = "friends"  // Запрашиваем права на список друзей

        let authURLString = "https://oauth.vk.com/authorize?client_id=\(clientID)&display=mobile&redirect_uri=\(redirectURI)&scope=\(scope)&response_type=token&v=5.131"
        guard let url = URL(string: authURLString) else { return }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    // Обработка переходов
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url,
           url.absoluteString.starts(with: "https://oauth.vk.com/blank.html") {
            if let fragment = url.fragment {
                // Парсим токен из URL-фрагмента
                let params = fragment.components(separatedBy: "&")
                var token: String?
                for param in params {
                    let parts = param.components(separatedBy: "=")
                    if parts.count == 2 && parts[0] == "access_token" {
                        token = parts[1]
                        break
                    }
                }

                if let token = token {
                    // Сохраняем токен
                    UserDefaults.standard.set(token, forKey: "vk_access_token")

                    // Переходим на экран друзей
                    DispatchQueue.main.async {
                        let friendsVC = FriendsViewController()
                        let navVC = UINavigationController(rootViewController: friendsVC)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true, completion: nil)
                    }

                    decisionHandler(.cancel)
                    return
                }
            }
        }

        decisionHandler(.allow)
    }
}
