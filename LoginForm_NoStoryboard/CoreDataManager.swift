import Foundation

// Заглушка вместо Core Data
final class CoreDataManager {
    static let shared = CoreDataManager()

    private(set) var storedFriends: [Friend] = []

    private init() {}

    func saveFriends(_ friends: [Friend]) {
        self.storedFriends = friends
        print("Сохранено друзей: \(friends.count)")
    }

    func fetchFriends() -> [Friend] {
        return storedFriends
    }
}
