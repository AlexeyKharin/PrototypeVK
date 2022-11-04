
import Foundation

// MARK: - Welcome
struct LikedPhoto: Codable {
    let photo: Photo
}

// MARK: - Photo
struct Photo: Codable {
    let id: String
    let width, height: Int
    let likes: Int
    let likedByUser: Bool
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id, width, height
        case likes
        case likedByUser = "liked_by_user"
        case urls
    }
}

// MARK: - PhotoLinks
struct PhotoLinks: Codable {
    let linksSelf, html, download: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
    let id, username, name: String
    let links: UserLinks
}


// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes
    }
}
