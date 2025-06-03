import SwiftUI

struct NewsListView: View {
    @State private var news: [News] = []

    var body: some View {
        List(news) { item in
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                Text(item.publicationDateFormatted)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Новости")
        .onAppear {
            NewsService.fetchNews { fetchedNews in
                self.news = fetchedNews
            }
        }
    }
}
