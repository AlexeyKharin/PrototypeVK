
import Foundation

// MARK: - PublicUserInformation
struct PublicUserInformation: Codable {
    let id: String?
    let username, name, firstName, lastName: String?
    let instagramUsername, twitterUsername: String?
    let profileImage: ProfileImage?
    let totalLikes, totalPhotos, totalCollections: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case profileImage = "profile_image"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        
    }
    
    // MARK: - ProfileImage
    struct ProfileImage: Codable {
        let small, medium, large: String?
    }
}
