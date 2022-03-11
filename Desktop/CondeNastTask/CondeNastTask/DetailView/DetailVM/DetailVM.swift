//
//  DetailVM.swift
//  CondeNastTask
//
//  Created by Lokesh Vyas on 11/03/22.
//

import Foundation

protocol DetailVMProtocol:AnyObject {
    func didSuccess(like:String,comments:String)
    func didFail()
}

class DetailVM {
    
    enum LIKECOMMENTS {
        case LIKE
        case COMMENTS
    }
    
    var _lc = LIKECOMMENTS.LIKE
    weak var delegate : DetailVMProtocol?
    var articleURL : String?
    private var dispatchGroup = DispatchGroup()
    
    func getArticleURL() -> String {
        if let articleURL = articleURL {
            let withoutSchemeURL = articleURL.replacingOccurrences(of: "https://", with: "")
            let newURL = withoutSchemeURL.replacingOccurrences(of: "/", with: "-")
            return newURL
        }
        return ""
    }
    
    func fetchLikesComments() {
        let apiClient = APIClient()
        var like:LikesData?
        var comments:CommentsData?
        
        dispatchGroup.enter()
        _lc = .LIKE
        apiClient.fetch(request: self, basePath: NETWORK_CONSTANTS.BASE_PATH_LC, keyDecodingStrategy: .useDefaultKeys, completionHandler: { (response:Result<LikesData,NetworkError>) in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    print(success)
                    like = success
                    self.dispatchGroup.leave()
                    
                }
            case .failure(_):
                self.dispatchGroup.leave()
                self.delegate?.didFail()
            }
        })
        dispatchGroup.enter()
        _lc = .COMMENTS
        apiClient.fetch(request: self, basePath: NETWORK_CONSTANTS.BASE_PATH_LC, keyDecodingStrategy: .useDefaultKeys, completionHandler: { (response:Result<CommentsData,NetworkError>) in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    print(success)
                    comments = success
                    self.dispatchGroup.leave()
                }
            case .failure(_):
                self.delegate?.didFail()
                self.dispatchGroup.leave()
            }
        })
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.delegate?.didSuccess(like: String(like?.likes ?? 0), comments: String(comments?.comments ?? 0))
        })
    }
}

extension DetailVM : APIData {
    var path: String {
        switch _lc {
        case .LIKE:
            return "likes/" + getArticleURL()
        case .COMMENTS:
            return "comments/" + getArticleURL()
        }
    }
    var method: HTTPMethod {
        .get
    }
    var parameters: RequestParams {
        return RequestParams(urlParameters: nil, bodyParameters: nil)
    }
    var headers: [String : String]? {
        return nil
    }
    var dataType: ResponseDataType {
        return .JSON
    }
}
