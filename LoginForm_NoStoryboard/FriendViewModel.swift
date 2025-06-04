import Foundation

class FriendViewModel {
    let id: Int
    let fullName: String
    let isOnline: Bool

    init(friend: Friend) {
        self.id = friend.id
        self.fullName = "\(friend.firstName) \(friend.lastName)"
        self.isOnline = friend.online == 1
    }
}
