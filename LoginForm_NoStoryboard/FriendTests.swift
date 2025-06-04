import XCTest
@testable import LoginForm_NoStoryboard

final class FriendTests: XCTestCase {

    func testFriendDecoding() throws {
        let json = """
        {
            "id": 1,
            "first_name": "Иван",
            "last_name": "Иванов",
            "online": 1
        }
        """.data(using: .utf8)!

        let friend = try JSONDecoder().decode(Friend.self, from: json)

        XCTAssertEqual(friend.id, 1)
        XCTAssertEqual(friend.firstName, "Иван")
        XCTAssertEqual(friend.lastName, "Иванов")
        XCTAssertEqual(friend.online, 1)
    }
}
