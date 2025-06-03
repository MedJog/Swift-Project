import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Перейти к новостям") {
                    NewsListView()
                }
                .font(.title2)
                .padding()
            }
            .navigationTitle("Главная")
        }
    }
}

