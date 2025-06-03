import UIKit

class FriendProfileViewController: UIViewController {

    private let friend: Friend

    init(friend: Friend) {
        self.friend = friend
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "\(friend.firstName) \(friend.lastName)"
        setupUI()
    }

    private func setupUI() {
        let nameLabel = UILabel()
        nameLabel.text = "\(friend.firstName) \(friend.lastName)"
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let onlineLabel = UILabel()
        onlineLabel.text = friend.online == 1 ? "Онлайн" : "Оффлайн"
        onlineLabel.textColor = friend.online == 1 ? .systemGreen : .systemGray
        onlineLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameLabel)
        view.addSubview(onlineLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            onlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onlineLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20)
        ])
    }
}
