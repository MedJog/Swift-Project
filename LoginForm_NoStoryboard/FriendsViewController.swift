
import UIKit

final class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private var friends: [Friend] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Друзья"
        view.backgroundColor = .systemBackground

        setupTableView()
        loadFriendsFromStorage()

        // Имитируем обновление данных через 1 сек
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchFriendsFromNetwork()
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.frame = view.bounds
        view.addSubview(tableView)

        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func loadFriendsFromStorage() {
        friends = CoreDataManager.shared.fetchFriends()
        tableView.reloadData()
    }

    @objc private func refreshPulled() {
        fetchFriendsFromNetwork()
    }

    private func fetchFriendsFromNetwork() {
        // Имитируем загрузку с сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let fakeFriends = [
                Friend(id: 1, firstName: "Анна", lastName: "Смирнова", online: 1),
                Friend(id: 2, firstName: "Иван", lastName: "Иванов", online: 0),
                Friend(id: 3, firstName: "Ольга", lastName: "Петрова", online: 1)
            ]

            self.friends = fakeFriends
            CoreDataManager.shared.saveFriends(fakeFriends)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    // MARK: - TableView DataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        cell.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
        cell.detailTextLabel?.text = friend.online == 1 ? "Online" : "Offline"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = FriendProfileViewController()
        profileVC.friend = friends[indexPath.row]
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
