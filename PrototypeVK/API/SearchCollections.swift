
import Foundation

// MARK: - Access
struct SearchCollections: Codable {
    let results: [SearchCollection]?
}


// MARK: - Result
struct SearchCollection: Codable, Hashable {
    let id: String?
    let title: String?
    let coverPhoto: CoverPhoto?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case coverPhoto = "cover_photo"
        
    }
    
    // MARK: - CoverPhoto
    struct CoverPhoto: Codable {
        let urls: Urls?
    }
    
    // MARK: - Urls
    struct Urls: Codable {
        let raw, full, regular, small: String?
        let thumb: String?
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        
    }
    
    static func == (lhs: SearchCollection, rhs: SearchCollection) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}
