
import Foundation

struct AuthConfiguration: Encodable {
    static let responseType = "code"
    static let scopes = (public: "public", write_likes : "write_likes", read_photos: "read_photos", write_photos: "write_photos")
    static let clientId = "6r9bfSd-DT-wyG6lz1eXb3zuo6zpv8dBvr6TUMLnc6Y"
    static let clientSecret = "kRdWQQvnlxkgWZyrNKSvOCae0-7oA6U7vaebqyslNQw"
    static let callbackUrl = "urn:ietf:wg:oauth:2.0:oob"
    static let grantType = "authorization_code"
}
