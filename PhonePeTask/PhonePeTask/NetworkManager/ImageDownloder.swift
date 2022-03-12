//
//  ImageDownloder.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import Foundation
import UIKit

class ImageDownloader {
    
    static let shared = ImageDownloader()
    static let IMAGE_PATH = "https://image.tmdb.org/t/p/w500"
    
    func avatarImage(avatarSourceURL: String, _ completion: @escaping ((UIImage?) -> Void)) {
        
        if let urlImage = URL(string: (ImageDownloader.IMAGE_PATH + avatarSourceURL)) {
            NetworkManager.shared.fetchAvatar(from: urlImage, { [weak self] (data: Data?) in
                if let imageData = data {
                    completion(UIImage(data: imageData))
                }
                else {
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
}
