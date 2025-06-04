import UIKit
import CoreData

final class FriendsViewController: UIViewController {
    private var tableView = UITableView()
    private var viewModels: [FriendViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFriendsFromCoreData()
        fetchFriends()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshFriends), for: .valueChanged)
    }

    @objc private func refreshFriends() {
        fetchFriends()
    }

    private func fetchFriends() {
        VKService.shared.fetchFriends { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }

            switch result {
            case .success(let friends):
                CoreDataManager.shared.saveFriends(friends)
                self?.updateViewModels(with: friends)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    private func loadFriendsFromCoreData() {
        let friends = CoreDataManager.shared.loadFriends()
        updateViewModels(with: friends)
    }

    private func updateViewModels(with friends: [Friend]) {
        self.viewModels = friends.map { FriendViewModel(friend: $0) }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = model.fullName
        cell.detailTextLabel?.text = model.isOnline ? "Онлайн" : "Оффлайн"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModels[indexPath.row]
        let vc = FriendProfileViewController(friendId: selected.id, name: selected.fullName)
        navigationController?.pushViewController(vc, animated: true)
    }
}
