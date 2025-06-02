import UIKit

class LoginViewController: UIViewController {

    let loginField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
    }

    private func setupUI() {
        loginField.translatesAutoresizingMaskIntoConstraints = false
        loginField.placeholder = "Логин"
        loginField.borderStyle = .roundedRect

        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Пароль"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Войти", for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        view.addSubview(loginField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            loginField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: loginField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: loginField.trailingAnchor),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30)
        ])
    }

    @objc func loginTapped() {
        let chatListVC = ChatListViewController()
        let navController = UINavigationController(rootViewController: chatListVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
