import Foundation

class NewsService {
    static func fetchNews(completion: @escaping ([News]) -> Void) {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/news/?fields=id,title,publication_date") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode([News].self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}
