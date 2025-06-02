import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let chats = [
        ("Алексей", "Привет! Как дела?"),
        ("Мария", "Когда встречаемся?"),
        ("Иван", "Отправил документы."),
        ("Ольга", "Позвони мне."),
        ("Дмитрий", "Новая задача готова.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Чаты"
        view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - TableView DataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }

        let chat = chats[indexPath.row]
        cell.configure(with: chat.0, message: chat.1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        let chatVC = ChatViewController()
        chatVC.chatName = chat.0
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
