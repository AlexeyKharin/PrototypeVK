
import Foundation

enum ApiType {
    //    MARK: - GetTopics
    case getTopics
    case getPopularPhoto
    case getPhotosOfTopic(topic: String, page: Int)
    
    //    MARK: - UpdatePhoto
    case likePhoto(id: String)
    case deleteLike(id: String)
    case updatePhoto(id: String)
    
    //    MARK: - Authentication
    case authentication
    case getAccessToken(code: String)
    
    //    MARK: - GetPhotosOfCollection
    case getPhotosOfCollection(id: String, page: Int)
    
    //    MARK: - Search
    case searchPhotos(condition: String, page: Int)
    case searchCollections(conition: String, page: Int)
    case searchUsers(condition: String, page: Int)
    
//    MARK: - Get user's information
    case getUserPublicProfile(username: String)
    case getPhotosOfUser(username: String, page: Int)
    case getCollectionsOfUser(username: String, page: Int)
    case getLikedPhotosByUser(username: String, page: Int)
    
    var scheme: String {
        return "https"
    }
    
    var accsessToken: String {
        
        let keyChainDataProvider = KeyChainDataProvider()
        guard let numberPhone = keyChainDataProvider.obtains().last else { return "" }
        let accsessToken = keyChainDataProvider.obtain(numberPhone: numberPhone)
        return accsessToken
    }
    
    var host: String {
        let host: String
        
        switch self {
        case .authentication, .getAccessToken:
            host = "unsplash.com"
            
        default:
            host = "api.unsplash.com"
        }
        
        return host
    }
    
    var path: String {
        
        switch self {
        case .getTopics:
            return "/topics"
            
        case .getPopularPhoto:
            return "/photos"
            
        case .getPhotosOfTopic (let topic, let page):
            return "/topics/\(topic)/photos"
            
        case .likePhoto (let id):
            return "/photos/\(id)/like"
            
        case .deleteLike(let id):
            return "/photos/\(id)/like"
            
        case .updatePhoto(let id):
            return "/photos/\(id)"
            
        case .getPhotosOfCollection(let id, _):
            return "/collections/\(id)/photos"
            
        case .authentication:
            return "/oauth/authorize"
            
        case .getAccessToken:
            return "/oauth/token"
            
        case .searchPhotos:
            return "/search/photos"
            
        case .searchCollections:
            return "/search/collections"
            
        case .searchUsers:
            return "/search/users"
            
        case .getUserPublicProfile(let username):
            return "/users/\(username)"
            
        case .getPhotosOfUser(let username, _):
            return "/users/\(username)/photos"
            
        case .getLikedPhotosByUser(let username, _):
            return "/users/\(username)/likes"
            
        case .getCollectionsOfUser(let username, _):
            return "/users/\(username)/collections"
        }
    }
    
    var headers: [String: String] {
        
        var headers: [String: String] = [:]
        
        switch self {
        case .authentication, .getAccessToken:
            break
            
        default:
            headers = ["Authorization" : "Client-ID 6r9bfSd-DT-wyG6lz1eXb3zuo6zpv8dBvr6TUMLnc6Y",  "content-type": "application/json"]
        }
        
        return  headers
    }
    
    var inputQuery: [String: String] {
        
        var inputQuery: [String : String] = [:]
        
        switch self {
        case .getTopics:
            inputQuery = [
                "page": "1",
                "per_page": "30",
                "lang": "ru"
            ]
            
        case .getPopularPhoto:
            inputQuery = [
                "page": "1",
                "per_page": "10",
                "order_by": "popular"
            ]
            
        case .getPhotosOfTopic(let topic, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "access_token" : accsessToken
            ]
            
        case .searchPhotos(let condition, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "query": condition,
                "access_token" : accsessToken
            ]
            
        case .searchCollections(let condition, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "20",
                "lang": "ru",
                "query": condition,
            ]
            
        case .searchUsers(let condition, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "query": condition,
            ]
            
        case .getPhotosOfCollection( _, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "access_token" : accsessToken
            ]
            
        case .getUserPublicProfile:
            inputQuery = [
                "lang": "ru"
            ]
            
        case .getPhotosOfUser( _, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "access_token" : accsessToken
            ]
            
        case .getCollectionsOfUser( _, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "access_token" : accsessToken
            ]
            
        case .getLikedPhotosByUser( _, let page):
            inputQuery = [
                "page": String(page),
                "per_page": "30",
                "lang": "ru",
                "access_token" : accsessToken
            ]
            
        case .likePhoto:
            inputQuery = ["access_token" : accsessToken]
            
        case .deleteLike:
            inputQuery = ["access_token" : accsessToken]
            
        case .updatePhoto(let id):
            inputQuery = ["access_token" : accsessToken, "id" : "\(id)"]
            
        case .authentication:
            inputQuery = [
                "client_id": AuthConfiguration.clientId,
                "redirect_uri": AuthConfiguration.callbackUrl,
                "response_type": AuthConfiguration.responseType,
                "scope" : "\(AuthConfiguration.scopes.public)+\(AuthConfiguration.scopes.write_likes)+\(AuthConfiguration.scopes.read_photos)+\(AuthConfiguration.scopes.write_photos)"
            ]
            
        case .getAccessToken(let code):
            inputQuery = [
                "client_id": AuthConfiguration.clientId,
                "client_secret": AuthConfiguration.clientSecret,
                "redirect_uri": AuthConfiguration.callbackUrl,
                "code" : code,
                "grant_type": AuthConfiguration.grantType
            ]
        }
        
        return inputQuery
    }
    
    var httpMethod: String {
        let httpMethod: String
        
        switch self {
            
        case .updatePhoto:
            httpMethod = "GET"
            
        case .deleteLike:
            httpMethod = "DELETE"
            
        case .likePhoto:
            httpMethod = "POST"
            
        case .getAccessToken:
            httpMethod = "POST"
            
        default:
            httpMethod = "GET"
        }
        
        return httpMethod
    }
    
    var url: URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = self.path
        urlComponents.setQueryItems(with: inputQuery)
        
        return urlComponents.url!
    }
    
    var request: URLRequest {
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = self.httpMethod
        
        print(request)
        print(url)
        
        return request
    }
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension URL {
    
    func getQueryStringParameter(_ parameter: String) -> String? {
        
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        guard let query = url.queryItems?.first(where: { $0.name == parameter }) else { return nil }
        
        return query.value
    }
}
