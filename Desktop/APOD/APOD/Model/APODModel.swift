//
//  APODModel.swift
//  APOD
//
//  Created by Lokesh Vyas on 31/01/22.
//

import Foundation

// MARK: - APODElement
struct APOD: Codable {
    let copyright: String?
    let date, explanation: String
    let hdurl: String
    let mediaType, serviceVersion, title: String
    let imageURL: String
    var imageData:Data?

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case imageURL = "url"
        case title
    }
}

