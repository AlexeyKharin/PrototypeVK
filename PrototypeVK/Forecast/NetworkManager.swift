import Foundation

enum ObtainError: Error {
    case failedConnect
    case failedDecodeData
    case failedGetGeoData
}

struct NetworkManager {
    
    static func obtainGeoData(url: URL, completion: @escaping (Result< GeoData, ObtainError>) -> Void)  {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        session.dataTask(
            with: URLRequest(url: url)
        ) { (data, response, error) in
   
            var result: Result< GeoData, ObtainError>
            
            defer {
                DispatchQueue.main.async {
                        completion(result)
                }
            }
            
            if let parsData = data {
                guard let posts = try? decoder.decode(GeoData.self, from: parsData) else {
                    result = .failure(.failedDecodeData)
                    return
                }
                result = .success(posts)
                print(response)
            } else {
                result = .failure(.failedGetGeoData)
            }
        }.resume()
    }
    
    static func obtainHourlyData(url: URL, completion: @escaping (Result< ModelHourly, ObtainError>) -> Void)  {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        session.dataTask(
            with: URLRequest(url: url)
        ) { (data, response, error) in
            
            var result: Result< ModelHourly, ObtainError>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let parsData = data {
                guard let posts = try? decoder.decode(ModelHourly.self, from: parsData) else {
                    result = .failure(.failedDecodeData)
                    return
                }
                result = .success(posts)
                print(response)
            } else {
                result = .failure(.failedConnect)
            }
        }.resume()
    }
    
    static func obtainDailyData(url: URL, completion: @escaping (Result< ModelDaily, ObtainError>) -> Void)  {
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        session.dataTask(
            with: URLRequest(url: url)
        ) { (data, response, error) in
            
            var result: Result< ModelDaily, ObtainError>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let parsData = data {
                guard let posts = try? decoder.decode(ModelDaily.self, from: parsData) else {
                    result = .failure(.failedDecodeData)
                    return
                }
                result = .success(posts)
                print(response)
            } else {
                result = .failure(.failedConnect)
            }
        }.resume()
    }
}
