//
//  APIClient.swift
//  CondeNastTask
//
//  Created by Lokesh Vyas on 10/03/22.
//

import Foundation

class APIClient: APIClientProtocol {
    private let authManager: NetworkManagerProtocol
    
    init(authorizationManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.authManager = authorizationManager
    }
    
    func fetch<T: Codable>(request: APIData, basePath: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy, completionHandler: @escaping ((Result<T, NetworkError>) -> Void)) {
        self.authManager.startRequest(request: request, basePath: basePath) { (data, response, error) in
            
            if let _ = error{
                let errorType = NetworkError.failed
                completionHandler(.failure(errorType))
                return
            }
            
            guard let responseData = response as? HTTPURLResponse,
                let receivedData = data else{
                    let errorType = NetworkError.noResponseData
                    completionHandler(.failure(errorType))
                    return
            }
            
            let responseStatus = self.isValidResposne(response: responseData)
            switch responseStatus {
            case .success:
                do {
                    let apiResponseModel = try newJSONDecoder().decode(T.self, from: receivedData)
                    completionHandler(.success(apiResponseModel))
                } catch {
                    completionHandler(.failure(NetworkError.unableToDecodeResponseData(errorDescription: error.localizedDescription)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetch(request: APIData, basePath: String, success: @escaping NetworkSuccessHandler, failure: @escaping NetworkFailureHandler) {
        self.authManager.startRequest(request: request, basePath: basePath) { (data, response, error) in
            if let _ = error{
                let errorType = NetworkError.other(message: error?.localizedDescription)
                failure(data, response, errorType)
                return
            }
            
            guard let responseData = response as? HTTPURLResponse,
                let receivedData = data else{
                    let errorType = NetworkError.noResponseData
                    failure(data, response, errorType)
                    return
            }
            
            let responseStatus = self.isValidResposne(response: responseData)
            switch responseStatus {
            case .success:
                success(receivedData, response)
            case .failure(let error):
                failure(data, response, error)
            }
        }
    }
    
    func isValidResposne(response: HTTPURLResponse) -> Result<String, NetworkError>{
        switch response.statusCode{
        case 200...299:
            return .success("Valid Response")
        case 401:
            return .failure(NetworkError.authenticationError)
        case 500:
            return .failure(NetworkError.badRequest)
        default:
            return .failure(NetworkError.failed)
        }
    }
}


// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
