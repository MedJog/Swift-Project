import SwiftUI

struct ProfileView: View {
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .light

    var body: some View {
        VStack(spacing: 20) {
            Text("Профиль пользователя")
                .font(.largeTitle)
                .foregroundColor(selectedTheme.textColor)

            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(selectedTheme.textColor)

            Picker("Выберите тему", selection: $selectedTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Spacer()
        }
        .padding()
        .background(selectedTheme.backgroundColor.ignoresSafeArea())
    }
}
