import UIKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private var friends: [Friend] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Друзья"
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
        fetchFriends()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Профиль",
            style: .plain,
            target: self,
            action: #selector(openProfile)
        )
    }

    @objc private func openProfile() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    private func fetchFriends() {
        let token = Session.shared.token
        if token.isEmpty { return }

        let urlString = "https://api.vk.com/method/friends.get?access_token=\(token)&v=5.199&fields=online,first_name,last_name"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(FriendsResponse.self, from: data)
                self.friends = result.response.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Ошибка парсинга: \(error)")
            }
        }.resume()
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let onlineStatus = friend.online == 1 ? "🟢" : "⚪️"
        cell.textLabel?.text = "\(friend.firstName) \(friend.lastName) \(onlineStatus)"
        return cell
    }
}
