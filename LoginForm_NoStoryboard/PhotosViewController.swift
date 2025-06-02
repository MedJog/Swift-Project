import UIKit

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var photosURLs: [String] = []

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Фотографии"

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")

        view.addSubview(collectionView)

        fetchPhotos()
    }

    func fetchPhotos() {
        guard let token = UserDefaults.standard.string(forKey: "vk_access_token") else {
            print("Токен не найден")
            return
        }

        let urlString = "https://api.vk.com/method/photos.get?access_token=\(token)&v=5.131&album_id=profile&extended=1&photo_sizes=1"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка запроса фотографий: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let items = response["items"] as? [[String: Any]] {

                    var urls: [String] = []
                    for item in items {
                        if let sizes = item["sizes"] as? [[String: Any]],
                           let size = sizes.last,
                           let url = size["url"] as? String {
                            urls.append(url)
                        }
                    }
                    self.photosURLs = urls

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } else {
                    print("Не удалось распарсить JSON фотографий")
                }
            } catch {
                print("Ошибка парсинга фотографий: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)

        // Удаляем предыдущие картинки из ячейки
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        if let url = URL(string: photosURLs[indexPath.item]) {
            // Загрузка картинки асинхронно (просто для примера)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }

        cell.contentView.addSubview(imageView)

        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Выводим квадратные ячейки по ширине экрана на 3 колонки с отступами
        let padding: CGFloat = 10
        let availableWidth = collectionView.frame.width - padding * 4
        let widthPerItem = availableWidth / 3
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
