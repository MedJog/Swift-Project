
import UIKit

final class PhotosViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModels: [PhotoViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchPhotos()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        view.addSubview(collectionView)
    }

    private func fetchPhotos() {
        VKService.shared.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.viewModels = photos.map { PhotoViewModel(photo: $0) }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
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

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModels[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(with: model)
        return cell
    }
}
