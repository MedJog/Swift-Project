
import UIKit

final class GroupsViewController: UIViewController {
    private var tableView = UITableView()
    private var viewModels: [GroupViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchGroups()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func fetchGroups() {
        VKService.shared.fetchGroups { [weak self] result in
            switch result {
            case .success(let groups):
                self?.viewModels = groups.map { GroupViewModel(group: $0) }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}

extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = model.name
        return cell
    }
}
