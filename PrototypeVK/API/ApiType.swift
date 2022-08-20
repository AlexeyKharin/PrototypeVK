
import Foundation

enum ApiType {
    case getTopics
    case getPopularPhoto
    
    var scheme: String {
        
        return "https"
    }
    
    var host: String {
        switch self {
        case .getTopics:
            return "api.unsplash.com"
        case .getPopularPhoto:
            return "api.unsplash.com"
        }
    }
    
    var path: String {
        
        switch self {
        case .getTopics:
            return "/topics"
        case .getPopularPhoto:
            return "/photos"
        }
    }
    
    var headers: [String: String] {
        
        switch self {
        case .getTopics:
            let headers = ["Authorization" : "Client-ID 6r9bfSd-DT-wyG6lz1eXb3zuo6zpv8dBvr6TUMLnc6Y",  "content-type": "application/json"]
    
            return  headers
        case .getPopularPhoto:
            let headers = ["Authorization" : "Client-ID 6r9bfSd-DT-wyG6lz1eXb3zuo6zpv8dBvr6TUMLnc6Y",  "content-type": "application/json"]
    
            return  headers
        }
    }
    
    var inputQuery: [String: String] {
        
        switch self {
        case .getTopics:
            let inputQuery = [
                "page": "1",
                "per_page": "60",
                "lang": "ru"
            ]
            return inputQuery
            
        case .getPopularPhoto:
            
                let inputQuery = [
                    "page": "1",
                    "per_page": "10",
                    "order_by": "popular"
                ]
                
                return inputQuery
        }
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
        request.httpMethod = "get"
        
        return request
    }
}


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
