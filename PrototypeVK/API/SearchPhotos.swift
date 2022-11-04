
import Foundation

struct SearchResultPhotos: Codable {
    
    let results: [SearchPhoto]?
}

// MARK: - SearchPhoto
struct SearchPhoto: Codable, Hashable {
    
    let id: String?
    let width, height: Int?
    let likes: Int?
    let likedByUser: Bool?
    let user: User?
    let urls: Urls?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case width, height
        case likes
        case likedByUser = "liked_by_user"
        case user
        case urls
        case description
    }
    
    
    // MARK: - User
    struct User: Codable {
        let id, username, name: String
        let profileImage: ProfileImage?
        
        enum CodingKeys: String, CodingKey {
            case id, username, name
            case profileImage = "profile_image"
        }
    }
    
    // MARK: - User
    struct ProfileImage: Codable {
        let small, medium, large: String?
        
    }
    
    // MARK: - Urls
    struct Urls: Codable {
        let raw, full, regular, small: String
        let thumb: String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
    }
    
    static func == (lhs: SearchPhoto, rhs: SearchPhoto) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
    
}
