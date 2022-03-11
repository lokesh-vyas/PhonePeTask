//
//  TopHeadlineVM.swift
//  MachineTest
//
//  Created by Lokesh Vyas on 10/03/22.
//

import Foundation

protocol TopHeadlineVMProtocol:AnyObject {
    func didSuccess()
    func didFail()
}

class TopHeadlineVM {
    weak var delegate : TopHeadlineVMProtocol?
    var data: TopHeadline?
    
    func fetchAllData() {
        let apiClient = APIClient()
        apiClient.fetch(request: self, basePath: NETWORK_CONSTANTS.BASE_PATH, keyDecodingStrategy: .useDefaultKeys, completionHandler: { (response:Result<TopHeadline,NetworkError>) in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    print(success)
                    self.data = success
                    self.delegate?.didSuccess()
                }
            case .failure(_):
                self.delegate?.didFail()
            }
        })
    }
}

extension TopHeadlineVM : APIData {
    var path: String {
        return "v2/top-headlines"
    }
    var method: HTTPMethod {
        .get
    }
    var parameters: RequestParams {
        var urlParams: [String:String] = [String:String]()
        urlParams["country"] = "us"
        urlParams["category"] = "business"
        urlParams["apiKey"] = NETWORK_CONSTANTS.API_KEY
        return RequestParams(urlParameters: urlParams, bodyParameters: nil)
    }
    var headers: [String : String]? {
        return nil
    }
    var dataType: ResponseDataType {
        return .JSON
    }
}
