//
//  NetworkManager.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import Foundation


class NetworkManager  {
    private struct Constants {
      static let memoryCacheByteLimit: Int = 4 * 1024 * 1024 // 20 MB
      static let diskCacheByteLimit: Int = 20 * 1024 * 1024          // 4 MB
      static let cacheName: String = "PhonePe.cache"
    }
    
    static let shared = NetworkManager()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    private lazy var cacheResponse: URLCache = {
        URLCache.init(memoryCapacity: Constants.memoryCacheByteLimit, diskCapacity: Constants.diskCacheByteLimit, diskPath: Constants.cacheName)
    }()
    
    private init() {
    }
    
    func fetchAvatar(from avaratURL: URL, _ completion: @escaping ((Data?) -> Void)) {
        
        let request = URLRequest(url: avaratURL)
        let cacheIfExists = self.cacheResponse.cachedResponse(for: request)
        if let cacheData = cacheIfExists {
            completion(cacheData.data)
            return
        }
        
        self.urlSession.configuration.requestCachePolicy = .useProtocolCachePolicy
        let dataTask = self.urlSession.dataTask(with: avaratURL) { (data, response, error) in
            guard let jsonData = data, let responseData = response else {
                print("Error: Failed to get json data, error: \(String(describing: error))")
                completion(nil)
                return
            }
            let cacheRes = CachedURLResponse(response: responseData, data: jsonData)
            self.cacheResponse.storeCachedResponse(cacheRes, for: URLRequest(url: avaratURL))
            completion(jsonData)
        }
        dataTask.resume()
    }
}
