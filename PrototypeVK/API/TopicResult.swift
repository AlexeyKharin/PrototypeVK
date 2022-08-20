
import Foundation

//MARK:- TopicResult
struct TopicResultElement: Decodable {
    let coverPhoto: CoverPhoto?
    let title: String?
    let slug: String?
    
    enum CodingKeys: String, CodingKey {
        case coverPhoto = "cover_photo"
        case title
        case slug
    }
}

//MARK:- CoverPhoto
struct CoverPhoto: Decodable {
    let width, height: Int?
    let urls: Urls?
}

// MARK: - Urls
struct Urls: Decodable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

typealias TopicResult = [TopicResultElement]
