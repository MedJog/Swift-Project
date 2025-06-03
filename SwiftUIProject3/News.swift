import Foundation

struct News: Identifiable, Decodable {
    let id: Int
    let title: String
    let publicationDate: TimeInterval

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publicationDate = "publication_date"
    }

    var publicationDateFormatted: String {
        let date = Date(timeIntervalSince1970: publicationDate)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
