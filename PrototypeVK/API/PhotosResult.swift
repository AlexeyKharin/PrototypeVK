
import Foundation

// MARK: - PhotoElement
struct PhotoElement: Decodable {
    let id: String?
    let width, height: Int?
    let user: User?
    let urls: UrlsForPhoto?
}

// MARK: - Urls
struct UrlsForPhoto: Decodable {
    let raw, full, regular, small: String?
    let thumb: String?
}

// MARK: - User
struct User: Decodable {
    let id, username, name: String?
}

typealias PhotosResult = [PhotoElement]
