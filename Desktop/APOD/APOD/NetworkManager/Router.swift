//
//  ApiBuilder.swift
//  APOD
//
//  Created by Lokesh Vyas on 31/01/22.
//

import Foundation

class CONSTANTS {
    static let API_KEY = "4d29fd59-f9c8-4b06-b937-93b3001c4cbd"
}

enum Router {
    
    case getAPODS(startDate: String,endDate:String)
    case getAPOD(date: String)
    
    var host: String {
        let base = "https://api.nasa.gov"
        switch self {
        case .getAPOD:
            return base
        case .getAPODS:
            return base
        }
    }
    
    var apiPath: String {
        switch self {
        case .getAPOD:
            return self.host + "/planetary/apod?api_key=\(CONSTANTS.API_KEY)"
        case .getAPODS:
            return self.host+"/planetary/apod?api_key=\(CONSTANTS.API_KEY)"
        }
    }

    var method: String {
        switch self {
        case .getAPOD,.getAPODS:
            return "GET"
        }
    }
    
    var apiBuilder:String {
        switch self {
        case .getAPODS(let startDate,let endDate):
            return apiPath + "&start_date=\(startDate)&end_date=\(endDate)"
        case .getAPOD(let date):
            return apiPath+"&date=\(date)"
        }
    }
}
