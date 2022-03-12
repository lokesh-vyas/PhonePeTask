//
//  DataManager.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import Foundation


extension Decodable {
    static func fromJSON<T:Decodable>(_ fileName: String, fileExtension: String="json", bundle: Bundle = .main) throws -> T {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorResourceUnavailable)
        }

        let data = try Data(contentsOf: url)

        return try JSONDecoder().decode(T.self, from: data)
    }
}
