import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("Перейти к новостям") {
                    NewsListView()
                }
                .font(.title2)
                .padding()

                NavigationLink("Профиль") {
                    ProfileView()
                }
                .font(.title2)
                .padding()
            }
            .navigationTitle("Главная")
        }
    }
}

