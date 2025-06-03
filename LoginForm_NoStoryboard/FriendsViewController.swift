
import UIKit
import CoreData

class FriendsViewController: UITableViewController {

    var friends: [Friend] = []
    let coreDataManager = CoreDataManager.shared
    let networkService = VKNetworkService()
    let refresh = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Друзья"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendCell")

        refresh.addTarget(self, action: #selector(refreshFriends), for: .valueChanged)
        tableView.refreshControl = refresh

        setupActivityIndicator()

        loadFriendsFromStorage()
        loadFriendsFromNetwork(showSpinner: true)
    }

    func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }

    func loadFriendsFromStorage() {
        friends = coreDataManager.fetchFriends()
        tableView.reloadData()
    }

    @objc func refreshFriends() {
        loadFriendsFromNetwork(showSpinner: false)
    }

    func loadFriendsFromNetwork(showSpinner: Bool) {
        if showSpinner {
            showLoading(true)
        }

        networkService.fetchFriends { [weak self] result in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing()
                self?.showLoading(false)

                switch result {
                case .success(let newFriends):
                    self?.friends = newFriends
                    self?.coreDataManager.saveFriends(newFriends)
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showErrorAlert(error: error)
                }
            }
        }
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить список друзей: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        cell.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
        cell.detailTextLabel?.text = friend.online == 1 ? "Онлайн" : ""
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        let profileVC = FriendProfileViewController(friend: friend)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
