import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var friends: [String] = []

    private let tableView = UITableView()
    private let groupsButton = UIButton(type: .system)
    private let photosButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Друзья"

        // Настройка таблицы
        tableView.frame = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0))
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        // Настройка кнопки групп
        groupsButton.frame = CGRect(x: 0, y: view.bounds.height - 100, width: view.bounds.width / 2, height: 50)
        groupsButton.setTitle("Показать группы", for: .normal)
        groupsButton.addTarget(self, action: #selector(showGroups), for: .touchUpInside)
        view.addSubview(groupsButton)

        // Настройка кнопки фотографий
        photosButton.frame = CGRect(x: view.bounds.width / 2, y: view.bounds.height - 100, width: view.bounds.width / 2, height: 50)
        photosButton.setTitle("Показать фотографии", for: .normal)
        photosButton.addTarget(self, action: #selector(showPhotos), for: .touchUpInside)
        view.addSubview(photosButton)

        fetchFriends()
    }

    // MARK: - Данные

    func fetchFriends() {
        guard let token = UserDefaults.standard.string(forKey: "vk_access_token") else {
            print("Токен не найден")
            return
        }

        let urlString = "https://api.vk.com/method/friends.get?access_token=\(token)&v=5.131&order=name&fields=nickname"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка запроса друзей: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let items = response["items"] as? [[String: Any]] {

                    self.friends = items.compactMap { $0["first_name"] as? String }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Не удалось распарсить JSON друзей")
                }
            } catch {
                print("Ошибка парсинга друзей: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "friendCell")
        cell.textLabel?.text = friends[indexPath.row]
        return cell
    }

    // MARK: - Actions

    @objc func showGroups() {
        let groupsVC = GroupsViewController()
        navigationController?.pushViewController(groupsVC, animated: true)
    }

    @objc func showPhotos() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
}
