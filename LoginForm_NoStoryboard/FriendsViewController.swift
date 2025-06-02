import UIKit

struct Friend {
    let id: Int
    let name: String
    let isOnline: Bool
}

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var friends: [Friend] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Друзья"
        view.backgroundColor = .white

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        loadFriends()
    }

    func loadFriends() {
        let token = Session.shared.token
        let userId = Session.shared.userId

        guard let url = URL(string: "https://api.vk.com/method/friends.get?user_id=\(userId)&fields=online&access_token=\(token)&v=5.131") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let items = response["items"] as? [[String: Any]] {

                    self.friends = items.compactMap {
                        guard let id = $0["id"] as? Int,
                              let firstName = $0["first_name"] as? String,
                              let lastName = $0["last_name"] as? String,
                              let isOnline = $0["online"] as? Int
                        else { return nil }

                        return Friend(id: id, name: "\(firstName) \(lastName)", isOnline: isOnline == 1)
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Ошибка при обработке JSON: \(error)")
            }
        }.resume()
    }

    // MARK: - UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = friend.name
        cell.detailTextLabel?.text = friend.isOnline ? "Онлайн" : "Оффлайн"
        cell.detailTextLabel?.textColor = friend.isOnline ? .systemGreen : .systemGray
        return cell
    }
}
