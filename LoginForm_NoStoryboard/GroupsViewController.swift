import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var groups: [String] = []

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Группы"

        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)

        fetchGroups()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]
        return cell
    }

    func fetchGroups() {
        guard let token = UserDefaults.standard.string(forKey: "vk_access_token") else {
            print("Токен не найден")
            return
        }

        let urlString = "https://api.vk.com/method/groups.get?access_token=\(token)&v=5.131&extended=1"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка запроса групп: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let items = response["items"] as? [[String: Any]] {

                    self.groups = items.compactMap { $0["name"] as? String }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Не удалось распарсить JSON групп")
                }
            } catch {
                print("Ошибка парсинга групп: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
