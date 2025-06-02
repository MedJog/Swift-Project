import UIKit

class ChatViewController: UIViewController {
    var chatName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = chatName ?? "Чат"

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Экран переписки с \(chatName ?? "пользователем")"
        label.textAlignment = .center
        label.numberOfLines = 0

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
