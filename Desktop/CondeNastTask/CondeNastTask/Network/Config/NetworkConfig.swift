//
//  NetworkConfig.swift
//  CondeNastTask
//
//  Created by Lokesh Vyas on 10/03/22.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

public enum ResponseDataType {
    case Data
    case JSON
}

public enum Encoding: String {
    case URL
    case JSON
}

enum HeaderContentType: String {
    case json = "application/json"
}

enum HTTPHeaderKeys: String {
    case contentType = "Content-Type"
    case cookie = "Cookie"
}


public struct RequestParams {
    let urlParameters: [String: String]?
    let bodyParameters: [String: Any]?
    let contentType: HeaderContentType
    
    init(urlParameters: [String: String]?, bodyParameters: [String: Any]?, contentType: HeaderContentType = .json) {
        self.urlParameters = urlParameters
        self.bodyParameters = bodyParameters
        self.contentType = contentType
    }
}
