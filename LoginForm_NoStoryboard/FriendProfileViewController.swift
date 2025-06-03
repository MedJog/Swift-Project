import UIKit

final class FriendProfileViewController: UIViewController {

    var friend: Friend?

    private let nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Профиль друга"
        setupUI()
    }

    private func setupUI() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let friend = friend {
            nameLabel.text = "\(friend.firstName) \(friend.lastName)"
        }
    }
}
