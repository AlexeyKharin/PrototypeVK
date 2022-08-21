
import Foundation

// MARK: - PhotoElement
struct PhotoElement: Decodable, Hashable {
    let id: String?
    let width, height: Int?
    let user: User?
    let urls: UrlsForPhoto?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
    }
    
    static func == (lhs: PhotoElement, rhs: PhotoElement) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
    
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
