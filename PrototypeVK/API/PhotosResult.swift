
import Foundation

// MARK: - PhotoElement
struct PhotoElement: Decodable, Hashable {
    let id: String?
    let width, height: Int?
    let user: User?
    let urls: UrlsForPhoto?
    var likes: Int?
    let description: String?
    let createdAt: String?
    let updatedAt: String?
    var likedByUser: Bool?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
    }
    
    static func == (lhs: PhotoElement, rhs: PhotoElement) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, user, urls, likes, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case likedByUser = "liked_by_user"
    }
    
    // MARK: - Urls
    struct UrlsForPhoto: Decodable {
        let raw, full, regular, small: String?
        let thumb: String?
    }
    
    // MARK: - User
    struct User: Decodable {
        let id, username, name: String?
        let profileImage: ProfileImage?
        
        
        enum CodingKeys: String, CodingKey {
            case id, username, name
            case profileImage = "profile_image"
        }
    }
    
    // MARK: - User
    struct ProfileImage: Decodable {
        let small, medium, large: String?
    }
}

typealias PhotosResult = [PhotoElement]
