//
//  NetworkManager.swift
//  APOD
//
//  Created by Lokesh Vyas on 31/01/22.
//

import Foundation


class NetworkService {
    
    class func request<T: Codable>(router: Router, completion: @escaping (T) -> ()) {
        
        var components = URLComponents()
        components.host = router.apiBuilder
        
        let session = URLSession(configuration: .default)
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard response != nil else {
                print("no response")
                return
            }
            guard let data = data else {
                print("no data")
                return
            }
            
            let responseObject = try? JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion((responseObject)!)
            }
        }
        dataTask.resume()
    }
}
