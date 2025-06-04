import Foundation

class PhotoViewModel {
    let url: URL

    init(photo: Photo) {
        self.url = photo.url
    }
}
