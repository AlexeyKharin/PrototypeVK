
import Foundation

// MARK: - Access
struct AccessResult: Codable {
    let accessToken, tokenType, refreshToken, scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
        case createdAt = "created_at"
    }
}
