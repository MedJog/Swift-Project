import Foundation

class GroupViewModel {
    let id: Int
    let name: String

    init(group: Group) {
        self.id = group.id
        self.name = group.name
    }
}
