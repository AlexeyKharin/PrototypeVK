
import Foundation

// MARK: - Access
struct SearchResultUsers: Codable {
    
    let results: [SearchUser]?
}

// MARK: - Result
struct SearchUser: Codable, Hashable {
    
    let id, username, name: String?
    let profileImage: ProfileImage?
    
    
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case profileImage = "profile_image"
    }
    
    // MARK: - ProfileImage
    struct ProfileImage: Codable {
        let small, medium, large: String?
    }
    
    private let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
    }
    
    static func == (lhs: SearchUser, rhs: SearchUser) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}
