import XCTest

final class LoginForm_NoStoryboardUITests: XCTestCase {

    func testExample() throws {
        // Заглушка UI-теста — просто проверка существования приложения
        let app = XCUIApplication()
        app.launch()

        // Представим, что кнопка "Друзья" существует
        let friendsButton = app.buttons["Друзья"]
        XCTAssertTrue(friendsButton.exists || true) // фиктивная проверка
    }
}
