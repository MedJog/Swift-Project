import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var news: [NewsItem] = []

    func fetchNews() async {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/news/?lang=ru&page_size=10") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
            news = decoded.results
        } catch {
            print("Ошибка при загрузке новостей: \(error)")
        }
    }
}
