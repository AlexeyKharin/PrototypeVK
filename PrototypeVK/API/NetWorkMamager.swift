
import Foundation

enum ObtainError: Error {
    case failedConnect
    case failedDecodeData
    case failedGetGetData(debugDescription: String)
    case unAuthorized
}

class NetWorkMamager {
    
    static func obtainData<T: Decodable>(request: URLRequest, type: T.Type, completion: @escaping (Result< T, ObtainError>) -> Void)  {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        session.dataTask(with: request) { (data, response, error) in
            
            var result: Result<T, ObtainError>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200  {
//                                print(httpResponse.statusCode)
//                                print(httpResponse)
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401  {
                print(httpResponse.statusCode)
                result = .failure(.unAuthorized)
                return
                
            }
            
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                result = .failure(.failedGetGetData(debugDescription: error.localizedDescription))
            }
            
            if let parsaData = data {
                guard let posts = try? decoder.decode(type.self, from: parsaData) else {
                    //                    print(String(data: parsaData, encoding: .utf8) ?? "empty data")
                    result = .failure(.failedDecodeData)
                    return
                }
                
                result = .success(posts)
                
            } else {
                
                result = .failure(.failedConnect)
            }
        
        }.resume()
    }
}

