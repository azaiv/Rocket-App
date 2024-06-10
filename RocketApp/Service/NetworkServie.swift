import Foundation
import UIKit

final class NetworkServie {
    
    static let shared =  NetworkServie()
    
    private init() { }
    
    func getRockets(completion: @escaping (Result<Rocket, NetworkError>) -> Void) {
        
        let urlString = Constants.Url.ROCKETS_URL
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let rockets = try JSONDecoder().decode(Rocket.self, from: data)
                completion(.success(rockets))
            } catch {
                completion(.failure(.invalidDecoding))
            }
        }
        
        task.resume()
        
    }
    
    func fetchImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let string = urlString,
              let url = URL(string: string) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, 
                    let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}
